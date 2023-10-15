use array::ArrayTrait;
use core::debug::PrintTrait;
use starknet::ContractAddress;
use dojo::database::schema::{
    Enum, Member, Ty, Struct, SchemaIntrospection, serialize_member, serialize_member_type
};

#[derive(Serde, Copy, Drop, Introspect)]
enum LandProperity {
    Cold: (),
    Normal: (),
    Hot: (),
}

impl LandProperityPrintImpl of PrintTrait<LandProperity> {
    fn print(self: LandProperity) {
        match self {
            LandProperity::Cold(()) => 'cold'.print(),
            LandProperity::Normal(()) => 'normal'.print(),
            LandProperity::Hot(()) => 'hot'.print(),
        }
    }
}

impl LandProperityIntoFelt252 of Into<LandProperity, felt252> {
    fn into(self: LandProperity) -> felt252 {
        match self {
            LandProperity::Cold(()) => 0,
            LandProperity::Normal(()) => 1,
            LandProperity::Hot(()) => 2,
        }
    }
}

#[derive(Model, Copy, Drop, Serde)]
struct Land {
    #[key]
    id: usize,
    owner: ContractAddress,
    seed: felt252,
    property: LandProperity,
    plant_times: u64
}

#[derive(Model, Copy, Drop, Serde)]
struct Seed {
    #[key]
    name: felt252,
    growth_time: u64,
    property: LandProperity
}

#[derive(Model, Copy, Drop, Serde)]
struct Owner {
    #[key]
    player: ContractAddress,
    initialized: bool
}

#[derive(Model, Copy, Drop, Serde)]
struct SeedOwner {
    #[key]
    player: ContractAddress,
    #[key]
    seed_name: felt252,
    amount: u128
}

#[derive(Model, Copy, Drop, Serde)]
struct CropOwner {
    #[key]
    player: ContractAddress,
    #[key]
    seed_name: felt252,
    amount: u128
}

#[cfg(test)]
mod tests {
    use debug::PrintTrait;
    use super::{LandProperity, LandProperityIntoFelt252};

    #[test]
    #[available_gas(100000)]
    fn test_land_prop_into_felt252() {
        let land_prop = LandProperity::Normal(());
        let land_felt252: felt252 = land_prop.into();
        assert(land_felt252 == 1, 'Into Fail')
    }
}
