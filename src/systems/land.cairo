use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use dojo_examples::models::{Land, LandProperity};
use starknet::{ContractAddress, ClassHash};

// trait: specify functions to implement
#[starknet::interface]
trait ILandActions<TContractState> {
    fn user_initialize(self: @TContractState);
    fn assart(self: @TContractState);
    fn plant(self: @TContractState, land_id: usize, seed: felt252);
    fn set_seed_config(
        self: @TContractState, seed: felt252, growth_time: u64, property: LandProperity
    );
    fn is_mature(self: @TContractState, land_id: usize) -> bool;
}

#[dojo::contract]
mod land_actions {
    use core::debug::PrintTrait;
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp};
    use core::traits::PartialOrd;

    use dojo_examples::models::{Land, LandProperity, Owner, Seed, SeedOwner};
    use dojo_examples::utils::{get_land_propetry, get_seed};

    use super::ILandActions;

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        OwnerInit: OwnerInit,
        Assart: Assart,
        GetSeed: GetSeed,
        PlantSeed: PlantSeed,
    }

    #[derive(Drop, starknet::Event)]
    struct Assart {
        id: usize,
        owner: ContractAddress,
        property: LandProperity
    }

    #[derive(Drop, starknet::Event)]
    struct GetSeed {
        owner: ContractAddress,
        seed: felt252,
        amount: felt252
    }

    #[derive(Drop, starknet::Event)]
    struct OwnerInit {
        player: ContractAddress,
        initialized: bool
    }

    #[derive(Drop, starknet::Event)]
    struct PlantSeed {
        land_id: usize,
        seed: felt252
    }

    #[external(v0)]
    impl LandActionsImpl of ILandActions<ContractState> {
        fn user_initialize(self: @ContractState) {
            let world = self.world_dispatcher.read();
            let player = get_caller_address();

            let owner = get!(world, player, (Owner));

            assert(!owner.initialized, 'Initialized');

            set!(
                world,
                (
                    Owner { player, initialized: true },
                    SeedOwner { player: player, seed_name: 'NorSed', amount: 10 },
                )
            );

            emit!(world, OwnerInit { player, initialized: true });
            emit!(world, GetSeed { owner: player, seed: 'NorSed', amount: 10 });
        }

        fn assart(self: @ContractState) {
            let world = self.world_dispatcher.read();
            let owner = get_caller_address();

            let land_id = world.uuid();
            let land_prop = get_land_propetry();

            set!(
                world,
                (Land { id: land_id, owner: owner, seed: '', property: land_prop, plant_times: 0 })
            );

            emit!(world, Assart { id: land_id, owner: owner, property: land_prop });

            let seed_bool = get_seed();

            if seed_bool {
                match land_prop {
                    LandProperity::Cold(()) => {
                        set!(world, (SeedOwner { player: owner, seed_name: 'IceSed', amount: 4 }));
                        emit!(world, GetSeed { owner, seed: 'IceSed', amount: 4 });
                    },
                    LandProperity::Normal(()) => (),
                    LandProperity::Hot(()) => {
                        set!(world, (SeedOwner { player: owner, seed_name: 'HotSed', amount: 4 }));
                        emit!(world, GetSeed { owner, seed: 'HotSed', amount: 4 });
                    },
                }
            }
        }

        fn plant(self: @ContractState, land_id: usize, seed: felt252) {
            let world = self.world_dispatcher.read();
            let owner = get_caller_address();

            let mut seed_owner = get!(world, (owner, seed), (SeedOwner));
            let seed_config = get!(world, seed, (Seed));

            assert(seed_owner.amount > 0, 'Not Seed');

            seed_owner.amount -= 1;

            let mut land = get!(world, land_id, (Land));
            land.plant_times = get_block_timestamp();
            land.seed = seed;

            assert(land.owner == owner, 'Not Owner');

            let plant_cmp = land.property.into() - seed_config.property.into();

            assert(plant_cmp == 0 || plant_cmp == 1, 'Prop Plant Err');

            set!(world, (seed_owner, land));
            emit!(world, PlantSeed { land_id: land_id, seed: seed });
        }

        fn set_seed_config(
            self: @ContractState, seed: felt252, growth_time: u64, property: LandProperity
        ) {
            let world = self.world_dispatcher.read();
            let mut seed_config = get!(world, seed, (Seed));
            seed_config.growth_time = growth_time;
            seed_config.property = property;

            set!(world, (seed_config));
        }

        fn is_mature(self: @ContractState, land_id: usize) -> bool {
            let world = self.world_dispatcher.read();
            let mut land = get!(world, land_id, (Land));
            let initialized = land.owner.is_zero();

            assert(!initialized, 'Not Assart');

            let internal = get_block_timestamp() - land.plant_times;

            let seed_config = get!(world, land.seed, (Seed));

            let plant_cmp = land.property.into() - seed_config.property.into();

            if plant_cmp == 0 {
                if internal > seed_config.growth_time {
                    true
                } else {
                    false
                }
            } else {
                if internal > (seed_config.growth_time * 2) {
                    true
                } else {
                    false
                }
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use starknet::testing::{set_transaction_hash, set_block_timestamp, set_contract_address};
    use test::test_utils::assert_eq;
    use debug::PrintTrait;

    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

    use dojo::test_utils::{spawn_test_world, deploy_contract};

    use dojo_examples::models::{Land, SeedOwner, LandProperity, Seed};
    use dojo_examples::models::land;

    use super::{land_actions, ILandActionsDispatcher, ILandActionsDispatcherTrait};

    fn set_up() -> (IWorldDispatcher, ILandActionsDispatcher) {
        let caller = starknet::contract_address_const::<0x0>();

        // models
        let mut models = array![land::TEST_CLASS_HASH,];

        let world = spawn_test_world(models);

        let contract_address = world
            .deploy_contract('salt', land_actions::TEST_CLASS_HASH.try_into().unwrap());

        let land_actions_system = ILandActionsDispatcher { contract_address };

        (world, land_actions_system)
    }

    fn config_seed(system: ILandActionsDispatcher) {
        system.set_seed_config('IceSed', 36000_u64, LandProperity::Cold);
        system.set_seed_config('NormSed', 36000_u64, LandProperity::Normal);
        system.set_seed_config('HotSed', 36000_u64, LandProperity::Hot);
    }

    #[test]
    #[available_gas(30000000)]
    fn test_assart() {
        let caller = starknet::contract_address_const::<0x0>();
        let (world, land_actions_system) = set_up();

        set_transaction_hash(108);
        set_block_timestamp(2);

        land_actions_system.assart();

        let assart_land = get!(world, 0, Land);
        let seed_land = get!(world, (caller, 'IceSed'), (SeedOwner));

        assert_eq(@assart_land.owner, @caller, 'Owner Err');
        assert_eq(@assart_land.id, @0, 'Id Err');
        assert_eq(@assart_land.property.into(), @0, 'Prop Err');

        assert_eq(@seed_land.amount, @4, 'Amount Err');
    }

    #[test]
    #[available_gas(30000000)]
    fn test_user_initialize() {
        let caller = starknet::contract_address_const::<0x0>();
        let (world, land_actions_system) = set_up();

        land_actions_system.user_initialize();

        let seed_land = get!(world, (caller, 'NorSed'), (SeedOwner));

        assert_eq(@seed_land.amount, @10, 'Normal Seed');
    }

    #[test]
    #[available_gas(30000000)]
    #[should_panic(expected: ('Initialized', 'ENTRYPOINT_FAILED',))]
    fn test_dup_initialize() {
        let caller = starknet::contract_address_const::<0x0>();
        let (world, land_actions_system) = set_up();

        land_actions_system.user_initialize();
        land_actions_system.user_initialize();
    }

    #[test]
    #[available_gas(30000000)]
    fn test_plant() {
        let caller = starknet::contract_address_const::<0x1>();
        let (world, land_actions_system) = set_up();
        config_seed(land_actions_system);

        set_block_timestamp(2);

        set_contract_address(caller);
        land_actions_system.user_initialize();
        land_actions_system.assart();
        land_actions_system.plant(0, 'NorSed');

        let land = get!(world, 0, Land);

        assert_eq(@land.plant_times, @2_u64, 'Plant Time');
        assert_eq(@land.seed, @'NorSed', 'Seed');

        set_block_timestamp(36003);

        let crop_mature = land_actions_system.is_mature(0);

        assert(crop_mature, 'Not Mature');
    }

    #[test]
    #[available_gas(30000000)]
    #[should_panic(expected: ('Prop Plant Err', 'ENTRYPOINT_FAILED',))]
    fn test_fail_prop_plant() {
        let caller = starknet::contract_address_const::<0x0>();
        let (world, land_actions_system) = set_up();

        config_seed(land_actions_system);

        set_transaction_hash(108);
        land_actions_system.assart();

        let cold_land = get!(world, 0, Land);
        assert_eq(@cold_land.property.into(), @0, 'Prop Err');

        set_transaction_hash(109);
        set_block_timestamp(1);
        land_actions_system.assart();

        let hot_seed = get!(world, (caller, 'HotSed'), (SeedOwner));
        assert_eq(@hot_seed.amount, @4, 'HotSeedGetErr');

        land_actions_system.plant(0, 'HotSed');
    }

    #[test]
    #[available_gas(30000000)]
    #[should_panic(expected: ('Not Seed', 'ENTRYPOINT_FAILED',))]
    fn test_fail_plant() {
        let (world, land_actions_system) = set_up();

        land_actions_system.plant(0, 'NormSed');
    }

    #[test]
    #[available_gas(30000000)]
    fn test_set_seed_config() {
        let (world, land_actions_system) = set_up();

        let seed_name = 'NormSed';
        land_actions_system.set_seed_config(seed_name, 36000_u64, LandProperity::Normal);
        let seed_config = get!(world, seed_name, Seed);

        assert_eq(@seed_config.growth_time, @36000_u64, 'GrowthConfig');
        assert_eq(@seed_config.property.into(), @1, 'PropConfig');
    }
}
