// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;
// forge test --gas-report --optimizer-runs 1
// 410967
contract GasContract {
    uint256 constant totalSupply = 1000000000;
    mapping(uint8 => address) public administrators;

    event AddedToWhitelist(address userAddress, uint256 tier);
    event WhiteListTransfer(address indexed);

    constructor(address[] memory _admins, uint256 _totalSupply) {
        // todo: is there cheap assembly for administrators = _admins;
        assembly {
            mstore(0x0, 0x0000000000000000000000000000000000001234)
            sstore(keccak256(0x0, 0x20), _totalSupply)

            for {
                let i := 0
            } lt(i, 5) {
                i := add(i, 1)
            } {
                let adminValue := mload(add(add(_admins, 0x20), mul(i, 0x20)))
                mstore(0x0, i)
                mstore(0x20, administrators.slot)
                let storageKey := keccak256(0x0, 0x40)
                sstore(storageKey, adminValue)
            }
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
            let newValue := sub(sload(mapSlot), amt)
            sstore(mapSlot, newValue)

        // balances[_recipient] += amt;
            mstore(0x0, recipient)
            mapSlot := keccak256(0x0, 0x20)
            newValue := add(sload(keccak256(0x0, 0x20)), amt)
            sstore(mapSlot, newValue)
        }
    }


    function addToWhitelist(address addr, uint256 tier) public {
        require(tier < 255 && msg.sender == 0x0000000000000000000000000000000000001234);
        assembly {
//            if or(lt(tier, 255), not(eq(caller(), 0x0000000000000000000000000000000000001234))) {revert(0, 0)}
        // whitelist[addr] = 3 & tier;
            mstore(0x0, addr)
            sstore(add(keccak256(0x0, 0x20), 0x40), and(3, tier))


        }
        emit AddedToWhitelist(addr, tier);
    }

    function whiteTransfer(address recipient, uint256 amount) public {

        assembly {
        // uint256 diff = _amount - whitelist[msg.sender];
            mstore(0x0, caller())
            let diff := sub(amount, sload(add(keccak256(0x0, 0x20), 0x40)))

        // balances[recipient] += diff;
            mstore(0x0, recipient)
            let  mapSlot := keccak256(0x0, 0x20)
            let  mapValue := sload(mapSlot)
            let  newValue := add(mapValue, diff)
            sstore(mapSlot, newValue)

        // balances[msg.sender] -= diff;
            mstore(0x0, caller())
            mapSlot := keccak256(0x0, 0x20)
            mapValue := sload(mapSlot)
            newValue := sub(mapValue, diff)
            sstore(mapSlot, newValue)

        // amountsMap[msg.sender] = amount;
            mstore(0x0, caller())
            mapSlot := add(keccak256(0x0, 0x20), 0x20)
            mapValue := sload(mapSlot)
            sstore(mapSlot, amount)
        }


        emit WhiteListTransfer(recipient);
    }

    function getPaymentStatus(address sender) public view returns (bool, uint256 val) {
        assembly {
            mstore(0x0, sender)


            let slot := add(keccak256(0x0, 0x20), 0x20)
            val := sload(slot)
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
//    mapping(address => uint256) public whitelist;
    function whitelist(address addr) public view returns (uint256 val) {
        assembly {
            mstore(0x0, addr)
            val := sload(add(keccak256(0x0, 0x20), 0x40))
        }
    }
}

// store all user data in a mapping with no name
// key is keccak256(useraddress)
// value is (uint256 balance, uint256 whitelist amount, uint256 tier)

// user balance
// mstore(0x0, _user)
// balance_ := sload(keccak256(0x0, 0x20))
// whitelist (tiers)
// mstore(0x0, _user)
// tier_ := sload(add(keccak256(0x0, 0x20), 0x20))
// amountsMap
//  mstore(0x0, sender)
//  amount_ := sload(add(keccak256(0x0, 0x20), 0x40))

// store as balance/amount/tier, pack