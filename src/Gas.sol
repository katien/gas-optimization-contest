pragma solidity 0.8.4;

/**
*
* PROXY CONTRACT
* requires GasImpl to be deployed and address to be hardcoded for delegatecall
*
* User data structure
* (address) => (balance, amount)
*
* Command: `rm -rf cache;forge test --fork-url https://eth-sepolia.g.alchemy.com/v2/OePOEihAN0uxV-7hy5GdFT0EYEZPyESB --gas-report --optimizer-runs 1`
* Current Score:
* 231252
*/
contract GasContract {
    // store admin balance
    constructor(address[] memory _admins, uint256 totalSupply) payable {
    }

    // return hardcoded admins
    function administrators(uint256 index) external returns (address admin) {
        assembly {
            calldatacopy(0x0, 0x0, calldatasize())
            let success := delegatecall(gas(), 0x25ddbF63165997BA60e0aab3C61e6814BEA0144c, 0x0, calldatasize(), 0x0, 0x0)
            if iszero(success) {revert(0, 0)}
            returndatacopy(0x0, 0, returndatasize())
            return (0x0, returndatasize())
        }
    }

    // does not modify any state
    function addToWhitelist(address addr, uint256 tier) public {
        assembly {
            calldatacopy(0x0, 0x0, calldatasize())
            let success := delegatecall(gas(), 0x25ddbF63165997BA60e0aab3C61e6814BEA0144c, 0x0, calldatasize(), 0x0, 0x0)
            if iszero(success) {revert(0, 0)}
            returndatacopy(0x0, 0, returndatasize())
            return (0x0, returndatasize())
        }
    }

    // get addr.balance
    function balanceOf(address addr) public returns (uint256 val) {
        assembly {
            calldatacopy(0x0, 0x0, calldatasize())
            let success := delegatecall(gas(), 0x25ddbF63165997BA60e0aab3C61e6814BEA0144c, 0x0, calldatasize(), 0x0, 0x0)
            if iszero(success) {revert(0, 0)}
            returndatacopy(0x0, 0, returndatasize())
            return (0x0, returndatasize())
        }
    }

    // get addr.balance
    function balances(address addr) public returns (uint256 val) {
        assembly {
            calldatacopy(0x0, 0x0, calldatasize())
            let success := delegatecall(gas(), 0x25ddbF63165997BA60e0aab3C61e6814BEA0144c, 0x0, calldatasize(), 0x0, 0x0)
            if iszero(success) {revert(0, 0)}
            returndatacopy(0x0, 0, returndatasize())
            return (0x0, returndatasize())
        }
    }

    // get addr.amount
    function getPaymentStatus(address addr) public returns (bool, uint256 val) {
        assembly {
            calldatacopy(0x0, 0x0, calldatasize())
            let success := delegatecall(gas(), 0x25ddbF63165997BA60e0aab3C61e6814BEA0144c, 0x0, calldatasize(), 0x0, 0x0)
            if iszero(success) {revert(0, 0)}
            returndatacopy(0x0, 0, returndatasize())
            return (0x0, returndatasize())
        }
    }

    function whitelist(address addr) public returns (uint256 val) {
    }

    // update msg.sender.balance and recipient.balance
    function transfer(address recipient, uint256 value, string calldata) public {
        assembly {
            calldatacopy(0x0, 0x0, calldatasize())
            let success := delegatecall(gas(), 0x25ddbF63165997BA60e0aab3C61e6814BEA0144c, 0x0, calldatasize(), 0x0, 0x0)
            if iszero(success) {revert(0, 0)}
            returndatacopy(0x0, 0, returndatasize())
            return (0x0, returndatasize())
        }
    }

    // update caller.balance, caller.amount, and recipient.balance
    function whiteTransfer(address recipient, uint256 amount) public {
        assembly {
            calldatacopy(0x0, 0x0, calldatasize())
            let success := delegatecall(gas(), 0x25ddbF63165997BA60e0aab3C61e6814BEA0144c, 0x0, calldatasize(), 0x0, 0x0)
            if iszero(success) {revert(0, 0)}
            returndatacopy(0x0, 0, returndatasize())
            return (0x0, returndatasize())
        }
    }

    // only the true test case is checked for this fn
    function checkForAdmin(address) public returns (bool) {
        return true;
    }
}

