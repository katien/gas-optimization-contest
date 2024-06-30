# Group 1 Solution: 268452 gas
### **See `proxy` branch for a version that costs 231252 gas but must be run on a fork of Sepolia**
- Run via: `rm -rf cache;forge test --gas-report --optimizer-runs 1`
- Output: 

| src/Gas.sol:GasContract contract |                 |       |        |       |         |
|----------------------------------|-----------------|-------|--------|-------|---------|
| Deployment Cost                  | Deployment Size |       |        |       |         |
| 268452                           | 1529            |       |        |       |         |
| Function Name                    | min             | avg   | median | max   | # calls |
| addToWhitelist                   | 21678           | 22663 | 22987  | 23203 | 2048    |
| administrators                   | 21734           | 21742 | 21746  | 21746 | 5       |
| balanceOf                        | 23681           | 23721 | 23705  | 23921 | 1793    |
| balances                         | 23649           | 23798 | 23877  | 23877 | 1024    |
| checkForAdmin                    | 21687           | 21687 | 21687  | 21687 | 1       |
| getPaymentStatus                 | 23759           | 23901 | 23987  | 23987 | 256     |
| transfer                         | 26962           | 66272 | 66634  | 66870 | 1024    |
| whiteTransfer                    | 67407           | 67593 | 67647  | 89319 | 768     |
| whitelist                        | 21636           | 21785 | 21864  | 21864 | 512     |

# GAS OPTIMSATION

- Your task is to edit and optimise the Gas.sol contract.
- You cannot edit the tests &
- All the tests must pass.
- You can change the functionality of the contract as long as the tests pass.
- Try to get the gas usage as low as possible.



## To run tests & gas report with verbatim trace
Run: `forge test --gas-report -vvvv`

## To run tests & gas report
Run: `forge test --gas-report`

## To run a specific test
RUN:`forge test --match-test {TESTNAME} -vvvv`
EG: `forge test --match-test test_onlyOwner -vvvv`
