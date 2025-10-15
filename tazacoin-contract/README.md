# TazaCoin Smart Contract

TazaCoin is a SIP-010 compliant fungible token built on the Stacks blockchain using Clarity smart contracts.

## Overview

TazaCoin (TAZA) is a comprehensive fungible token implementation that includes:
- Standard SIP-010 token functionality
- Minting and burning capabilities
- Administrative controls with pause functionality
- Batch operations for efficient transfers and airdrops
- Security features and error handling

## Token Details

- **Name**: TazaCoin
- **Symbol**: TAZA
- **Decimals**: 6
- **Token URI**: https://tazacoin.io/metadata.json
- **Standard**: SIP-010 Fungible Token

## Features

### Core SIP-010 Functions
- `transfer`: Transfer tokens between accounts
- `get-name`: Get token name
- `get-symbol`: Get token symbol  
- `get-decimals`: Get token decimals
- `get-balance`: Get account balance
- `get-total-supply`: Get total token supply
- `get-token-uri`: Get token metadata URI

### Administrative Functions
- `mint`: Mint new tokens (owner only)
- `burn`: Burn tokens from sender's account
- `set-contract-paused`: Pause/unpause contract operations (owner only)

### Utility Functions
- `multi-send`: Batch mint tokens to multiple recipients (owner only)
- `batch-transfer`: Transfer tokens to multiple recipients in one transaction
- `is-paused`: Check if contract is paused
- `get-contract-owner`: Get contract owner address

## Error Codes

- `u100`: Owner only operation
- `u101`: Not token owner
- `u102`: Insufficient balance
- `u103`: Invalid amount (must be > 0)
- `u104`: Contract is paused

## Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) installed
- [Node.js](https://nodejs.org/) for testing

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd tazacoin-contract
```

2. Install dependencies:
```bash
npm install
```

### Development

#### Check contract syntax:
```bash
clarinet check
```

#### Run tests:
```bash
npm test
```

#### Deploy to devnet:
```bash
clarinet integrate
```

## Usage Examples

### Deploying the Contract

```bash
clarinet deploy --devnet
```

### Minting Tokens (Owner Only)

```clarity
(contract-call? .tazacoin mint u1000000 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
```

### Transferring Tokens

```clarity
(contract-call? .tazacoin transfer u100000 tx-sender 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG none)
```

### Checking Balance

```clarity
(contract-call? .tazacoin get-balance 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
```

### Batch Operations

#### Multi-send (Airdrop)
```clarity
(contract-call? .tazacoin multi-send 
  (list 
    {to: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM, amount: u1000000}
    {to: 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG, amount: u2000000}
  )
)
```

#### Batch Transfer
```clarity
(contract-call? .tazacoin batch-transfer 
  (list 
    {to: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM, amount: u100000, memo: none}
    {to: 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG, amount: u200000, memo: (some 0x48656c6c6f)}
  )
)
```

## Security Features

- **Owner-only functions**: Critical operations like minting and pausing are restricted to contract owner
- **Pause functionality**: Contract can be paused to prevent transfers during emergencies
- **Input validation**: All functions validate inputs and handle errors appropriately
- **SIP-010 compliance**: Follows standard token interface for interoperability

## Testing

The contract includes comprehensive tests covering:
- Token transfers
- Minting and burning
- Administrative functions
- Error conditions
- Batch operations

Run the test suite:
```bash
npm test
```

## Deployment

### Testnet Deployment
```bash
clarinet publish --testnet
```

### Mainnet Deployment
```bash
clarinet publish --mainnet
```

## Contract Architecture

The contract is structured with:
- **Constants**: Fixed values like token metadata and error codes
- **Data Variables**: Mutable state like pause status
- **Data Maps**: Key-value storage for balances and allowances
- **Public Functions**: Externally callable functions
- **Read-only Functions**: View functions that don't modify state
- **Private Functions**: Internal helper functions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run the test suite
6. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions and support, please open an issue on GitHub or contact the development team.

## Roadmap

- [ ] Add governance features
- [ ] Implement staking mechanisms  
- [ ] Add liquidity mining rewards
- [ ] Create web interface
- [ ] Integrate with DeFi protocols

---

Built with ❤️ using Clarity and Stacks blockchain technology.