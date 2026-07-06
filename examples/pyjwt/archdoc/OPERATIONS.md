# PyJWT Operations

> Generated with `ai-craftkit` skill: `archdoc`  
> Source: `https://github.com/jpadilla/pyjwt.git` at commit `7144e4534c34810f4525dc4578a32addd8212cff`  
> Prompt: `Follow instructions in #prompt:SKILL.md with these arguments: generate the architecture documentation for the pyjwt repo.`

Last Reviewed Scope: full review
Doc Status: DRAFT
Last Operations Update: 2026-07-06T21:43:59Z
Updated By: agent
Source Basis: README scan | docs scan | code scan | test scan | workflow scan

## Purpose

This document describes how PyJWT is installed, verified, released, and operated as a library dependency.

PyJWT is not a long-running service. Most operational work is local verification, docs generation, package build / publish, and support for downstream integrations that use the library at runtime.

## Runtime Overview

| Runtime concern | Behavior |
|---|---|
| Execution model | In-process Python library calls |
| Long-running processes | None in this repo |
| Persistence | None; only ephemeral in-memory state |
| Network access | Only when callers use `PyJWKClient` to fetch a JWKS over HTTP(S) |
| Background work | None |

## Local Development Quick Start

| Goal | Command | Evidence |
|---|---|---|
| Install base package | `python -m pip install .` | `.github/workflows/main.yml` |
| Install crypto-enabled package | `python -m pip install .[crypto]` | `docs/installation.rst`, workflow |
| Install editable dev environment | `python -m pip install -e . --group dev` | `.github/workflows/main.yml` |
| Run full validation | `tox` | `README.rst`, `tox.ini` |
| Build docs and doctests | `tox -e docs` | `tox.ini` |

## Command Map

| Command | What it does |
|---|---|
| `tox` | Runs the configured tox environment matrix |
| `python -m tox -e lint` | Runs `pre-commit run --all-files` |
| `python -m tox -e py311-crypto` | Runs one crypto-enabled test environment |
| `python -m tox -e py311-nocrypto` | Runs one base-install test environment |
| `python -m tox -e py311-mypy` | Runs strict mypy checks |
| `tox -e docs` | Builds HTML docs, doctests docs, and doctests `README.rst` / `docs/usage.rst` |
| `python -m build` | Builds source and wheel artifacts |
| `python -m jwt.help` | Prints environment metadata helpful in bug reports |

## Execution Model

The main runtime paths are synchronous function or method calls from a host application. There is no project-managed process supervisor, port binding, queue worker, or scheduler.

The only persistent behavior inside the library is cache retention within a `PyJWKClient` instance:

- a TTL cache for entire JWKS responses, enabled by default
- an optional LRU cache for individual signing keys

## Runtime Modes

| Mode | Difference | Evidence |
|---|---|---|
| Base install | HMAC and `none` algorithms available; no `cryptography` dependency | `pyproject.toml`, `jwt/algorithms.py` |
| Crypto install (`.[crypto]`) | RSA, ECDSA, RSA-PSS, and EdDSA algorithms become available | `docs/installation.rst`, `jwt/algorithms.py` |
| Docs build mode | Sphinx build imports extra typing paths and runs doctests | `.readthedocs.yaml`, `tox.ini`, `SPHINX_BUILD` checks |

## Environment And Secrets

No required repository-managed `.env` or secret files were found.

Operationally relevant sensitive inputs are provided by downstream callers, not stored here:

- shared HMAC secrets
- private keys and public keys
- JWK and JWKS data
- optional outbound JWKS URLs

The repository includes test keys under `tests/keys/`; these are fixtures, not production secrets.

## Configuration Points

| Configuration | Scope | Notes |
|---|---|---|
| decode `options` dict | per call or per `PyJWT` instance | controls signature and claim verification |
| `algorithms` parameter | per decode call | caller-controlled allowlist; security-sensitive |
| `PyJWKClient` args (`cache_keys`, `cache_jwk_set`, `lifespan`, `headers`, `timeout`, `ssl_context`) | per client instance | affects remote-key fetch and cache behavior |
| install extras (`.[crypto]`) | environment-wide | changes available algorithms |

## Deployment And Distribution

There is no application deployment target in this repository.

Verified distribution / publishing flows:

- GitHub Actions `main.yml` builds and validates packages.
- GitHub Actions `pypi-package.yml` builds packages on pushes, PRs, tags, and releases.
- On `master` pushes in the canonical repository, packages are published to TestPyPI.
- On published GitHub releases in the canonical repository, packages are published to PyPI.
- Read the Docs builds documentation using Python 3.11 and installs `.[crypto]` plus docs dependencies.

## External Runtime Dependencies

| Dependency | Why it matters |
|---|---|
| Python interpreter | Core runtime |
| `cryptography` | Required for asymmetric algorithms and advanced key types |
| Remote JWKS endpoint | Required only for `PyJWKClient` integrations |
| System clock | Affects `exp`, `nbf`, `iat`, and leeway validation |

## One Real Runtime Flow

### Verify an RS256 token using a remote JWKS

```text
host application receives JWT
-> constructs PyJWKClient with JWKS URL
-> PyJWKClient.get_signing_key_from_jwt(token)
-> jwt.api_jwt.decode_complete(..., options={"verify_signature": False}) reads unverified header
-> PyJWKClient fetches or reuses cached JWKS
-> PyJWKClient matches `kid` to a signing key
-> host application calls jwt.decode(token, signing_key.key, algorithms=["RS256"], ...)
-> jwt.api_jws parses and verifies signature
-> jwt.api_jwt validates claims
-> payload dict is returned or an exception is raised
```

## Main Runtime Flows

| Flow | Owning code |
|---|---|
| Encode token | `jwt.api_jwt.PyJWT.encode` -> `jwt.api_jws.PyJWS.encode` -> `jwt.algorithms` |
| Decode token | `jwt.api_jwt.PyJWT.decode_complete` -> `jwt.api_jws.PyJWS.decode_complete` -> claim validation |
| Parse JWK | `jwt.api_jwk.PyJWK` |
| Resolve signing key from JWKS | `jwt.jwks_client.PyJWKClient` + `jwt.jwk_set_cache.JWKSetCache` |

## Data Flow And Persistence

| Data | Persistence model |
|---|---|
| Tokens, headers, payloads, keys | caller-owned, in-memory only |
| JWKS response cache | in-memory per `PyJWKClient` instance, TTL-based |
| Signing key cache | optional in-memory LRU per `PyJWKClient` instance |
| Build artifacts | produced by packaging and docs tasks, not stored as part of runtime state |

## Logging And Observability

No structured logging, metrics, tracing, or health endpoint was found inside the package.

Operational observability is mostly external:

- exceptions raised to the host application
- CI workflow status
- `python -m jwt.help` output for environment diagnostics
- doctest and pytest failures

## Debugging Guide

| Problem area | First checks |
|---|---|
| Token fails to decode | confirm `algorithms` allowlist, key type, and claim options |
| Asymmetric algorithm not found | confirm install included `.[crypto]` |
| `PyJWKClient` cannot resolve key | inspect `kid`, JWKS contents, URI scheme, timeout, and cache settings |
| Unexpected claim failures | inspect `options`, `audience`, `issuer`, `subject`, and current system time |
| CI-only failures | compare local tox env with `.github/workflows/main.yml` matrix |

## Failure Modes

| Failure mode | Likely symptom | Recovery path |
|---|---|---|
| Missing `cryptography` for asymmetric algorithm | `NotImplementedError` or crypto-related key errors | install `pyjwt[crypto]` |
| Caller omits `algorithms` during verified decode | `DecodeError` requiring the argument | pass explicit allowlist |
| Malformed token segments or JSON | `DecodeError` | inspect token producer or test fixture |
| Unsupported or unusable JWK / JWKS | `PyJWKError` or `PyJWKSetError` | validate key material format |
| Remote JWKS endpoint fails | `PyJWKClientConnectionError` | retry, inspect endpoint, or reuse cached client state |
| No matching signing key by `kid` | `PyJWKClientError` | confirm token header and JWKS freshness |

## Manual Recovery Notes

- Recreate a `PyJWKClient` instance to drop both in-memory caches.
- Force a JWKS refresh with `get_jwk_set(refresh=True)` or the retry path in `get_signing_key`.
- For local environment debugging, compare `python -m jwt.help` output across machines.

## Backups And Persistent State

No backup strategy is required for the library itself because it does not own durable state.

## Security Operations

| Topic | Repository evidence |
|---|---|
| Supported security-update line | `SECURITY.md` lists `2.10.x` as supported |
| Vulnerability reporting | GitHub Security tab preferred; fallback email `security@jpadilla.com` |
| Security-sensitive test areas | `tests/test_advisory.py`, algorithm and decode tests |

## Safe Change Workflow

1. Identify whether the change affects public imports, decode defaults, algorithms, or JWKS behavior.
2. Read the nearest tests before editing.
3. Run the narrowest tox or pytest target that covers the touched path.
4. If public behavior changes, run `tox -e docs` to keep examples and docs consistent.
5. For packaging or metadata changes, check the GitHub workflow definitions as well as local tox config.

## Current Operational Health

- Verified from repo configuration: CI covers multiple Python versions and operating systems.
- Verified from repo configuration: docs, lint, typing, packaging, and installability checks all exist.
- Missing from this review: live confirmation that these tasks currently pass.

## Operational Gaps And Known Unknowns

- Could not verify package build, docs build, or tox environments locally because no heavy commands were run.
- Could not determine whether maintainers rely on any release steps outside GitHub Actions, because no additional release documentation was found.