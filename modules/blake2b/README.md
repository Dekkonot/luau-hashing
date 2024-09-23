# BLAKE2b Luau

A pure Luau implementation of the BLAKE2b hashing algorithm. Blazing fast (for Luau) and well-tested.

## API

This module returns a single function with the following type signature:

```
blake2b(message: string, hashLen: number, key: string?): string
```

The `message` passed to this function will be hashed using BLAKE2b. The returned hash will be `hashLen` bytes in length.
If provided, `key` will be used as a [pepper][Pepper] for the algorithm.

[Pepper]: https://en.wikipedia.org/wiki/Pepper_(cryptography)