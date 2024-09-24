# Luau Hashing

[![Tests](https://github.com/Dekkonot/luau-hashing/actions/workflows/test.yml/badge.svg)](https://github.com/Dekkonot/luau-hashing/actions/workflows/test.yml)

Pure Luau implementations of several hashing algorithms. Blazing fast (for Luau) and well-tested.

Modules reside in their own folders under `modules` and have their own READMEs with documentation. Additionally, each module is published on [Wally] and [NPM] for convenience.

| Hashing Algorithm              | Wally Dependency    | NPM Dependency       |
|:------------------------------:|:--------------------|:---------------------|
| [`sha-1`](modules/sha1)        | `dekkonot/sha1`     | `@dekkonot/sha1`     |
| [`sha-256`](modules/sha256)    | `dekkonot/sha256`   | `@dekkonot/sha256`   |
| [`sha-224`](modules/sha224)    | `dekkonot/sha224`   | `@dekkonot/sha224`   |
| [`sha-512`](modules/sha512)    | `dekkonot/sha512`   | `@dekkonot/sha512`   |
| [`sha-384`](modules/sha384)    | `dekkonot/sha384`   | `@dekkonot/sha384`   |
| [`xxhash32`](modules/xxhash32) | `dekkonot/xxhash32` | `@dekkonot/xxhash32` |
| [`blake2s`](modules/blake2s)   | `dekkonot/blake2s`  | `@dekkonot/blake2s`  |
| [`md5`](modules/md5)           | `dekkonot/md5`      | `@dekkonot/md5`      |

[Wally]: https://wally.run/
[NPM]: https://www.npmjs.com/