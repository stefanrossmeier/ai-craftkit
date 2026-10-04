# PyJWT API Surface

> Review Scope: public Python-library exports and documented reference
> Doc Status: MAINTAINED
> Last Updated: 2026-10-04T08:21:17Z
> Updated By: agent
> Source Revision: 7144e4534c34810f4525dc4578a32addd8212cff
> Source Basis: `jwt/__init__.py`, `docs/api.rst`, `docs/usage.rst`, `tests/`, and implementation modules

The public integration contract is the importable `jwt` Python module. [docs/api.rst](../api.rst) is the canonical generated-reference source; [jwt/__init__.py](../../jwt/__init__.py) defines its top-level exports.

## Interface Inventory

| Interface | Contract |
| --- | --- |
| `encode(payload, key, algorithm, headers, ...) -> str` | Encodes a dictionary payload as a compact JWT. It defaults to `HS256` when no algorithm is passed ([jwt/api_jwt.py](../../jwt/api_jwt.py)). |
| `decode(token, key, algorithms, options, audience, issuer, subject, leeway, ...) -> dict` | Parses a token, verifies its signature by default, and returns validated claims. An explicit algorithm allow-list is required for non-`PyJWK` keys when verification is enabled ([jwt/api_jwt.py](../../jwt/api_jwt.py), [jwt/api_jws.py](../../jwt/api_jws.py)). |
| `decode_complete(...) -> dict` | Like `decode`, returning `header`, `payload`, and `signature`. |
| `get_unverified_header(token) -> dict` | Parses header fields without signature verification; the method documentation says headers must not be fully trusted before verification ([jwt/api_jws.py](../../jwt/api_jws.py)). |
| `PyJWT` / `PyJWS` | Stateful high-level JWT and lower-level JWS objects; options and custom algorithms may be configured per object. |
| `PyJWK` / `PyJWKSet` | JWK and JWK Set parsers usable as key inputs or for key inspection. |
| `PyJWKClient` | Remote HTTP(S) JWKS key discovery. It exposes `get_jwk_set`, `get_signing_keys`, `get_signing_key`, and `get_signing_key_from_jwt` ([jwt/jwks_client.py](../../jwt/jwks_client.py)). |
| `register_algorithm`, `unregister_algorithm`, `get_algorithm_by_name` | Modify or inspect the module-level JWS algorithm registry ([jwt/api_jws.py](../../jwt/api_jws.py)). |
| Exceptions and `InsecureKeyLengthWarning` | Typed failure and warning contracts re-exported from `jwt` ([jwt/exceptions.py](../../jwt/exceptions.py)). |

## Inputs, Validation, And Failures

- **verified:** token payloads must be JSON objects represented by a Python `dict`; invalid serialization, segments, header fields, signatures, keys, and claims raise public `PyJWTError` subclasses.
- **verified:** JWS verification checks the token's `alg` against the caller's allowed algorithms. A `PyJWK` key has an algorithm binding that must match the header value.
- **verified:** default JWT options validate signature, expiration, not-before, issued-at, audience, issuer, subject, and JWT ID; applications supply expected audience, issuer, subject, and leeway as needed ([jwt/api_jwt.py](../../jwt/api_jwt.py)).
- **verified:** key-related error and availability cases include `InvalidKeyError`, `PyJWKError`, `PyJWKSetError`, and `MissingCryptographyError`; remote-key cases include `PyJWKClientError` and `PyJWKClientConnectionError` ([jwt/exceptions.py](../../jwt/exceptions.py)).

## Algorithms And Optional Dependency

Built-in HMAC algorithms are available without extra dependencies. RSA, RSA-PSS, EC, and EdDSA algorithms require the optional `cryptography` extra, declared as `PyJWT[crypto]` ([pyproject.toml](../../pyproject.toml), [jwt/algorithms.py](../../jwt/algorithms.py)). The public API also permits custom `Algorithm` implementations through registration; their behavior is application-defined.

## JWKS Network Boundary

`PyJWKClient` accepts an HTTP(S) URI, optional request headers, timeout, and SSL context. It selects keys with `use` unset or equal to `sig` and a `kid`; on a missing key it refreshes the set once. Default JWKS-set caching uses a five-minute lifespan, while optional per-key LRU caching has no time-based expiry ([jwt/jwks_client.py](../../jwt/jwks_client.py)).

## Compatibility And Verification

- **verified:** package metadata declares Python `>=3.9`; CI covers CPython 3.9-3.14 and listed PyPy versions ([pyproject.toml](../../pyproject.toml), [.github/workflows/main.yml](../../.github/workflows/main.yml)).
- **verified:** versioning is dynamic from `jwt.__version__`, currently defined in the facade ([pyproject.toml](../../pyproject.toml), [jwt/__init__.py](../../jwt/__init__.py)).
- **missing:** no explicit semantic-versioning or API deprecation policy was found; existing code emits warnings for some deprecated arguments.
- **verified:** `tests/test_jwt.py` smoke-tests global facade functions; behavior is additionally covered by API, algorithm, JWK, JWKS-client, and exception-focused tests under [tests/](../../tests/).