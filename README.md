# Pure entrypoint ERC-1967 proxy for UUPS

Entrypoint ERC-1967 proxy and storage contract for the UUPS based architecture. Flattened and adapted from OpenZeppelin.

Use `src/Entrypoint.sol` with Foundry.

# Why?

- no dependencies
- small focused package
- smaller bytecode, lower gas consumption, yet still verifiable for explorers
- clear steps, easier to audit
- easy to plug in to OpenZeppelin based contracts
- does not brake when OpenZeppelin restructures folders

I.e. ideal for the immutable part of the upgradeable project architecture.

# Test coverage

Test coverage somehow does not report 100% even though red flagged branches are tested.

# License MIT
