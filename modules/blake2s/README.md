# BLAKE2s Luau

A pure Luau implementation of the BLAKE2s hashing algorithm. Blazing fast (for Luau) and well-tested.

## API

This module returns a single function with the following type signature:

```
blake2s(message: string, hashLen: number, key: string?): string
```

The `message` passed to this function will be hashed using `blake2s`. The returned hash will be `hashLen` bytes in length.
If provided, `key` will be used as a [pepper][Pepper] for the algorithm.

[Pepper]: https://en.wikipedia.org/wiki/Pepper_(cryptography)