# VulnBank

A deliberately insecure smart contract used for educational security auditing and PoC testing.

## Vulnerabilities

- ❌ Re-entrancy in `withdraw()`
- ❌ Unsafe access control in `kill()`
- ❌ Integer underflow in `underflow()`

## Use Case

This repo can be used for:
- Security training
- Auditing tool benchmarks
- Proof-of-concept attack testing

## Compile

```bash
forge build
