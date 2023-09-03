# SHA-1 Luau

A pure Luau implementation of the SHA-1 hashing algorithm. Blazing fast (for Luau) and well-tested.

## !! Warning: Cryptographically Broken !!

The SHA-1 hash function MUST NOT be utilized for crytographic purposes. It is vulnerable to collision attacks. For more information, [see this website](https://sha-mbles.github.io/).

## API

This module returns a single function with the following type signature:

```
sha1(message: string): (string, {number})
```

The `message` passed to this function will be hashed using the hashing algorithm. The hash is returned in two forms:

1. As a sequence of 40 hexadecimal digits
2. A **read-only** array of five 32-bit words that represent the hash