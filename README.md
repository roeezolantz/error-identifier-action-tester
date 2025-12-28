# Solidity Error Identifier - Test Repository

This is a test repository for the [solidity-error-identifier-action](https://github.com/roee-zolantz/solidity-error-identifier-action) GitHub Action.

## What's Inside

### Sample Contract

`contracts/TestContract.sol` - A simple contract with 8 custom errors:

```solidity
error Unauthorized(address caller);
error InsufficientBalance(uint256 requested, uint256 available);
error InvalidAddress();
error ContractPaused();
error TransferFailed(address from, address to, uint256 amount);
error InvalidAmount(uint256 amount);
error AlreadyInitialized();
error ZeroValue();
```

### GitHub Actions Workflow

`.github/workflows/test-action.yml` - Tests the action in 3 modes:

1. **ABI Mode** - Compile first, then extract errors
2. **Compile Mode** - Action compiles contracts for you
3. **NPM Mode** - Shows NPM publishing (dry run)

## Testing Locally

### 1. Compile and extract using ABI mode

```bash
# Install dependencies
npm install

# Compile contracts
npx hardhat compile

# Run the action locally (simulated)
# You'll need to build the action first in the action repo
```

### 2. Expected errors.json output

After running, you should get `errors.json` with 8 errors:

```json
[
  {
    "name": "Unauthorized",
    "signature": "Unauthorized(address)",
    "inputs": ["caller"],
    "inputTypes": ["address"],
    "source": "TestContract.sol",
    "selector": "0x????????"
  },
  ...
]
```

## Testing on GitHub

1. **Fork this repo** or create a new one
2. **Update the workflow** to point to your published action:
   ```yaml
   uses: YourOrg/solidity-error-identifier-action@v1
   ```
3. **Push to main** - GitHub Actions will run automatically

## Expected Output

After the action runs, you'll see:

```
🔍 Solidity Error Identifier Action
=====================================
Mode: abi

📦 Found 1 ABI files to process

⚙️  Extracting errors from ABIs...
✅ Extracted 8 unique errors

📝 Wrote error database to: /path/to/errors.json

📊 Error Database Summary:
─────────────────────────
  TestContract.sol: 8 errors

Total: 8 errors from 1 contracts

✨ Action completed successfully!
```

## Error Selectors

The 8 custom errors should have these selectors (computed via keccak256):

| Error | Selector |
|-------|----------|
| `Unauthorized(address)` | 0x82b42900 |
| `InsufficientBalance(uint256,uint256)` | 0xcf479181 |
| `InvalidAddress()` | 0xe6c4247b |
| `ContractPaused()` | 0xab35696f |
| `TransferFailed(address,address,uint256)` | 0x90b8ec18 |
| `InvalidAmount(uint256)` | 0x2c5211c6 |
| `AlreadyInitialized()` | 0x0dc149f0 |
| `ZeroValue()` | 0x7c946ed7 |

## NPM Publishing Test

To test NPM publishing:

1. Create NPM token at [npmjs.com](https://www.npmjs.com/)
2. Add as GitHub Secret: `NPM_TOKEN`
3. Update workflow to enable publishing:
   ```yaml
   publish-npm: 'true'
   npm-package-name: '@yourorg/test-errors'
   npm-token: ${{ secrets.NPM_TOKEN }}
   ```
4. After publish, users can:
   ```bash
   npm install @yourorg/test-errors
   npx yourorg-test-errors 0x82b42900
   ```

## Troubleshooting

### Error: Action not found

Update the workflow to use the correct action reference:
```yaml
uses: roee-zolantz/solidity-error-identifier-action@v1
# or use a local path for testing:
uses: ./.github/actions/solidity-error-identifier-action
```

### Error: No ABIs found

Make sure contracts compiled successfully:
```bash
npx hardhat compile
ls -la artifacts/contracts/
```

### Error: Wrong selector computed

Verify the signature format (no spaces in parameter types):
```
Correct:   InsufficientBalance(uint256,uint256)
Incorrect: InsufficientBalance(uint256, uint256)
```

## License

MIT
