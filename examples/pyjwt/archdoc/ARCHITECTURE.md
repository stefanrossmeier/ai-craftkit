# PyJWT Architecture

**Review Scope:** targeted static repository inspection
**Doc Status:** MAINTAINED
**Last Updated:** 2026-10-04T07:40:52Z
**Updated By:** agent
**Source Revision:** `7144e4534c34810f4525dc4578a32addd8212cff`
**Source Basis:** `jwt/__init__.py`, `jwt/api_jwt.py`, `jwt/api_jws.py`, `jwt/algorithms.py`, `jwt/api_jwk.py`, `jwt/jwks_client.py`, and focused tests

## System Shape

**Verified:** PyJWT is an in-process library. Its central processing path builds on JWS compact serialization and adds JWT JSON-payload and registered-claim handling. It has no server, database, or persistent application state in this repository.

```mermaid
flowchart TD
    Consumer[Python consumer] --> Public[jwt public exports]
    Public --> JWT[PyJWT: payload and claims]
    JWT --> JWS[PyJWS: compact JWS and signatures]
    JWS --> Algorithms[Algorithm registry and implementations]
    Public --> JWK[PyJWK and PyJWKSet]
    Public --> Client[PyJWKClient]
    Client --> Cache[JWK set and optional key caches]
    Client --> Endpoint[Remote HTTP(S) JWKS endpoint]
    JWK --> Algorithms
```

## Components And Boundaries

| Component | Responsibility | Dependencies and direction |
| --- | --- | --- |
| [`jwt/__init__.py`](../../jwt/__init__.py) | Presents supported top-level functions, classes, warnings, and exceptions. | Imports API, JWK, client, and error modules for consumer use. |
| [`PyJWT`](../../jwt/api_jwt.py) | Serializes a JSON-object claim set; decodes it; validates expiration, not-before, issued-at, audience, issuer, subject, JWT ID, and required claims. | Owns high-level options and delegates signature work to `PyJWS`. |
| [`PyJWS`](../../jwt/api_jws.py) | Encodes and parses JWS compact segments; validates protected-header conditions; selects and invokes an algorithm. | Owns an instance algorithm registry and uses utilities, JWKs, and algorithms. |
| [`algorithms.py`](../../jwt/algorithms.py) | Supplies default algorithm objects and key preparation/sign/verify implementations. | Uses standard-library primitives and conditionally imports `cryptography` for asymmetric/EdDSA support. |
| [`PyJWK` and `PyJWKSet`](../../jwt/api_jwk.py) | Convert JWK dictionaries/JSON into algorithm-specific key material and collect usable keys. | Selects algorithms by declared or inferred key metadata. |
| [`PyJWKClient`](../../jwt/jwks_client.py) | Retrieves a JWKS over HTTP(S), caches it, selects a signing key by `kid`, and refreshes once on a miss. | Uses `urllib.request`, JWK objects, and `JWKSetCache`; it does not perform token signature verification itself. |
| Shared modules | [`exceptions.py`](../../jwt/exceptions.py), [`types.py`](../../jwt/types.py), [`utils.py`](../../jwt/utils.py), and [`warnings.py`](../../jwt/warnings.py) provide cross-cutting contracts. | Referenced by the layers above; they do not own orchestration. |

## Data And State Ownership

- **Verified:** `PyJWT` owns merged JWT validation options; signature-specific options are passed to its internal `PyJWS` instance.
- **Verified:** Each `PyJWS` instance owns its algorithm map and permitted algorithm names. Module-level convenience functions share a global `PyJWS` object, so registering or unregistering an algorithm through the top-level API changes that object's registry.
- **Verified:** `PyJWKClient` optionally owns two in-memory caches: a JWK-set cache with a configurable TTL (default 300 seconds) and an optional per-key LRU cache (default maximum 16 entries). Neither is durable across process restarts.
- **Verified:** Consumers own keys, token values, validation configuration, and any handling of raised exceptions or emitted warnings.

## Important Paths

### Signing

**Verified:** `jwt.encode()` delegates to `PyJWT.encode()`, which requires a dictionary payload, converts known datetime claims to NumericDate values, JSON-encodes the payload, then delegates compact serialization and signing to `PyJWS.encode()`. The selected algorithm prepares the key and signs the encoded header/payload input.

### Verification And Claim Validation

**Verified:** `jwt.decode()` delegates to `PyJWT.decode_complete()`, which asks `PyJWS` to parse and verify the JWS before JSON-decoding the payload and validating claims. With signature verification enabled, a caller must provide an explicit algorithm allow-list unless the key is a `PyJWK`. Claim validation defaults are defined in [`PyJWT._get_default_options`](../../jwt/api_jwt.py).

### Remote Key Retrieval

**Verified:** `PyJWKClient` accepts only `http` and `https` endpoint schemes, fetches JWKS JSON through `urllib`, filters usable signing keys, and matches a `kid`. A missing match forces one JWKS refresh before it raises `PyJWKClientError`.

## Constraints And External Dependencies

- **Verified:** The package requires Python 3.9+; `typing_extensions` is installed only for Python versions below 3.11.
- **Verified:** HMAC algorithms work without the optional `cryptography` extra. Algorithms marked as requiring it are unavailable otherwise.
- **Verified:** The library treats algorithm selection as caller-controlled verification input. API documentation warns against deriving the allowed-algorithm list from token-controlled header data.
- **Verified:** Remote JWKS access depends on an external HTTP(S) endpoint and caller-supplied network, TLS, timeout, and optional request-header configuration.

## Decisions And Open Questions

- **Missing:** No ADR directory or other explicit architectural decision records were found, so this document does not infer why the current layering, defaults, or caching policy were chosen.
- **Missing:** Static inspection found no telemetry, logging, or metrics integration. Runtime observability behavior outside raised exceptions and warnings is not evidenced.

Detailed public contracts belong in [API_SURFACE.md](API_SURFACE.md); local verification and package-release behavior belongs in [OPERATIONS.md](OPERATIONS.md).