# MD5 Luau

A pure Luau implementation of the MD5 hashing algorithm. Blazing fast (for Luau) and well-tested.

## !! Warning: Cryptographically Broken !!

The MD5 hash function MUST NOT be utilized for crytographic purposes. It is vulnerable to a myriad of collision attacks, including simple bruteforcing. DO NOT USE THIS HASH FOR PASSWORDS OR ANYTHING THAT REQUIRES SECURITY.

## API

This module returns a single function with the following type signature:

```
md5(message: string): (string, {number})
```

The `message` passed to this function will be hashed using the hashing algorithm. The hash is returned in two forms:

1. As a sequence of 32 hexadecimal digits
2. A **read-only** array of four 32-bit words that represent the hash