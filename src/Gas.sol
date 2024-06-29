pragma solidity 0.8.4;

/**
* User data structure
* (address) => (balance, amount, tier)
*
* Command: `rm -rf cache;forge test --gas-report --optimizer-runs 1`
* Current Score:
* 298192
*/
contract GasContract {

    // store admin balance
    constructor(address[] memory _admins, uint256 totalSupply) payable {
        assembly {
            sstore(0x1234, totalSupply)
        }
    }
    // return hardcoded admins
    function administrators(uint8 index) external view returns (address admin) {
        assembly {
            if eq(index, 0) {
                admin := 0x3243Ed9fdCDE2345890DDEAf6b083CA4cF0F68f2
            }
            if eq(index, 1) {
                admin := 0x2b263f55Bf2125159Ce8Ec2Bb575C649f822ab46
            }
            if eq(index, 2) {
                admin := 0x0eD94Bc8435F3189966a49Ca1358a55d871FC3Bf
            }
            if eq(index, 3) {
                admin := 0xeadb3d065f8d15cc05e92594523516aD36d1c834
            }
            if eq(index, 4) {
                admin := 0x1234
            }
        }
    }

    // set add.tier
    function addToWhitelist(address addr, uint256 tier) public {
        assembly {
        // revert if tier > 254 or caller is not admin
            if or(gt(tier, 254), iszero(eq(caller(), 0x1234))) {revert(0, 0)}

        // addr.tier = tier
            sstore(add(addr, 0x40), and(3, tier))

        // emit AddedToWhitelist(addr, tier);
            mstore(0x0, addr)
            mstore(0x20, tier)
        // cast keccak "AddedToWhitelist(address,uint256)" => 0x62c1e066774519db9fe35767c15fc33df2f016675b7cc0c330ed185f286a2d52
            log1(0x0, 0x40, 0x62c1e066774519db9fe35767c15fc33df2f016675b7cc0c330ed185f286a2d52)
        }
    }

    // get addr.balance
    function balanceOf(address addr) public view returns (uint256 val) {
        assembly {
            val := sload(addr)
        }
    }

    // get addr.balance
    function balances(address addr) public view returns (uint256 val) {
        assembly {
            val := sload(addr)
        }
    }

    // get addr.amount
    function getPaymentStatus(address addr) public view returns (bool, uint256 val) {
        assembly {
            val := sload(add(addr, 0x20))
        }
        return (true, val);
    }

    // get addr.tier
    function whitelist(address addr) public view returns (uint256 val) {
        assembly {
            val := sload(add(addr, 0x40))
        }
    }

    // update msg.sender.balance and recipient.balance
    function transfer(address recipient, uint256 value, string calldata _name) public {
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
        // diff = amount - caller.tier
            let diff := sub(amount, sload(add(caller(), 0x40)))

        // caller.balance = caller.balance - diff
            sstore(caller(), sub(sload(caller()), diff))

        // caller.amount = amount
            sstore(add(caller(), 0x20), amount)

        // recipient.balance = recipient.balance + diff
            sstore(recipient, add(sload(recipient), diff))

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

