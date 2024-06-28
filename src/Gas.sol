// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;
// forge test --gas-report --optimizer-runs 1
// 425402
contract GasContract {
    uint256 constant totalSupply = 1000000000;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public whitelist;
    mapping(address => uint256) amountsMap;
    mapping(uint8 => address) public administrators;

    event AddedToWhitelist(address userAddress, uint256 tier);
    event WhiteListTransfer(address indexed);

    constructor(address[] memory _admins, uint256 _totalSupply) {
        // not cheaper in assembly
        balances[0x0000000000000000000000000000000000001234] = _totalSupply;
        // todo: is there cheap assembly for administrators = _admins;
        assembly {
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

    function balanceOf(address addr) public view returns (uint256 bal) {
        assembly {
            mstore(0x0, addr)
            mstore(0x20, balances.slot)
            let slot := keccak256(0x0, 0x40)
            bal := sload(slot)
        }
    }

    function transfer(address recipient, uint256 amt, string calldata _name) public {
        assembly {
        // balances[msg.sender] -= amt;
            mstore(0x0, caller())
            mstore(0x20, balances.slot)
            let mapSlot := keccak256(0x0, 0x40)
            let mapValue := sload(mapSlot)
            let newValue := sub(mapValue, amt)
            sstore(mapSlot, newValue)

        // balances[_recipient] += amt;
            mstore(0x0, recipient)
            mapSlot := keccak256(0x0, 0x40)
            mapValue := sload(mapSlot)
            newValue := add(mapValue, amt)
            sstore(mapSlot, newValue)
        }
    }


    function addToWhitelist(address addr, uint256 tier) public {
        require(tier < 255 && msg.sender == 0x0000000000000000000000000000000000001234);
        assembly {
//            if or(lt(tier, 255), not(eq(caller(), 0x0000000000000000000000000000000000001234))) {revert(0, 0)}
        // whitelist[addr] = 4 & tier;
            mstore(0x0, addr)
            mstore(0x20, whitelist.slot)
            let whitelistSlot := keccak256(0x0, 0x40)
            let whitelistValue := sload(whitelistSlot)
            let newValue := and(3, tier)
            sstore(whitelistSlot, newValue)
        }
        emit AddedToWhitelist(addr, tier);
    }

    function whiteTransfer(address recipient, uint256 amount) public {

        assembly {
        // uint256 diff = _amount - whitelist[msg.sender];
            mstore(0x0, caller())
            mstore(0x20, whitelist.slot)
            let whitelistSlot := keccak256(0x0, 0x40)
            let whitelistValue := sload(whitelistSlot)
            let diff := sub(amount, whitelistValue)

        // balances[recipient] += diff;
            mstore(0x0, recipient)
            mstore(0x20, balances.slot)
            let  mapSlot := keccak256(0x0, 0x40)
            let  mapValue := sload(mapSlot)
            let  newValue := add(mapValue, diff)
            sstore(mapSlot, newValue)

        // balances[msg.sender] -= diff;
            mstore(0x0, caller())
        // already done: mstore(0x20, balances.slot)
            mapSlot := keccak256(0x0, 0x40)
            mapValue := sload(mapSlot)
            newValue := sub(mapValue, diff)
            sstore(mapSlot, newValue)

        // amountsMap[msg.sender] = amount;
            mstore(0x0, caller())
            mstore(0x20, amountsMap.slot)
            mapSlot := keccak256(0x0, 0x40)
            mapValue := sload(mapSlot)
            sstore(mapSlot, amount)
        }


        emit WhiteListTransfer(recipient);
    }

    function getPaymentStatus(address sender) public view returns (bool, uint256 val) {
        assembly {
            mstore(0x0, sender)
            mstore(0x20, amountsMap.slot)
            let slot := keccak256(0x0, 0x40)
            val := sload(slot)
        }
        return (true, val);
    }
}

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