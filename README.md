# oboard/mooncrypto

mooncrypto is a growing collection of standard and secure cryptographic algorithms implemented in MoonBit using best practices and patterns. They are fast, and they have a consistent and simple interface.

## Installation

```bash
moon install oboard/mooncrypto
```

## Usage

### MD5

```moonbit
println(@mooncrypto.md5("Hello, World!"))


println(@mooncrypto.core_md5(bytes))
```

### SHA256

```moonbit
println(@mooncrypto.sha256("Hello, World!"))


println(@mooncrypto.core_sha256(bytes))
```

## Algorithms

- [x] MD5
- [ ] SHA1
- [ ] SHA3
- [x] SHA256
