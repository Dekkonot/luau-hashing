# SHA-512 Luau

A pure Luau implementation of the SHA-512 hashing algorithm. Blazing fast (for Luau) and well-tested.

Note that due to limitations with Luau, this module is substantially slower than it would be with native 64-bit integers. It is as fast as it can reasonably be in Luau though.

## API

This module returns a single function with the following type signature:

```
sha512(message: string): (string, {number})
```

The `message` passed to this function will be hashed using the hashing algorithm. The hash is returned in two forms:

1. As a sequence of 128 hexadecimal digits
2. A **read-only** array of sixteen 32-bit words that represent the hash.

In the returned array, the first word represents the most significant half of the first 'real' word of the hash, and the second word represents the least significant half. This pattern repeats for the remaining 14 words.