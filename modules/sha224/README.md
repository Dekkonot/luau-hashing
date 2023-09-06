# SHA-224 Luau

A pure Luau implementation of the SHA-224 hashing algorithm. Blazing fast (for Luau) and well-tested.

## API

This module returns a single function with the following type signature:

```
sha224(message: string): (string, {number})
```

The `message` passed to this function will be hashed using the hashing algorithm. The hash is returned in two forms:

1. As a sequence of 56 hexadecimal digits
2. A **read-only** array of seven 32-bit words that represent the hash