use starknet::ContractAddress;

#[starknet::interface]
pub trait IMultiplication_online<TContractState> {
    fn store_number1(ref self: TContractState, number1: u64);
    fn store_number2(ref self: TContractState, number2: u64);
    fn calculate(ref self: TContractState, number1: u64, number2: u64) -> u64;
}


#[starknet::contract]
mod Multiplication_online {
    use starknet::{ContractAddress, get_caller_address, storage_access::StorageBaseAddress};

    #[storage]
    struct Storage {
        number1: LegacyMap::<ContractAddress, u64>,
        number2: LegacyMap::<ContractAddress, u64>,
        result: LegacyMap::<ContractAddress, u64>
    }

    #[abi(embed_v0)]
    impl Multiplication_online of super::IMultiplication_online<ContractState> {
        fn store_number1(ref self: ContractState, number1: u64) {
            let caller = get_caller_address();
            self._store_number1(caller, number1);
        }

        fn store_number2(ref self: ContractState, number2: u64) {
            let caller = get_caller_address();
            self._store_number2(caller, number2);
        }

        fn calculate(ref self: ContractState, number1: u64, number2: u64) -> u64 {
            let caller = get_caller_address();
            let number1 = self.number1.read(caller);
            let number2 = self.number2.read(caller);
            let result_calc = number1 * number2;
            self.result.write(caller, result_calc);
            return result_calc;
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn _store_number1(ref self: ContractState, user: ContractAddress, number1: u64) {
            self.number1.write(user, number1);
        }

        fn _store_number2(ref self: ContractState, user: ContractAddress, number2: u64) {
            self.number2.write(user, number2);
        }
    }
}