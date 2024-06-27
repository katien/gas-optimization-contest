pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;
// forge test --gas-report --optimizer-runs 1

contract GasContract {
    uint256 constant totalSupply = 1000000000;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public whitelist;
    mapping(address => uint256) whitelistMap;
    mapping(uint8 => address) public administrators;

    event AddedToWhitelist(address userAddress, uint256 tier);
    event WhiteListTransfer(address indexed);

    constructor(address[] memory _admins, uint256 _totalSupply) {
         balances[0x0000000000000000000000000000000000001234] = _totalSupply;
        // todo: is there cheap assembly for administrators = _admins;
        for (uint8 i = 0; i < 5; i++) {
            administrators[i] = _admins[i];
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

    function transfer(address _recipient, uint256 _amount, string calldata _name) public {
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
    }


    function addToWhitelist(address addr, uint256 tier) public {
        require(tier < 255 && msg.sender == 0x0000000000000000000000000000000000001234);
        whitelist[addr] = 4 & tier;
        emit AddedToWhitelist(addr, tier);
    }

    function whiteTransfer(address _recipient, uint256 _amount) public {
        uint256 diff = _amount - whitelist[msg.sender];
        balances[msg.sender] -= diff;
        balances[_recipient] += diff;
        whitelistMap[msg.sender] = _amount;
        emit WhiteListTransfer(_recipient);
    }

    function getPaymentStatus(address sender) public view returns (bool, uint256 val) {
        assembly {
            mstore(0x0, sender)
            mstore(0x20, whitelistMap.slot)
            let slot := keccak256(0x0, 0x40)
            val := sload(slot)
        }
        return (true, val);
    }
}