# Changelog

## Unreleased

- Several performance improvements
- Add `--!native` directive to module to support native codegen in Roblox
- Fixed incorrect hashing result when input had a length of `55 + 64 * n` where `n` was any integer

## Version 1.0.2

- Reworked implementation to significantly reduce memory footprint (approximately `95%` in tests)
- Several small optimizations resulting in an approximate `33%` increase in performance

## Version 1.0.1

- Corrected problem where messages with a length of over `4294967296 bits` did not hash correctly

## Version 1.0.0

- Initial release