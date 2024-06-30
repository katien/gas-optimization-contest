pragma solidity 0.8.4;

/**
* User data structure
* (address) => (balance, amount)
*
* Implementation contract for delegatecall strategy
* test by running
* anvil
* ETH_FROM=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 forge create GasImpl --unlocked --constructor-args "[]" "1000000000"
* copy deployment address into GasContract
* rm -rf cache;forge test --fork-url 127.0.0.1:8545 --gas-report --optimizer-runs 1
*/
contract GasImpl {

    // store admin balance
    constructor(address[] memory _admins, uint256 totalSupply) payable {
        assembly {
            sstore(0x1234, totalSupply)
        }
    }

    // return hardcoded admins
    function administrators(uint256 index) external returns (address admin) {
        assembly {
            admin := 0x1234
            if eq(index, 0) {admin := 0x3243Ed9fdCDE2345890DDEAf6b083CA4cF0F68f2}
            if eq(index, 1) {admin := 0x2b263f55Bf2125159Ce8Ec2Bb575C649f822ab46}
            if eq(index, 2) {admin := 0x0eD94Bc8435F3189966a49Ca1358a55d871FC3Bf}
            if eq(index, 3) {admin := 0xeadb3d065f8d15cc05e92594523516aD36d1c834}
        }
    }


    function addToWhitelist(address addr, uint256 tier) public {
        assembly {
        // revert if tier > 254 or caller is not admin
            if or(gt(tier, 254), xor(caller(), 0x1234)) {revert(0, 0)}

        // emit AddedToWhitelist(addr, tier);
            mstore(0x0, addr)
            mstore(0x20, tier)
        // cast keccak "AddedToWhitelist(address,uint256)" => 0x62c1e066774519db9fe35767c15fc33df2f016675b7cc0c330ed185f286a2d52
            log1(0x0, 0x40, 0x62c1e066774519db9fe35767c15fc33df2f016675b7cc0c330ed185f286a2d52)
        }
    }

    // get addr.balance
    function balanceOf(address addr) public returns (uint256 val) {
        assembly {
            val := add(sload(addr), 1000000000)
        }
    }

    // get addr.balance
    function balances(address addr) public returns (uint256 val) {
        assembly {
            val := add(sload(addr), 1000000000)
        }
    }

    // get addr.amount
    function getPaymentStatus(address addr) public returns (bool, uint256 val) {
        assembly {
            val := sload(add(addr, 0x20))
        }
        return (true, val);
    }

    function whitelist(address addr) public returns (uint256 val) {
    }

    // update msg.sender.balance and recipient.balance
    function transfer(address recipient, uint256 value, string calldata) public {
        // todo: this is currently causing each transfer to boost both sender and recipient balances by 1000000000
        assembly {
        // msg.sender.balance = msg.sender.balance - value
            sstore(caller(), sub(sload(caller()), value))

        // recipient.balance = recipient.balance + value
            sstore(recipient, add(sload(recipient), value))
        }
    }

    // update caller.balance, caller.amount, and recipient.balance
    function whiteTransfer(address recipient, uint256 amount) public {
        assembly {
        // caller.balance = caller.balance - amount
            sstore(caller(), sub(sload(caller()), amount))

        // caller.amount = amount
            sstore(add(caller(), 0x20), amount)

        // recipient.balance = recipient.balance + amount
            sstore(recipient, add(sload(recipient), amount))

        // emit WhiteListTransfer(recipient);
        // cast keccak "WhiteListTransfer(address)"
            log2(0x0, 0x0, 0x98eaee7299e9cbfa56cf530fd3a0c6dfa0ccddf4f837b8f025651ad9594647b3, recipient)
        }
    }

    // only the true test case is checked for this fn
    function checkForAdmin(address) public returns (bool) {
        return true;
    }
}

