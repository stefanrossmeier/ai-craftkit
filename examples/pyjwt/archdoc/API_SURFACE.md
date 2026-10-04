# API Surface

Review Scope: public Python API and JWKS integration
Doc Status: MAINTAINED
Last Updated: 2026-10-04T09:21:37Z
Updated By: agent
Source Repository: [jpadilla/pyjwt](https://github.com/jpadilla/pyjwt/tree/7144e4534c34810f4525dc4578a32addd8212cff)
Source Revision: [7144e4534c34810f4525dc4578a32addd8212cff](https://github.com/jpadilla/pyjwt/commit/7144e4534c34810f4525dc4578a32addd8212cff)
Source Basis: `jwt/__init__.py`, API implementations, `docs/api.rst`, `docs/usage.rst`, representative tests

Related docs: [REPO_MAP.md](REPO_MAP.md), [ARCHITECTURE.md](ARCHITECTURE.md), and [OPERATIONS.md](OPERATIONS.md).

## Summary

- **Primary interface**: public Python library exports from `jwt`.
- **Consumers**: host Python applications and their authentication/token-processing code.
- **Canonical API reference**: [`docs/api.rst`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/docs/api.rst), generated from public docstrings.
- **Authentication model**: PyJWT does not authenticate or authorize callers. Callers supply signing/verification keys and interpret validated claims.
- **Compatibility**: Python 3.9+ is supported. Deprecated parameters produce warnings, some noting removal in PyJWT 3; no broader versioning policy was found.

## Interface Inventory

| Interface | Owner / entry point | Purpose | Status |
|---|---|---|---|
| `jwt.encode`, `PyJWT.encode` | [`api_jwt.PyJWT`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/api_jwt.py) | Convert a mapping of claims to a signed compact JWT | verified |
| `jwt.decode`, `jwt.decode_complete` | `PyJWT` | Verify a JWT and validate claims; complete form also returns header/signature | verified |
| `PyJWS` and algorithm helpers | [`api_jws.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/api_jws.py) | Lower-level JWS processing and per-instance algorithm extension | verified |
| `PyJWK`, `PyJWKSet` | [`api_jwk.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/api_jwk.py) | JWK and JWK-set representation and conversion | verified |
| `PyJWKClient` | [`jwks_client.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/jwks_client.py) | Retrieve/select signing keys from a JWKS endpoint | verified |
| exceptions and `InsecureKeyLengthWarning` | [`jwt/__init__.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/__init__.py) | Typed caller-visible failure and warning contracts | verified |

## Token Encode and Verified Decode

- **Input**: `encode` accepts a claims `dict`, signing key, algorithm, optional JOSE headers, and JSON encoder. `decode` accepts compact token bytes/text, verification key, allowed algorithms, validation options, and optional audience/issuer/subject/leeway.
- **Result**: `encode` returns compact JWT text. `decode` returns a claim-object dictionary; `decode_complete` also returns `header`, `payload`, and raw `signature`.
- **Validation**: payloads must be JSON objects; default decode options validate signature and registered `exp`, `nbf`, `iat`, `aud`, `iss`, `sub`, and `jti` claims. `algorithms` must be supplied for verified decode unless a `PyJWK` supplies the key-bound algorithm.
- **Failure behavior**: malformed tokens, invalid keys/algorithms/signatures, and failed claims raise exported `jwt` exceptions such as `DecodeError`, `InvalidAlgorithmError`, `InvalidSignatureError`, and `ExpiredSignatureError`.
- **Security boundary**: callers must configure allowed algorithms independently from token-controlled data; `get_unverified_header` and decode with `verify_signature=False` return untrusted material.
- **Verification**: [`tests/test_api_jwt.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/tests/test_api_jwt.py) and [`tests/test_api_jws.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/tests/test_api_jws.py).

## JWS and Algorithm Extension

`PyJWS` accepts optional algorithms/options, signs or verifies byte payloads, exposes `get_unverified_header`, and offers `register_algorithm`, `unregister_algorithm`, and `get_algorithm_by_name`. Registrations are held by the instance and reject duplicate identifiers or objects that do not implement `Algorithm`.

The base installation supports `none` and HS256/384/512. With the `crypto` extra, supported algorithms additionally include RSA, RSA-PSS, elliptic-curve, and EdDSA families. The exact implementations and availability are defined by [`jwt/algorithms.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/algorithms.py).

## JWK and Remote JWKS Client

`PyJWKClient(uri, ...)` accepts only HTTP(S) endpoint URLs, optional request headers, timeout, and `ssl_context`. `get_jwk_set`, `get_signing_keys`, `get_signing_key`, and `get_signing_key_from_jwt` return JWK models or raise `PyJWKClientError`/`PyJWKClientConnectionError` for invalid response, absent matching signing key, or network failures.

It filters usable signing keys to JWKs with `use` unset or `sig` and a `kid`; a missing `kid` causes one forced JWKS refresh before failure. Its endpoint/caching behavior is documented operationally in [OPERATIONS.md](OPERATIONS.md) and verified by [`tests/test_jwks_client.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/tests/test_jwks_client.py).

## Contract Gaps

- The Sphinx API reference explicitly notes that `PyJWS` documentation is unfinished; code docstrings and tests are the closest contract source for its lower-level surface.
- No stable semantic-versioning policy, deprecation duration, or external compatibility guarantee beyond current source/test evidence was found.