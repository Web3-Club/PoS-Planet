use dojo_examples::models::LandProperity;
use starknet::{get_block_info, get_tx_info, get_block_timestamp};

fn get_land_propetry() -> LandProperity {
    let tx_hash: u256 = get_tx_info().unbox().transaction_hash.into();

    let random_prop = tx_hash % 10;

    if random_prop == 8 {
        return LandProperity::Cold(());
    }

    if random_prop == 9 {
        return LandProperity::Hot(());
    }

    return LandProperity::Normal(());
}

fn get_seed() -> bool {
    let tx_hash: u256 = get_tx_info().unbox().transaction_hash.into();

    let random_prop: felt252 = ((tx_hash + get_block_timestamp().into()) % 10).low.into();

    match random_prop {
        0 => true,
        _ => false
    }
}

#[cfg(test)]
mod tests {
    use starknet::testing::{set_transaction_hash, set_block_timestamp};
    use test::test_utils::assert_eq;

    use super::{get_land_propetry, get_seed};

    #[test]
    #[available_gas(100000)]
    fn test_get_land_prop() {
        set_transaction_hash(101);

        let prop: felt252 = get_land_propetry().into();

        assert_eq(@prop, @1, 'Normal');
    }

    #[test]
    #[available_gas(100000)]
    fn test_get_seed() {
        set_transaction_hash(101);
        set_block_timestamp(9);

        let seed_bool = get_seed();

        assert(seed_bool, 'Seed')
    }
}
