# Decentralized Marketplace on Stacks

This project implements a fully decentralized marketplace on Bitcoin using Stacks, built with Clarity smart contracts. The marketplace supports a variety of advanced features, including item listings, purchases, auctions, escrow, reputation systems, and more.

## Key Features

- **Token-based Payments**: Facilitates payments through custom tokens or BTC.
- **Escrow**: Ensures secure transactions by holding funds in escrow until buyer and seller agree.
- **User Profiles & Reputation**: Users build their reputation based on transaction reviews.
- **Auction System**: Supports auctions where sellers can set bidding timelines and minimum prices.
- **Modular Design**: The system is built with a flexible and modular contract architecture.
- **Dispute Resolution**: Offers third-party mediation and automatic resolution mechanisms for disputes.
- **Discounts & Loyalty**: Sellers can create loyalty programs and offer discounts to frequent buyers.
- **Cross-Chain Asset Support**: Supports transactions using assets from multiple blockchain networks.
- **Reputation-Based Access Control**: Restricts access to higher-value transactions based on user reputation.

## Project Structure

The project follows a modular architecture, with each contract separated into its own directory, allowing for easier development, testing, and scaling.

```plaintext
root/
├── contracts/
│   ├── TokenContract/
│   │   ├── token.clar
│   │   └── tests/
│   │       ├── test-token.clar
│   ├── MarketplaceContract/
│   │   ├── marketplace.clar
│   │   └── tests/
│   │       ├── test-marketplace.clar
│   ├── EscrowContract/
│   │   ├── escrow.clar
│   │   └── tests/
│   │       ├── test-escrow.clar
│   ├── UserContract/
│   │   ├── user.clar
│   │   └── tests/
│   │       ├── test-user.clar
│   ├── OracleContract/
│   │   ├── oracle.clar
│   │   └── tests/
│   │       ├── test-oracle.clar
├── README.md
├── docs/
│   ├── API.md
│   └── Features.md
├── scripts/
│   ├── deploy.sh
│   └── interact.sh
├── migrations/
│   ├── migration-scripts
├── package.json
└── .github/
    ├── workflows/
    │   └── ci.yml
    ├── CONTRIBUTING.md
```

### Explanation:

1. **contracts/**: Contains each smart contract (Token, Marketplace, Escrow, etc.) with their corresponding tests.
2. **tests/**: Test cases to validate each contract’s functionality. Integration tests can be added to verify cross-contract interactions.
3. **docs/**: Documentation files, such as API details and feature explanations.
4. **scripts/**: Deployment and interaction scripts to automate deployment and interaction with smart contracts.
5. **migrations/**: Contains migration scripts for deploying contracts in different environments.
6. **.github/**: Configuration for GitHub CI/CD workflows and contributing guidelines.

## Installation & Setup

### Prerequisites

- [Clarity CLI](https://docs.stacks.co/build-tools/clarity-cli) for local testing and development.
- A Stacks node for deploying contracts.
- [GitHub CLI](https://cli.github.com/) for managing feature branches and repository integration.

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/promise-code/decentralized-marketplace.git
   cd decentralized-marketplace
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Deploy contracts (using Stacks CLI):
   ```bash
   ./scripts/deploy.sh
   ```

## Feature Branches

The project is structured with modular feature branches, allowing each feature to be developed and maintained independently. Below are examples of the branch structure for each component:

1. **Token Contract**:

   - `feat/token-basic`
   - `feat/token-minting`
   - `feat/token-staking`

2. **Marketplace Contract**:

   - `feat/marketplace-listings`
   - `feat/auction-system`
   - `feat/user-reviews`
   - `feat/item-categories`

3. **Escrow Contract**:

   - `feat/escrow-basic`
   - `feat/dispute-resolution`
   - `feat/third-party-arbitration`

4. **User Contract**:

   - `feat/user-reputation`
   - `feat/reputation-access`
   - `feat/user-loyalty`

5. **Oracles and External Data**:
   - `feat/oracle-integration`
   - `feat/cross-chain-assets`

You can switch to a feature branch with the following command:

```bash
git checkout feat/auction-system
```

## Running Tests

Tests are provided for each contract to ensure reliability and performance. You can run them using the Clarity CLI:

```bash
clarity test contracts/MarketplaceContract/tests/test-marketplace.clar
```

## Usage

1. **Mint Tokens**: Use the token contract to mint tokens:

   ```bash
   ./scripts/interact.sh mint 1000 'SP1234567890'
   ```

2. **List Item for Sale**: List an item in the marketplace:

   ```bash
   ./scripts/interact.sh list-item 1 500
   ```

3. **Purchase Item**: Purchase an item from the marketplace:
   ```bash
   ./scripts/interact.sh buy-item 1 'SP987654321'
   ```

## Contributing

Contributions are welcome! Please review our [CONTRIBUTING.md](.github/CONTRIBUTING.md) for detailed guidelines on how to contribute to the project. We appreciate pull requests that enhance the system and make it more robust and scalable.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
