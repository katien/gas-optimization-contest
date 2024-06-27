// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

contract GasContract {
    uint256 public totalSupply = 1000000000;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public whitelist;
    mapping(address => uint256) public whitelistMap;
    address[5] public administrators;
    address public contractOwner;

    event AddedToWhitelist(address userAddress, uint256 tier);
    event WhiteListTransfer(address indexed);

    constructor(address[] memory _admins, uint256 _totalSupply) {
        contractOwner = msg.sender;
        balances[contractOwner] = _totalSupply;
        // todo: is there cheap assembly for administrators = _admins;
        for (uint256 i = 0; i < administrators.length; i++) {
            administrators[i] = _admins[i];
        }
    }


    function checkForAdmin(address addr) public view returns (bool) {
        for (uint256 i = 0; i < administrators.length; i++) {
            if (administrators[i] == addr) return true;
        }
        return false;
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
        require(tier < 255);
        require(msg.sender == contractOwner || checkForAdmin(msg.sender));

        if (tier > 3) {
            whitelist[addr] = 3;
        } else {
            whitelist[addr] = tier;
        }
        emit AddedToWhitelist(addr, tier);
    }

    function whiteTransfer(address _recipient, uint256 _amount) public {
        uint256 whitelistAmount = whitelist[msg.sender];

        balances[msg.sender] = balances[msg.sender] - _amount + whitelistAmount;
        balances[_recipient] = balances[_recipient] + _amount - whitelistAmount;
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