# XXH32 Luau

A pure Luau implementation of the XXH32 hashing algorithm. Blazing fast (for Luau) and well-tested.

## !! Warning: Non-Cryptographic !!

The XXH32 hash function MUST NOT be utilized for crytographic purposes. It is designed to be a reasonably collision resistant but fast hashing algorithm. It is vulnerable to a myriad of potential attacks that make it unsuitable for cryptography.

## API

This module returns a single function with the following type signature:

```
xxhash32(message: string, seed: number?): number
```

The `message` passed to this function will be hashed using the hashing algorithm. If desired, a `seed` may be used, which will be incorporated into the hashing algorithm. The hash is returned as a single unsigned 32-bit integer.