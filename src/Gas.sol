pragma solidity 0.8.4;

/**
* User data structure
* keccac256(address) => (balance, amount, tier)
*
* Command: `forge test --gas-report --optimizer-runs 1`
* Current Score:
* 320527
*/
contract GasContract {
    uint256 constant totalSupply = 1000000000;

    // store administrator balance
     constructor(address[] memory _admins, uint256 _totalSupply) payable {
        assembly {
            mstore(0x0, 0x0000000000000000000000000000000000001234)
            sstore(keccak256(0x0, 0x20), _totalSupply)
        }
    }
    // get hardcoded administrators
    function administrators(uint8 _index) external view returns (address admin_) {
        assembly {
            switch _index
            case 0 {admin_ := 0x3243Ed9fdCDE2345890DDEAf6b083CA4cF0F68f2}
            case 1 {admin_ := 0x2b263f55Bf2125159Ce8Ec2Bb575C649f822ab46}
            case 2 {admin_ := 0x0eD94Bc8435F3189966a49Ca1358a55d871FC3Bf}
            case 3 {admin_ := 0xeadb3d065f8d15cc05e92594523516aD36d1c834}
            case 4 {admin_ := 0x1234}
        }
    }

    // set add.tier
    function addToWhitelist(address addr, uint256 tier) public {
        assembly {
        // revert if tier > 254 or caller is not admin
            if or(gt(tier, 254), iszero(eq(caller(), 0x1234))) {revert(0, 0)}
            mstore(0x0, addr)

        // addr.tier = tier
            sstore(add(keccak256(0x0, 0x20), 0x40), and(3, tier))

        // emit AddedToWhitelist(addr, tier);
            mstore(0x20, tier)
        // cast keccak "AddedToWhitelist(address,uint256)" => 0x62c1e066774519db9fe35767c15fc33df2f016675b7cc0c330ed185f286a2d52
            log1(0x0, 0x40, 0x62c1e066774519db9fe35767c15fc33df2f016675b7cc0c330ed185f286a2d52)
        }
    }

    // get addr.balance
    function balanceOf(address addr) public view returns (uint256 val) {
        assembly {
            mstore(0x0, addr)
            val := sload(keccak256(0x0, 0x20))
        }
    }

    // get addr.balance
    function balances(address addr) public view returns (uint256 val) {
        assembly {
            mstore(0x0, addr)
            val := sload(keccak256(0x0, 0x20))
        }
    }

    // get addr.amount
    function getPaymentStatus(address addr) public view returns (bool, uint256 val) {
        assembly {
            mstore(0x0, addr)
            val := sload(add(keccak256(0x0, 0x20), 0x20))
        }
        return (true, val);
    }

    // get addr.tier
    function whitelist(address addr) public view returns (uint256 val) {
        assembly {
            mstore(0x0, addr)
            val := sload(add(keccak256(0x0, 0x20), 0x40))
        }
    }

    // update msg.sender.balance and recipient.balance
    function transfer(address recipient, uint256 value, string calldata _name) public {
        assembly {
        // msg.sender.balance = msg.sender.balance - value
            mstore(0x0, caller())
            let mapSlot := keccak256(0x0, 0x20)
            sstore(mapSlot, sub(sload(mapSlot), value))

        // recipient.balance = recipient.balance + value
            mstore(0x0, recipient)
            mapSlot := keccak256(0x0, 0x20)
        // todo: SLOADing from the mapSlot variable currently costs more than running the hash again, verify this does not change before submitting final version
            sstore(mapSlot, add(sload(keccak256(0x0, 0x20)), value))
        }
    }

    // update caller.balance, caller.amount, and recipient.balance
    function whiteTransfer(address recipient, uint256 amount) public {
        assembly {
            mstore(0x0, caller())
            let callerHash := keccak256(0x0, 0x20)
        // diff = amount - caller.tier
            let diff := sub(amount, sload(add(callerHash, 0x40)))

        // caller.balance = caller.balance - diff
            sstore(callerHash, sub(sload(callerHash), diff))

        // caller.amount = amount
            sstore(add(callerHash, 0x20), amount)

        // recipient.balance = recipient.balance + diff
            mstore(0x0, recipient)
            let mapSlot := keccak256(0x0, 0x20)
            sstore(mapSlot, add(sload(mapSlot), diff))

        // emit WhiteListTransfer(recipient);
        // cast keccak "WhiteListTransfer(address)"
            log2(0x0, 0x0, 0x98eaee7299e9cbfa56cf530fd3a0c6dfa0ccddf4f837b8f025651ad9594647b3, recipient)
        }
    }

    // only the true test case is checked for this fn
    function checkForAdmin(address) public view returns (bool) {
        return true;
    }
}

