use starknet::ContractAddress;

#[starknet::interface]
pub trait IMultiplication_offline<TContractState> {
    fn store_number1(ref self: TContractState, number1: u64);
    fn store_number2(ref self: TContractState, number2: u64);
    fn calculate(ref self: TContractState, number1: u64, number2: u64) -> u64;
}


#[starknet::contract]
mod Multiplication_offline {
    use starknet::{ContractAddress, get_caller_address, storage_access::StorageBaseAddress};

    #[storage]
    struct Storage {
        number1: u64,
        number2: u64,
        result: u64
    }

    #[abi(embed_v0)]
    impl Multiplication_offline of super::IMultiplication_offline<ContractState> {
        fn store_number1(ref self: ContractState, number1: u64) {
            self._store_number1(number1);
        }

        fn store_number2(ref self: ContractState, number2: u64) {
            self._store_number2(number2);
        }

        fn calculate(ref self: ContractState, number1: u64, number2: u64) -> u64 {
            let number1 = self.number1.read();
            let number2 = self.number2.read();
            let result_calc = number1 * number2;
            self.result.write(result_calc);
            return result_calc;
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn _store_number1(ref self: ContractState, number1: u64) {
            self.number1.write(number1);
        }

        fn _store_number2(ref self: ContractState, number2: u64) {
            self.number2.write(number2);
        }
    }
}
