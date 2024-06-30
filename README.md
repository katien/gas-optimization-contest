# Group 1 Proxy Solution: 231,252 gas

### **See `master` branch for a version that costs 268,452 gas and does not use delegatecall**

- Run via: `rm -rf cache;forge test --fork-url https://eth-sepolia.g.alchemy.com/v2/OePOEihAN0uxV-7hy5GdFT0EYEZPyESB --gas-report --optimizer-runs 1`
- Implementation contract deployed on Sepolia at https://sepolia.etherscan.io/address/0x25ddbF63165997BA60e0aab3C61e6814BEA0144c
- Output:

| src/Gas.sol:GasContract contract |                 |       |        |       |         |
|----------------------------------|-----------------|-------|--------|-------|---------|
| Deployment Cost                  | Deployment Size |       |        |       |         |
| 231252                           | 1357            |       |        |       |         |
| Function Name                    | min             | avg   | median | max   | # calls |
| addToWhitelist                   | 24639           | 25638 | 25971  | 26187 | 2048    |
| administrators                   | 24684           | 24692 | 24696  | 24696 | 5       |
| balanceOf                        | 26725           | 26753 | 26737  | 26953 | 1793    |
| balances                         | 26637           | 26774 | 26865  | 26865 | 1024    |
| checkForAdmin                    | 21687           | 21687 | 21687  | 21687 | 1       |
| getPaymentStatus                 | 26730           | 26876 | 26958  | 26958 | 256     |
| transfer                         | 30203           | 69646 | 69859  | 70099 | 1024    |
| whiteTransfer                    | 53390           | 70608 | 70718  | 70730 | 768     |
| whitelist                        | 21636           | 21773 | 21864  | 21864 | 512     |

- The goal of this competition was to optimize the deployment gas cost as much as possible, no effort was made to
  optimizing the cost of calling contract methods

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
