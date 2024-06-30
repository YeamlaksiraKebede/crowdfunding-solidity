# FundMe Solidity Smart Contract

This project contains a Solidity smart contract (`FundMe.sol`) and a supporting library (`PriceConverter.sol`). The `FundMe` contract allows users to fund it with Ether, and the contract owner can withdraw the funds. The `PriceConverter` library is used to convert Ether amounts to USD using Chainlink price feeds.

## Overview

- **FundMe.sol**: A smart contract for crowdfunding. Users can send Ether, and the owner can withdraw the funds.
- **PriceConverter.sol**: A library to convert Ether to USD using Chainlink price feeds.

## Features

- **Minimum Funding Amount**: Ensures a minimum funding amount in USD.
- **Owner-only Withdrawal**: Only the contract owner can withdraw the funds.
- **Pause/Unpause**: The contract owner can pause and unpause the contract.
- **Events**: Emits events for funding, withdrawal, pausing, and unpausing.
- **Reentrancy Guard**: Protects against reentrancy attacks.

## Requirements

- Node.js
- npm
- Hardhat
- Solidity ^0.8.18
- Chainlink Contracts

## Installation

1. **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/fundme-solidity.git
    cd crowdfunding-solidity
    ```

2. **Install dependencies**:
    ```bash
    npm install
    ```

3. **Set up environment variables**:
    Create a `.env` file in the root directory and add the following:
    ```env
    SEPOLIA_URL="https://sepolia.infura.io/v3/YOUR_INFURA_PROJECT_ID"
    PRIVATE_KEY="your-private-key"
    ETHERSCAN_API_KEY="your-etherscan-api-key"
    ```

## Usage

### Deploy the Contracts

1. **Compile the contracts**:
    ```bash
    npx hardhat compile
    ```

2. **Deploy the contracts**:
    ```bash
    npx hardhat run scripts/deploy.js --network sepolia
    ```

### Interact with the Contracts

- **Fund the contract**:
    Use the `fund` function to send Ether to the contract.

- **Withdraw funds**:
    Only the owner can call the `withdraw` function to withdraw all funds.

- **Get version of the price feed**:
    Call the `getVersion` function.

- **Pause/Unpause the contract**:
    The owner can call `pause` and `unpause` functions to manage the contract state.

### Testing

Run the tests to ensure everything is working as expected:

```bash
npx hardhat test



### Contributing
Contributions are welcome! Please open an issue or submit a pull request.

