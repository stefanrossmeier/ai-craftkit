# PyJWT API Surface

**Review Scope:** targeted static repository inspection
**Doc Status:** MAINTAINED
**Last Updated:** 2026-10-04T07:40:52Z
**Updated By:** agent
**Source Revision:** `7144e4534c34810f4525dc4578a32addd8212cff`
**Source Basis:** `jwt/__init__.py`, API modules, `jwt/types.py`, `jwt/exceptions.py`, `docs/api.rst`, and focused API/JWKS tests

## Contract Owner And Sources

**Verified:** The `jwt` Python package owns the public library interface. [`jwt/__init__.py`](../../jwt/__init__.py) is the export inventory; [`docs/api.rst`](../api.rst) is the generated Sphinx API-reference source. The package is typed, signaled by [`jwt/py.typed`](../../jwt/py.typed).

There is no HTTP, RPC, CLI, event, webhook, or plugin contract registered by this repository.

## Primary Interface

| Export | Contract |
| --- | --- |
| `encode(payload, key, algorithm, headers, json_encoder, sort_headers)` | Creates a signed JWT string from a dictionary payload. Defaults to `HS256` unless algorithm selection comes from a `PyJWK` or supplied header. |
| `decode(jwt, key, algorithms, options, audience, subject, issuer, leeway)` | Verifies a compact JWT and returns its JSON-object payload after enabled claim checks. |
| `decode_complete(...)` | Performs decode/verification and returns a mapping containing `header`, `payload`, and `signature`. |
| `get_unverified_header(jwt)` | Parses and returns the protected header without signature validation. |
| `PyJWT` | Configurable instance form of the high-level encode/decode API. It supports override hooks for payload encoding and decoding. |
| `PyJWS` | Lower-level compact JWS API for signing/verifying bytes and inspecting signatures. |
| `PyJWK`, `PyJWKSet` | Key and key-set adapters for RFC 7517-style JWK data. |
| `PyJWKClient` | Retrieves a JWKS and returns an applicable signing key, including `get_signing_key_from_jwt()`. |
| `register_algorithm`, `unregister_algorithm`, `get_algorithm_by_name` | Modify or inspect the registry backing the module-level JWS convenience API. |

The full signatures, properties, and documented members are generated from source by [`docs/api.rst`](../api.rst). `PyJWS` reference coverage is explicitly marked unfinished in that file.

## Inputs, Outputs, And Validation

- **Verified:** JWT payload input to `encode` must be a dictionary. Known datetime claims (`exp`, `iat`, `nbf`) are converted to NumericDate integers before serialization.
- **Verified:** Signed decode accepts `str` or `bytes` token input and returns a dictionary payload. Non-object JSON payloads cause `DecodeError`.
- **Verified:** Signature verification is enabled by default. If it remains enabled, callers must pass `algorithms` unless using a `PyJWK`; supported verification algorithms must be chosen independently of attacker-controlled token data.
- **Verified:** Default claim checks cover `exp`, `nbf`, `iat`, `aud`, `iss`, `sub`, and `jti`. `options` can alter verification flags, require claims, enable strict audience handling, and enforce minimum key length.
- **Verified:** JWK input may be a mapping or JSON text. JWK sets require a non-empty list and discard unusable keys except missing `cryptography`, which is surfaced as an error.
- **Verified:** `PyJWKClient` accepts only `http`/`https` URIs. Its `headers`, `timeout`, and `ssl_context` inputs configure the outbound JWKS request.

## Failure And Compatibility Behavior

- **Verified:** [`jwt/exceptions.py`](../../jwt/exceptions.py) provides the public `PyJWTError` root plus decoding, signature, claim, key, JWK-set, and JWKS-client exception subclasses. Consumers can catch these types rather than parse error text.
- **Verified:** [`jwt/warnings.py`](../../jwt/warnings.py) exposes `InsecureKeyLengthWarning` and a `RemovedInPyjwt3Warning` deprecation category. Deprecated keyword patterns in decode paths emit warnings.
- **Verified:** `cryptography` is optional at install time, but APIs requiring it raise `MissingCryptographyError` or report the selected algorithm as unavailable.
- **Verified:** Package version is dynamic from `jwt.__version__`; this revision declares `2.13.0`. No separate protocol versioning scheme is evidenced.

## Contract Verification

- [`tests/test_api_jwt.py`](../../tests/test_api_jwt.py) exercises payload decoding, options, claim behavior, and JWK algorithm selection.
- [`tests/test_api_jws.py`](../../tests/test_api_jws.py) exercises compact JWS, signatures, headers, and algorithm registry behavior.
- [`tests/test_api_jwk.py`](../../tests/test_api_jwk.py) and [`tests/test_jwks_client.py`](../../tests/test_jwks_client.py) exercise JWK construction, remote retrieval, caching, and error paths.
- [`tox.ini`](../../tox.ini) runs tests across supported Python and optional-dependency variants, and validates Sphinx API documentation in the `docs` environment.

Operational package and release interfaces are described in [OPERATIONS.md](OPERATIONS.md).