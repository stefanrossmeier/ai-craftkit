# Glossary

> Generated with `ai-craftkit` skill: `glossary`
> Source: `https://github.com/jpadilla/pyjwt.git` at commit `7144e4534c34810f4525dc4578a32addd8212cff`
> Prompt: `Extract terms of the pyjwt repo`

Last Reviewed Scope: full review
Doc Status: DRAFT
Last Glossary Update: 2026-07-24T12:53:51Z
Updated By: agent
Source Basis: docs scan, code scan, tests scan
Domain Expert Review: NOT REVIEWED

## Purpose and Scope

This glossary captures the observed domain language of the PyJWT repository from its public docs, tests, and core JWT/JWK modules. PyJWT is a protocol library rather than a business workflow system, so its strongest domain language comes from the JSON Web Token family of standards and nearby OpenID Connect examples.

The terms below describe candidate ubiquitous language seen in the repository. They should be treated as repository-observed language until maintainers confirm which terms they want to use consistently in docs, code, and user guidance.

## Domain Overview

PyJWT implements the encoding, decoding, signing, and validation of JSON Web Tokens. The repository language centers on claim semantics, signature verification, allowed-algorithm policy, key representation through JWK and JWKS, and remote signing-key lookup by `kid`. A smaller amount of language comes from interoperability examples, especially OpenID Connect login flows.

## Candidate Bounded Contexts

The repository does not show business-owned bounded contexts. The table below groups protocol responsibilities that carry distinct language.

| Candidate Context | Business Capability | Distinctive Language | Evidence | Confidence |
|---|---|---|---|---|
| Token construction and validation | Create signed tokens and validate their claims and signatures | JWT, claimset, issuer, audience, subject, expiration, leeway, required claims | `README.rst`, `docs/usage.rst`, `tests/test_api_jwt.py`, `jwt/exceptions.py` | verified |
| Key representation and key-set resolution | Represent verification keys and resolve a matching signing key for a token | JWK, JWKS, signing key, key ID, key type, public key use | `docs/usage.rst`, `tests/test_api_jwk.py`, `tests/test_jwks_client.py`, `jwt/api_jwk.py`, `jwt/jwks_client.py` | verified |
| OIDC interoperability examples | Show how PyJWT fits into an ID-token validation flow | ID token, access token, `at_hash`, JWKS URI, signing algorithms | `docs/usage.rst` | inferred |

## Ubiquitous Language

| Term | Meaning | Category | Related Terms | Evidence | Confidence |
|---|---|---|---|---|---|
| JSON Web Token (JWT) | A compact token that carries a set of claims and a signature so another party can verify statements about a subject. | Business Object | claimset, header, signature, issuer, audience | `README.rst`, `docs/index.rst`, `docs/usage.rst`, `tests/test_api_jwt.py` | verified |
| Claim | A single statement carried inside a JWT, such as who issued it, who it is for, or when it expires. | Other Domain Concept | claimset, registered claim name | `docs/usage.rst`, `tests/test_api_jwt.py` | verified |
| Claimset | The full set of claims carried in the JWT body and interpreted during validation. | Other Domain Concept | claim, payload, registered claim name | `docs/usage.rst`, `jwt/exceptions.py`, `tests/test_api_jwt.py` | verified |
| Header | The token metadata section that names the signing algorithm and can carry key-selection information such as `kid` and token type such as `typ`. | Business Document | JWT, `alg`, `kid`, `typ` | `docs/usage.rst`, `tests/test_api_jws.py` | verified |
| Registered claim name | A standards-defined claim whose meaning and validation behavior are fixed enough for the library to enforce or help enforce. | Classification | `exp`, `nbf`, `iss`, `aud`, `iat`, `sub`, `jti` | `docs/usage.rst`, `tests/test_api_jwt.py` | verified |
| Expiration Time (`exp`) | The time after which a token must no longer be accepted for processing. | Time Concept | leeway, expired token | `docs/usage.rst`, `tests/test_api_jwt.py`, `jwt/exceptions.py` | verified |
| Not Before (`nbf`) | The earliest time at which a token becomes acceptable for processing. | Time Concept | leeway, immature token | `docs/usage.rst`, `tests/test_api_jwt.py`, `jwt/exceptions.py` | verified |
| Issuer (`iss`) | The principal that issued the token. | Actor or Role | subject, audience | `docs/usage.rst`, `tests/test_api_jwt.py`, `jwt/exceptions.py` | verified |
| Audience (`aud`) | The intended recipient or recipients that are allowed to process the token. | Actor or Role | issuer, subject | `docs/usage.rst`, `tests/test_api_jwt.py`, `jwt/exceptions.py` | verified |
| Issued At (`iat`) | The time at which the token was issued, used to reason about token age and premature use. | Time Concept | not before, immature token | `docs/usage.rst`, `tests/test_api_jwt.py`, `jwt/exceptions.py` | verified |
| Subject (`sub`) | The principal that the token is about. | Actor or Role | issuer, JWT ID | `docs/usage.rst`, `tests/test_api_jwt.py`, `jwt/exceptions.py` | verified |
| JWT ID (`jti`) | A token-specific identifier intended to be unique enough to distinguish one token from another and support replay protection workflows. | Classification | subject, replay attack | `docs/usage.rst`, `tests/test_api_jwt.py`, `jwt/exceptions.py` | verified |
| Leeway | A small tolerance window added during time-based validation to absorb clock skew between the token producer and the validator. | Policy or Rule | `exp`, `nbf`, `iat` | `docs/usage.rst`, `tests/test_api_jwt.py` | verified |
| Required claim | A claim whose presence is mandatory for a particular validation call, even if the JWT standard itself marks that claim as optional. | Policy or Rule | claimset, missing required claim | `docs/usage.rst`, `tests/test_api_jwt.py`, `jwt/exceptions.py` | verified |
| Algorithm allow-list | The caller-defined set of signing algorithms that are permitted during decode; the repository treats this as a security control, not token-supplied data. | Policy or Rule | `alg`, signature verification, signing key | `docs/algorithms.rst`, `tests/test_api_jws.py` | verified |
| JWK (JSON Web Key) | A structured JSON representation of a cryptographic key, including its type and optionally its algorithm, use, and key identifier. | Business Object | JWKS, signing key, `kty`, `alg`, `use`, `kid` | `tests/test_api_jwk.py`, `jwt/api_jwk.py`, `docs/api.rst` | verified |
| JWK Set (JWKS) | A collection of JWKs published together so a consumer can select the right verification key for a token. | Business Document | JWK, signing key, JWKS endpoint | `docs/usage.rst`, `tests/test_jwks_client.py`, `jwt/api_jwk.py` | verified |
| Signing key | The key selected to verify a token signature, usually from a JWKS and typically filtered to keys intended for signature use. | Business Object | JWK, JWKS, `kid`, `use=sig` | `docs/usage.rst`, `tests/test_jwks_client.py`, `jwt/jwks_client.py` | verified |
| Key ID (`kid`) | The identifier used to match a token header to the correct key in a JWK Set. | Classification | header, signing key, JWKS | `docs/usage.rst`, `tests/test_jwks_client.py`, `jwt/api_jwk.py`, `jwt/jwks_client.py` | verified |
| `at_hash` | An OpenID Connect claim that binds an ID token to the access token returned in the same login flow. PyJWT shows how to compute and validate it, but does not validate it automatically. | Other Domain Concept | ID token, access token, OIDC login flow | `docs/usage.rst` | verified |

## Domain Rules Encoded in Language

| Concept | Rule expressed by the repository | Evidence | Confidence |
|---|---|---|---|
| Expiration Time (`exp`) | A token is rejected once the current UTC time is after its expiration, unless the caller allows enough leeway to keep it temporarily acceptable. | `docs/usage.rst`, `tests/test_api_jwt.py`, `jwt/exceptions.py` | verified |
| Not Before (`nbf`) and Issued At (`iat`) | A token can be rejected as immature when its time-based claims place it in the future relative to the validator. | `docs/usage.rst`, `tests/test_api_jwt.py`, `jwt/exceptions.py` | verified |
| Audience (`aud`) | When an audience claim is present, the validator must identify itself with an accepted audience value or reject the token. | `docs/usage.rst`, `tests/test_api_jwt.py`, `jwt/exceptions.py` | verified |
| Required claim | Validation can require claims such as `exp`, `iss`, or `sub` even though the JWT standard describes them as optional in the abstract. | `docs/usage.rst`, `tests/test_api_jwt.py`, `jwt/exceptions.py` | verified |
| Algorithm allow-list | The repository warns against trusting the token's own `alg` header to decide what algorithms are acceptable during validation. | `docs/algorithms.rst`, `tests/test_api_jws.py` | verified |
| JWKS key lookup | When a `kid` does not match any current signing key, the client refreshes the JWKS and retries once before failing. | `docs/usage.rst`, `tests/test_jwks_client.py`, `jwt/jwks_client.py` | verified |

## Language Tensions

| Terms or Forms | Tension | Evidence | Impact | Review Question |
|---|---|---|---|---|
| `payload` vs `claimset` | Both names refer to the JWT body. `payload` dominates APIs and tests, while `claimset` is used when the docs discuss meaning and validation semantics. | `docs/usage.rst`, `tests/test_api_jwt.py`, `tests/test_api_jws.py`, `jwt/exceptions.py` | Readers may miss the distinction between raw serialized content and the semantically interpreted set of claims. | Should PyJWT treat `claimset` as the preferred semantic term and `payload` as the serialization term, or are they intended to stay interchangeable? |
| `JWT` vs `JWS` | Public docs are JWT-first, but the codebase also exposes JWS-specific processing for header handling and signature verification. | `docs/index.rst`, `docs/api.rst`, `tests/test_api_jws.py` | Users may not know when they are dealing with claim-aware JWT behavior versus lower-level signature behavior. | Is `JWS` a first-class user concept in this repo, or mainly an internal/expert-facing distinction? |
| `azp` and `gty` | These example claims appear in the JWKS and OIDC examples, but the repository does not define them or validate them as named concepts. | `docs/usage.rst`, `tests/test_jwks_client.py` | Readers could misread example-only provider claims as part of PyJWT's own vocabulary. | Should these claims be documented as provider-specific examples or removed from core examples? |
| Compressed JWT language | A test demonstrates decoding a compressed payload through subclassing, but the docs do not present compressed JWT handling as a built-in feature. | `tests/test_compressed_jwt.py` | Users may infer productized support from a test-only example. | Is compressed-payload handling meant as an extension example only, or should the supported boundary be documented? |

## Missing Definitions

Repository areas checked: `README.rst`, `docs/`, `tests/`, `jwt/api_jwk.py`, `jwt/jwks_client.py`, `jwt/exceptions.py`.

- `azp` appears in examples but is not defined in repository language.
- `gty` appears in examples but is not defined in repository language.
- The intended support boundary for compressed JWT payloads is not recoverable from docs alone.

## Domain Expert Review Questions

1. Should PyJWT standardize on `claimset` for semantics and reserve `payload` for the raw JWT body, or should the glossary document them as synonyms?
2. Do maintainers want `JWS` documented as a user-facing concept, or mainly as an implementation layer that supports JWT behavior?
3. Should OIDC example-only claims such as `azp` and `gty` be explicitly labeled as external-provider vocabulary rather than PyJWT vocabulary?
4. Is compressed JWT handling an endorsed extension point or just a test demonstration?