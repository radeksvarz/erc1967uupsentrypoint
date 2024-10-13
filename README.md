# Pure entrypoint ERC-1967 proxy for UUPS

Entrypoint ERC-1967 proxy and storage contract for the UUPS based architecture. Flattened and adapted from OpenZeppelin.

Use `src/Entrypoint.sol` with Foundry.

# Why?

- no dependencies
- small focused package
- smaller bytecode, lower gas consumption, yet still verifiable for explorers
- clear steps, easier to audit
- easy to plug in to OpenZeppelin based upgradeable contracts
- does not brake when OpenZeppelin restructures folders

I.e. ideal for the immutable part of the upgradeable project architecture.

# Compatibility

Compatible replacement of:

```solidity
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract Entrypoint is ERC1967Proxy {
    // solhint-disable-next-line no-empty-blocks
    constructor(address _logic, bytes memory _data) payable ERC1967Proxy(_logic, _data) {}
}
```

# Further optimalization

Runtime bytecode is 126 bytes.

Consider removing CBOR, bytecodehash and other metadata to reduce the size by 53 bytes.

See Foundry's `--no-meta-data` option or `bytecode_hash` and `cbor_metadata` config options.

# Test coverage

Test coverage somehow does not report 100% even though red flagged branches are tested.

# License MIT
