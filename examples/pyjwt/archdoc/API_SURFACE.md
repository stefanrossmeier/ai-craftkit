# PyJWT API Surface

> Generated with `ai-craftkit` skill: `archdoc`  
> Source: `https://github.com/jpadilla/pyjwt.git` at commit `7144e4534c34810f4525dc4578a32addd8212cff`  
> Prompt: `Follow instructions in #prompt:SKILL.md with these arguments: generate the architecture documentation for the pyjwt repo.`

Last Reviewed Scope: full review
Doc Status: DRAFT
Last API Surface Update: 2026-07-06T21:43:59Z
Updated By: agent
Source Basis: README scan | docs scan | code scan | test scan | workflow scan

## Purpose

This document inventories the public and integration-relevant interfaces exposed by PyJWT.

PyJWT does not expose an HTTP API, GraphQL schema, queue, webhook, or installed CLI entrypoint. Its meaningful interface surface is a Python library API, plus one outbound HTTP client for JWKS resolution.

## Evidence Legend

| Status | Meaning |
|---|---|
| verified | directly confirmed from code, tests, or docs |
| inferred | likely true from structure or usage examples, but not directly guaranteed |
| missing | searched but not found |

## API Surface Summary

| Interface family | Owner | Status |
|---|---|---|
| Top-level Python imports | `jwt/__init__.py` | verified |
| Object-oriented APIs (`PyJWT`, `PyJWS`, `PyJWK`, `PyJWKSet`, `PyJWKClient`) | `jwt/api_*.py`, `jwt/jwks_client.py` | verified |
| Algorithm registry extension points | `jwt/api_jws.py` | verified |
| Typed decode options | `jwt/types.py` | verified |
| Outbound JWKS fetch integration | `jwt/jwks_client.py` | verified |
| HTTP server endpoints | not present | missing |
| Installed CLI commands | not present | missing |

## Top-Level Import Surface

The package re-exports the following symbols from `jwt/__init__.py`.

| Symbol | Kind | Implementation owner | Contract notes |
|---|---|---|---|
| `encode` | function | `jwt.api_jwt` | Encodes a payload dict into a compact token |
| `decode` | function | `jwt.api_jwt` | Decodes a token and returns payload dict |
| `decode_complete` | function | `jwt.api_jwt` | Returns header, payload, and signature |
| `PyJWT` | class | `jwt.api_jwt` | Stateful wrapper around decode options |
| `PyJWS` | class | `jwt.api_jws` | Lower-level JWS API |
| `get_unverified_header` | function | `jwt.api_jws` | Reads JOSE header without signature verification |
| `register_algorithm` | function | `jwt.api_jws` | Adds algorithm handler to global JWS object |
| `unregister_algorithm` | function | `jwt.api_jws` | Removes algorithm handler from global JWS object |
| `get_algorithm_by_name` | function | `jwt.api_jws` | Returns algorithm implementation by id |
| `PyJWK` | class | `jwt.api_jwk` | Parses a JWK into an algorithm-backed key |
| `PyJWKSet` | class | `jwt.api_jwk` | Parses a JWK Set into a collection of usable keys |
| `PyJWKClient` | class | `jwt.jwks_client` | Fetches and caches keys from a JWKS endpoint |
| exceptions | classes | `jwt.exceptions` | Stable error taxonomy exported for callers |
| `InsecureKeyLengthWarning` | warning class | `jwt.warnings` | Signals weak-but-accepted keys unless strict enforcement is enabled |

## Core Function Contracts

| Function | Inputs | Outputs | Key error / warning behavior |
|---|---|---|---|
| `encode(payload, key, algorithm="HS256", headers=None, json_encoder=None)` | payload dict, signing key, optional alg and headers | compact JWT string | raises `TypeError` for non-dict payload; enforces string `iss`; may warn or error on weak keys |
| `decode(jwt, key="", algorithms=None, options=None, audience=None, issuer=None, subject=None, leeway=0, ...)` | token plus verification settings | payload dict | requires `algorithms` when signature verification is enabled unless a `PyJWK` is passed |
| `decode_complete(...)` | same as `decode` plus full metadata return | dict with `header`, `payload`, `signature` | same verification rules plus richer return shape |
| `get_unverified_header(jwt)` | token string / bytes | header dict | parses header without verifying signature; caller must treat result as untrusted |

## Class Surface

| Class | Important methods | Integration notes |
|---|---|---|
| `PyJWT` | `encode`, `decode`, `decode_complete` | Primary stateful API for custom default options |
| `PyJWS` | `encode`, `decode`, `decode_complete`, `get_unverified_header`, `register_algorithm`, `unregister_algorithm` | Lower-level signed-message API used internally by `PyJWT` |
| `PyJWK` | `from_dict`, `from_json`, properties like `key_id`, `key_type`, `public_key_use` | Converts JWK data into key objects usable by encode / decode |
| `PyJWKSet` | `from_dict`, `from_json`, `__getitem__`, iteration | Filters unusable keys while preserving usable ones |
| `PyJWKClient` | `get_jwk_set`, `get_signing_keys`, `get_signing_key`, `get_signing_key_from_jwt` | Only component that performs outbound network requests |

## Outbound HTTP Integration

`PyJWKClient` is the only network-relevant interface surface found.

| Interface | Direction | Contract |
|---|---|---|
| `PyJWKClient(uri, ...)` | outbound | URI scheme must be `http` or `https`; other schemes are rejected |
| `fetch_data()` | outbound GET | Uses `urllib.request`; forwards optional headers, timeout, and SSL context |
| `get_jwk_set(refresh=False)` | outbound GET on cache miss | Expects a JSON object containing a JWKS |
| `get_signing_key_from_jwt(token)` | mixed local parse plus outbound GET | Reads `kid` from the token header, then resolves a matching signing key |

No inbound HTTP interface was found.

## Typed Options And Validation Controls

`jwt.types.Options` and `jwt.types.SigOptions` define the main contract knobs.

| Option | Default behavior | Effect |
|---|---|---|
| `verify_signature` | `True` | Enables or disables cryptographic verification |
| `verify_exp` | mirrors `verify_signature` | Validates expiration claim if present |
| `verify_nbf` | mirrors `verify_signature` | Validates not-before claim if present |
| `verify_iat` | mirrors `verify_signature` | Validates issued-at claim format if present |
| `verify_aud` | mirrors `verify_signature` | Validates audience against `audience` input |
| `verify_iss` | mirrors `verify_signature` | Validates issuer against `issuer` input |
| `verify_sub` | mirrors `verify_signature` | Validates subject claim and optional `subject` input |
| `verify_jti` | mirrors `verify_signature` | Validates JWT ID claim type if present |
| `require` | `[]` | Requires claim presence but does not validate claim semantics by itself |
| `strict_aud` | `False` | Tightens audience validation to single-value exact match |
| `enforce_minimum_key_length` | `False` | Upgrades weak-key warnings into `InvalidKeyError` |

## Algorithm Surface

| Algorithm id | Availability | Evidence |
|---|---|---|
| `none`, `HS256`, `HS384`, `HS512` | base install | `jwt/algorithms.py` |
| `RS256`, `RS384`, `RS512` | requires `cryptography` | `jwt/algorithms.py`, `docs/installation.rst` |
| `ES256`, `ES256K`, `ES384`, `ES521`, `ES512` | requires `cryptography` | `jwt/algorithms.py` |
| `PS256`, `PS384`, `PS512` | requires `cryptography` | `jwt/algorithms.py` |
| `EdDSA` | requires `cryptography` | `jwt/algorithms.py`, `docs/usage.rst` |

## Public Errors And Warnings

| Type | When callers should expect it |
|---|---|
| `DecodeError` | malformed tokens, invalid JSON, missing segments, invalid detached-payload usage |
| `ExpiredSignatureError` | `exp` claim is in the past |
| `ImmatureSignatureError` | `nbf` or related timing checks fail |
| `InvalidAudienceError`, `InvalidIssuerError`, `InvalidSubjectError`, `InvalidJTIError` | claim-specific validation failures |
| `InvalidAlgorithmError`, `InvalidKeyError`, `InvalidSignatureError` | algorithm / key / signature validation failures |
| `PyJWKError`, `PyJWKSetError` | invalid JWK or JWKS input |
| `PyJWKClientError`, `PyJWKClientConnectionError` | JWKS fetch or lookup failures |
| `InsecureKeyLengthWarning` | signing key accepted but below recommended minimum length |
| `RemovedInPyjwt3Warning` | deprecated kwargs or legacy decode options are used |

## Authentication And Authorization Rules

PyJWT is an authentication library, but it does not implement user authorization, session storage, or server-side auth policies.

The important interface-level security rules are:

- Callers must pass an explicit `algorithms` allowlist when verifying signatures, unless using a `PyJWK` object that carries algorithm context.
- Callers should not derive allowed algorithms from attacker-controlled token headers.
- Raw JSON that looks like a JWK is rejected as an HMAC secret and must be loaded through JWK parsing first.
- `PyJWKClient` only accepts `http` and `https` URIs.

## Versioning, Compatibility, And Deprecation

| Compatibility point | Evidence | Status |
|---|---|---|
| Supported Python versions are 3.9 through 3.14 plus PyPy variants in CI | `pyproject.toml`, `.github/workflows/main.yml`, `tox.ini` | verified |
| Base install must work without `cryptography` | optional extra and no-crypto fallback code paths | verified |
| Some decode kwargs are deprecated and planned for removal in PyJWT 3 | `jwt/api_jwt.py`, `jwt/api_jws.py` warnings | verified |
| Public import names in `jwt/__init__.py` are compatibility-sensitive | exported `__all__` | inferred |

## Examples And Smoke Checks

| Check | Purpose |
|---|---|
| `tox -e py311-nocrypto` | verify base-install functionality |
| `tox -e py311-crypto` | verify asymmetric-algorithm functionality |
| `tox -e docs` | verify public examples and Sphinx API docs |
| `python -m jwt.help` | print environment details useful in bug reports |

## High-Risk Interface Changes

| Change | Why risky | What to verify |
|---|---|---|
| Changing `decode` defaults or option semantics | downstream auth validation can weaken or break silently | `tests/test_api_jwt.py`, docs examples |
| Changing exported symbol names | breaks imports in consuming applications | `jwt/__init__.py`, `docs/api.rst` |
| Changing algorithm registration or available algorithm ids | breaks explicit allowlists and JWK compatibility | `tests/test_api_jws.py`, `tests/test_algorithms.py` |
| Changing `PyJWKClient` fetch, cache, or refresh rules | breaks token verification flows that depend on remote keys | `tests/test_jwks_client.py` |

## Verified / Inferred Claim Register

| Claim | Evidence | Status |
|---|---|---|
| The main public API is intentionally top-level under `jwt` | `jwt/__init__.py`, docs examples | verified |
| There is no public server or webhook surface | repo scan, docs scan | verified |
| The JWKS client is part of the intended public surface | export in `jwt/__init__.py`, tests, docs API reference | verified |
| `python -m jwt.help` is intended as a support utility rather than a formal CLI product surface | `jwt/help.py`, absence of console script metadata | inferred |

## Known Unknowns

- Could not verify whether downstream callers rely on any undocumented exceptions or helper modules not re-exported from `jwt.__init__`.
- Could not verify package behavior under every CI Python version because the matrix was inspected but not executed.