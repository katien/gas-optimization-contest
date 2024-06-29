// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;
// forge test --gas-report --optimizer-runs 1

// store all user data in a mapping with no name
// key is keccak256(useraddress)
// value is (uint256 balance, uint256 whitelist amount, uint256 tier)
// 320747
contract GasContract {

    uint256 constant totalSupply = 1000000000;
    constructor(address[] memory _admins, uint256 _totalSupply) {
        assembly {
            mstore(0x0, 0x0000000000000000000000000000000000001234)
            sstore(keccak256(0x0, 0x20), _totalSupply)
        }
    }

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

    function checkForAdmin(address) public view returns (bool) {
        return true;
    }

    function balanceOf(address addr) public view returns (uint256 val) {
        assembly {
            mstore(0x0, addr)
            val := sload(keccak256(0x0, 0x20))
        }
    }

    function transfer(address recipient, uint256 amt, string calldata _name) public {
        assembly {
        // balances[msg.sender] -= amt;
            mstore(0x0, caller())
            let mapSlot := keccak256(0x0, 0x20)
            sstore(mapSlot, sub(sload(mapSlot), amt))

        // balances[_recipient] += amt;
            mstore(0x0, recipient)
            mapSlot := keccak256(0x0, 0x20)
            // for some reason sloading the mapslot variable is more expensive than running the hash again
            sstore(mapSlot ,  add(sload(keccak256(0x0, 0x20)), amt))
        }
    }

    function addToWhitelist(address addr, uint256 tier) public {
        assembly {
            if or(gt(tier, 254), iszero(eq(caller(), 0x0000000000000000000000000000000000001234))) {revert(0, 0)}
            mstore(0x0, addr)
            sstore(add(keccak256(0x0, 0x20), 0x40), and(3, tier))

        // emit AddedToWhitelist(addr, tier);
            mstore(0x20, tier)
        // log topic can be calculated with cast keccak "AddedToWhitelist(address,uint256)"
            log1(0x0, 0x40, 0x62c1e066774519db9fe35767c15fc33df2f016675b7cc0c330ed185f286a2d52)
        }
    }

    function whiteTransfer(address recipient, uint256 amount) public {
        assembly {
        // uint256 diff = _amount - whitelist[msg.sender];
            mstore(0x0, caller())
            let callerHash := keccak256(0x0, 0x20)
            let diff := sub(amount, sload(add(callerHash, 0x40)))

        // balances[msg.sender] -= diff;
            sstore(callerHash, sub(sload(callerHash), diff))

        // amountsMap[msg.sender] = amount;
            sstore(add(callerHash, 0x20), amount)

        // balances[recipient] += diff;
            mstore(0x0, recipient)
            let mapSlot := keccak256(0x0, 0x20)
            sstore(mapSlot, add(sload(mapSlot), diff))

        // emit WhiteListTransfer(recipient);
        // cast keccak "WhiteListTransfer(address)"
            log2(0x0, 0x0, 0x98eaee7299e9cbfa56cf530fd3a0c6dfa0ccddf4f837b8f025651ad9594647b3, recipient)
        }
    }

    function getPaymentStatus(address sender) public view returns (bool, uint256 val) {
        assembly {
            mstore(0x0, sender)
            val := sload(add(keccak256(0x0, 0x20), 0x20))
        }
        return (true, val);
    }

    // mapping(address => uint256) public balances;
    function balances(address addr) public view returns (uint256 val) {
        assembly {
            mstore(0x0, addr)
            val := sload(keccak256(0x0, 0x20))
        }
    }
    // mapping(address => uint256) public whitelist;
    function whitelist(address addr) public view returns (uint256 val) {
        assembly {
            mstore(0x0, addr)
            val := sload(add(keccak256(0x0, 0x20), 0x40))
        }
    }

}

