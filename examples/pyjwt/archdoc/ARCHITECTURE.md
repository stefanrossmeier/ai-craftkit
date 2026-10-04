# Architecture

Review Scope: full repository snapshot
Doc Status: MAINTAINED
Last Updated: 2026-10-04T09:21:37Z
Updated By: agent
Source Repository: [jpadilla/pyjwt](https://github.com/jpadilla/pyjwt/tree/7144e4534c34810f4525dc4578a32addd8212cff)
Source Revision: [7144e4534c34810f4525dc4578a32addd8212cff](https://github.com/jpadilla/pyjwt/commit/7144e4534c34810f4525dc4578a32addd8212cff)
Source Basis: package metadata, public API, implementation, tests, usage/reference docs, CI configuration

Related docs: [REPO_MAP.md](REPO_MAP.md), [API_SURFACE.md](API_SURFACE.md), and [OPERATIONS.md](OPERATIONS.md).

## Purpose and Scope

PyJWT is an in-process Python library for creating and consuming JWTs. It owns compact JWT serialization/parsing, JWS signing and signature verification, JWT registered-claim validation, JWK conversion, and optional retrieval of signing keys from a remote JWKS endpoint.

Host applications are outside the boundary. They own token issuance policy, key material and secret storage, accepted algorithms, audience/issuer expectations, token persistence, authentication/authorization decisions, and any network endpoint that serves a JWKS.

## Architecture Drivers and Constraints

| Concern | Evidence | Architectural consequence | Status |
|---|---|---|---|
| Token integrity and safe verification | [`jwt/api_jwt.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/api_jwt.py) warns callers to configure allowed algorithms independently of token input; [`jwt/api_jws.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/api_jws.py) requires an allowed-algorithms argument when signature verification uses a non-JWK key | Decode first parses JWS, then verifies against the caller's allow-list, then validates claims | verified |
| JWT/JWS protocol support | [README](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/README.rst) identifies RFC 7519; JWS compact processing is implemented in [`jwt/api_jws.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/api_jws.py) | JSON claim objects are serialized into compact signed tokens and decoded through JWS before claim checks | verified |
| Python/runtime compatibility | [`pyproject.toml`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/pyproject.toml) requires Python >=3.9; CI runs CPython 3.9-3.14 and PyPy variants | Code and typing retain Python 3.9 compatibility paths | verified |
| Optional asymmetric cryptography | [`pyproject.toml`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/pyproject.toml) defines the `crypto` extra; [`jwt/algorithms.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/algorithms.py) conditionally imports `cryptography` | HMAC is always available; RSA, EC, PSS, and EdDSA algorithms appear only when `cryptography` is installed | verified |

No human-owned source establishing the historical rationale or priority of these concerns was found; the implementation establishes consequences, not intent.

## Context and Solution Strategy

| Actor / external system | Relationship | Boundary | Status |
|---|---|---|---|
| Host Python application | Calls the public `jwt` library API and supplies key/claim policy | in-process Python API | verified |
| JWKS endpoint, when used | Serves JSON Web Key Sets to `PyJWKClient` | outbound HTTP(S) via `urllib.request` | verified |
| `cryptography`, when installed | Provides asymmetric-key primitives | optional in-process package dependency | verified |

The library presents a small package facade over a layered implementation: `PyJWT` handles JSON JWT payloads and claim checks; it delegates compact signing/parsing to `PyJWS`; `PyJWS` resolves concrete `Algorithm` implementations. JWK models bind key metadata and algorithms, while `PyJWKClient` fetches and selects remote public signing keys.

## Major Building Blocks and Dependency Direction

| Component | Responsibility | Depends on | Owned state/data | Status |
|---|---|---|---|---|
| `jwt.__init__` | Public exports and convenience functions | API modules, JWK client, exceptions | process-global convenience `PyJWT`/`PyJWS` objects created by module APIs | verified |
| `api_jwt.PyJWT` | Payload JSON conversion and registered-claim validation | `PyJWS`, exceptions | per-instance validation options | verified |
| `api_jws.PyJWS` | JWS compact representation, headers, algorithm allow-list, signing/verification | algorithms, JWKs, utilities | per-instance algorithm registry and signature options | verified |
| `algorithms` | HMAC and optional asymmetric algorithm implementations | standard library; optional `cryptography` | algorithm objects and key preparation rules | verified |
| `api_jwk` | Parse/represent JWKs and JWK sets | algorithms, utilities | JWK metadata and prepared keys | verified |
| `jwks_client.PyJWKClient` | Fetch, cache, select remote signing keys | `urllib`, JWK models, JWT header parsing | optional in-memory JWKS and LRU key caches | verified |

Dependency direction is `PyJWT -> PyJWS -> Algorithm` for token handling. JWK and JWKS-client paths feed a prepared `PyJWK` into verification; the client does not perform authorization or final token verification itself.

## Data and State Ownership

The library has no durable repository-owned state and does not persist tokens or keys. Token bytes, claims, supplied keys, accepted algorithms, and authorization interpretation are caller-owned. A remote JWKS endpoint is authoritative for its own key-set response.

Process-local state is limited to `PyJWT`/`PyJWS` options and algorithm registries, plus `PyJWKClient` caches. The JWKS-set cache defaults to 300 seconds; its optional per-key LRU cache defaults to disabled and has no time expiry. See [OPERATIONS.md](OPERATIONS.md) for effects and failure handling.

## Cross-Cutting Concepts and Invariants

| Concept / invariant | Evidence | Architectural effect | Status |
|---|---|---|---|
| Verified decode requires an algorithm allow-list for ordinary keys | [`jwt/api_jws.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/api_jws.py); [`tests/test_api_jws.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/tests/test_api_jws.py) | Prevents token header selection from defining the accepted verification algorithm set | verified |
| Claim validation defaults on with signature validation | [`PyJWT._get_default_options`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/api_jwt.py) | `exp`, `nbf`, `iat`, `aud`, `iss`, `sub`, and `jti` checks are enabled unless options alter them | verified |
| Unverified headers and claims are explicitly exposed but not trusted | [`docs/usage.rst`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/docs/usage.rst) | Consumers must treat the returned unverified material as untrusted until verification | verified |
| JWKS URLs are restricted to HTTP(S) | [`PyJWKClient.__init__`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/jwks_client.py) | Prevents the JWKS client from using `file:`, `ftp:`, or `data:` URI handlers | verified |
| Extensions are per-instance algorithm registrations | [`PyJWS.register_algorithm`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/api_jws.py) and tests | Custom algorithm registration mutates the selected `PyJWS` instance only | verified |

## Representative Interaction

### Verified JWT decode

1. The host application calls `jwt.decode` or `PyJWT.decode` with a token, key, and allowed algorithms.
2. `PyJWT.decode_complete` delegates compact token loading and signature verification to `PyJWS`.
3. `PyJWT` decodes the payload as a JSON object and validates configured registered claims using the current UTC time and supplied audience, issuer, subject, and leeway.
4. The library returns claims or raises a typed exception. Detailed contract behavior is in [API_SURFACE.md](API_SURFACE.md).

## Decisions, Risks, and Unknowns

- No ADRs were found in this revision. Rationale for the global convenience objects, algorithm registry shape, cache defaults, and HTTP-client choice is **missing**.
- `PyJWKClient` is synchronous and uses `urllib`; no async client contract is evidenced.
- The repository does not provide a service deployment topology or application observability surface; it is a library, and host applications own those concerns.