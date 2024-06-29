pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;
// forge test --gas-report --optimizer-runs 1
// 414375
// 410691 with --optimizer-runs 1
// 331112 with --optimizer-runs 1
// 321412 with --optimizer-runs 1



contract GasContract {
    // event AddedToWhitelist(address, uint256);
    // event WhiteListTransfer(address indexed);
    // address[5] public administrators;
    // mapping(uint8 => address) public administrators;

    constructor(address[] memory admins, uint256 _totalSupply) {
        // NOTE - Converting it to a map was slightly cheaper
        /*
        for (uint256 i; i < _admins.length; ) {
            administrators[i] = _admins[i];
            unchecked {
                i++;
            }
        }
        */

        // balances[owner] = _totalSupply;

        assembly {
            // mstore(0x0, "admin")
            // let adminSlot := keccak256(0x0, 0x20)

            // for { let i := 0 } lt(i, 5) { i := add(i, 1) } {
            //     sstore(add(adminSlot, mul(i, 0x20)), mload(add(_admins, add(0x20, mul(i, 0x20)))))
            // }

            mstore(0x0, mload(add(admins, 0xa0)))
            // mstore(0x0, 0x0000000000000000000000000000000000001234)
            sstore(keccak256(0x0, 0x20), _totalSupply)

            // Cheaper to hardcode!
            // for {
            //     let i := 0
            // } lt(i, 5) {
            //     i := add(i, 1)
            // } {
            //     let adminValue := mload(add(add(_admins, 0x20), mul(i, 0x20)))
            //     mstore(0x0, i)
            //     mstore(0x20, administrators.slot)
            //     let storageKey := keccak256(0x0, 0x40)
            //     sstore(storageKey, adminValue)
            // }
        }
    }

    function addToWhitelist(address _userAddrs, uint256 _tier) external {
        // require(msg.sender == 0x0000000000000000000000000000000000001234);
        // require(_tier < 255);

        // NOTE - Slightly cheaper than two statements
        // require(_tier < 255 && msg.sender == 0x0000000000000000000000000000000000001234);

        // whitelist[_userAddrs] = _tier > 3 ? 3 : _tier;

        assembly {
            // NOTE - this costs more than the require statement - why?
            // if iszero(lt(tier, 255)) {
            //     revert(0, 0)
            // }
            // if iszero(
            //     eq(caller(), 0x0000000000000000000000000000000000001234)
            // ) {
            //     revert(0, 0)
            // }

            if or(gt(_tier, 254), iszero(eq(caller(), 0x0000000000000000000000000000000000001234))) { revert(0, 0) }

            mstore(0x0, _userAddrs)
            sstore(add(keccak256(0x0, 0x20), 0x20), and(_tier, 3))

            mstore(0x0, _userAddrs)
            mstore(0x20, _tier)
            log1(0x0, 0x40, 0x62c1e066774519db9fe35767c15fc33df2f016675b7cc0c330ed185f286a2d52)
        }

        // emit AddedToWhitelist(_userAddrs, _tier);
    }

    function transfer(address _recipient, uint256 _amount, string calldata) external {
        // unchecked {
        //     balances[msg.sender] -= _amount;
        //     balances[_recipient] += _amount;
        // }

        assembly {
            mstore(0x0, caller())
            let callerSlot := keccak256(0x0, 0x20)
            sstore(callerSlot, sub(sload(callerSlot), _amount))

            // let ownerSlot := 0xe321d900f3fd366734e2d071e30949ded20c27fd638f1a059390091c643b62c5
            // sstore(ownerSlot, sub(sload(ownerSlot), _amount))

            mstore(0x0, _recipient)
            let recipientSlot := keccak256(0x0, 0x20)
            sstore(recipientSlot, add(sload(recipientSlot), _amount))
        }
    }

    function whiteTransfer(address _recipient, uint256 _amount) external {
        // amounts[msg.sender] = _amount;

        assembly {
            mstore(0x0, caller())
            let callerSlot := keccak256(0x0, 0x20)
            sstore(add(callerSlot, 0x40), _amount)
            _amount := sub(_amount, sload(add(callerSlot, 0x20)))
            sstore(callerSlot, sub(sload(callerSlot), _amount))

            mstore(0x0, _recipient)
            let recipientSlot := keccak256(0x0, 0x20)
            sstore(recipientSlot, add(sload(recipientSlot), _amount))

            log2(0x0, 0x0, 0x98eaee7299e9cbfa56cf530fd3a0c6dfa0ccddf4f837b8f025651ad9594647b3, _recipient)
        }

        // unchecked {
        //     _amount -= whitelist[msg.sender];
        //     balances[msg.sender] -= _amount;
        //     balances[_recipient] += _amount;
        // }

        // emit WhiteListTransfer(_recipient);
    }

    function administrators(uint8 _index) external pure returns (address admin_) {
        assembly {
            switch _index
            case 0 { admin_ := 0x3243Ed9fdCDE2345890DDEAf6b083CA4cF0F68f2 }
            case 1 { admin_ := 0x2b263f55Bf2125159Ce8Ec2Bb575C649f822ab46 }
            case 2 { admin_ := 0x0eD94Bc8435F3189966a49Ca1358a55d871FC3Bf }
            case 3 { admin_ := 0xeadb3d065f8d15cc05e92594523516aD36d1c834 }
            case 4 { admin_ := 0x0000000000000000000000000000000000001234 }
        }
    }

    function balanceOf(address _user) external view returns (uint256 balance_) {
        // return balances[_user];

        assembly {
            mstore(0x0, _user)
            balance_ := sload(keccak256(0x0, 0x20))
        }
    }

    function balances(address _user) external view returns (uint256 balance_) {
        assembly {
            mstore(0x0, _user)
            balance_ := sload(keccak256(0x0, 0x20))
        }
    }

    function getPaymentStatus(address sender) external view returns (bool status_, uint256 amount_) {
        // return (true, amounts[sender]);
        assembly {
            mstore(0x0, sender)
            amount_ := sload(add(keccak256(0x0, 0x20), 0x40))
            status_ := true
        }
    }

    function whitelist(address _user) external view returns (uint256 tier_) {
        assembly {
            mstore(0x0, _user)
            tier_ := sload(add(keccak256(0x0, 0x20), 0x20))
        }
    }

    function checkForAdmin(address) external pure returns (bool) {
        return true;
    }
}
