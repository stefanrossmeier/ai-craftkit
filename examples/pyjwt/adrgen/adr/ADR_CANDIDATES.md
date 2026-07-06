# ADR Candidates

> Generated with `ai-craftkit` skill: `adrgen`  
> Source: `https://github.com/jpadilla/pyjwt.git` at commit `7144e4534c34810f4525dc4578a32addd8212cff`  
> Prompt: `/adrgen discover Have a look into the pyjwt repo. Find all architecural decisions that are noteworthy and document them as ADR candidates.`

Last Reviewed Scope: full review
Doc Status: NEEDS REVIEW
Last ADR Candidate Update: 2026-07-06T21:50:58Z
Updated By: agent
Source Basis: README scan, docs scan, code scan, tests scan, manifest scan, tox scan, git metadata

## Purpose

This document captures architectural decisions that appear to exist in PyJWT but are not yet documented as ADRs. The focus is on decisions that shape security boundaries, public API layers, extension seams, and dependency/runtime behavior.

## Evidence Legend

- `verified`: directly confirmed in repository code, docs, config, or tests.
- `inferred`: strongly suggested by recurring structure or partial evidence, but not explicitly justified.
- `missing`: likely rationale was searched for but not found in current repository materials.

## Candidate Summary

| ID | Title | Confidence | Impact | Suggested ADR | Notes |
|---|---|---|---|---|---|
| CAND-001 | Separate JWS processing from JWT claim validation | high | high | `docs/adr/0001-separate-jws-processing-from-jwt-claim-validation.md` | Public API exposes both layers and shares a common JWS core. |
| CAND-002 | Keep asymmetric cryptography optional via `pyjwt[crypto]` | high | high | `docs/adr/0002-make-cryptography-an-optional-runtime-dependency.md` | Base install stays light while advanced algorithms remain available. |
| CAND-003 | Require caller-controlled algorithm allow-lists and reject unsafe key reuse | high | high | `docs/adr/0003-enforce-explicit-algorithm-whitelists-and-safe-key-family-checks.md` | Security-sensitive default that constrains decode behavior. |
| CAND-004 | Treat JWK and JWK Set objects as first-class key inputs | high | medium | `docs/adr/0004-model-keys-as-jwk-objects.md` | Key metadata drives algorithm selection and interop behavior. |
| CAND-005 | Bundle a conservative JWKS client with layered caching | high | medium | `docs/adr/0005-provide-a-built-in-jwks-client-with-safe-defaults.md` | Includes scheme restrictions, TTL caching, and optional key LRU caching. |
| CAND-006 | Preserve explicit extension seams for algorithms and payload handling | high | medium | `docs/adr/0006-keep-algorithm-and-payload-processing-extensible.md` | Users can register algorithms and subclass payload decoding behavior. |
| CAND-007 | Default to standards-driven claim validation with opt-out switches | high | medium | `docs/adr/0007-default-to-registered-claim-validation-with-configurable-strictness.md` | Claim validation is a separate default-on stage with strict audience support. |

## Candidates

## CAND-001: Separate JWS processing from JWT claim validation

Candidate Status: new
Generate ADR: undecided
Suggested ADR: docs/adr/0001-separate-jws-processing-from-jwt-claim-validation.md
Generated ADR: none
Decision Status: unknown
Confidence: high
Impact: high
Affected area: public API, token processing pipeline, testing boundaries
Source Mode: discover

### Why this looks like an architectural decision

PyJWT does not implement token handling as a single monolithic function. Instead, it keeps JOSE/JWS parsing and signature verification in `PyJWS`, then layers JSON payload decoding and registered-claim validation in `PyJWT`. That split is visible in the public API, the module layout, and the repository's own flow documentation.

### Evidence

| Evidence | Type | Supports | Status |
|---|---|---|---|
| `jwt/api_jwt.py` | code | `PyJWT` owns claim validation and delegates signature work to `PyJWS` | verified |
| `jwt/api_jws.py` | code | `PyJWS` owns compact-token parsing, header checks, and signature verification | verified |
| `jwt/api_jwt.py` and `jwt/api_jws.py` | code | Module-level `encode` and `decode` functions are facades over shared global objects | verified |
| `docs/diagrams/decode-flow.md` and `docs/diagrams/validation-flow.md` | doc | Repository documentation already explains the two-stage flow as separate concerns | verified |
| `tests/test_api_jws.py` and `tests/test_api_jwt.py` | test | JWS and JWT behaviors are tested independently | verified |

### Likely Alternatives

- A single encode/decode implementation that combines signature, parsing, and claim validation in one layer.
- Public utility functions only, without exposing `PyJWS` and `PyJWT` as distinct objects.

### Known Consequences

- Security-sensitive signature handling and standards-driven claim validation can evolve and be tested separately.
- The public API supports both convenience functions and lower-level advanced use cases such as detached payloads and header inspection.
- Backward compatibility now depends on keeping the shared global-object facade aligned with the class-based APIs.

### Open Questions

- Could not find a recorded rationale for when `PyJWS` became a supported public abstraction instead of an internal helper.
- `docs/api.rst` still contains a note saying `PyJWS` documentation is unfinished, which suggests the public-contract status may have evolved incrementally.

### Suggested Next Step

Generate ADR after human review. This is a high-confidence structural decision that affects most future changes to token processing.

## CAND-002: Keep asymmetric cryptography optional via `pyjwt[crypto]`

Candidate Status: new
Generate ADR: undecided
Suggested ADR: docs/adr/0002-make-cryptography-an-optional-runtime-dependency.md
Generated ADR: none
Decision Status: unknown
Confidence: high
Impact: high
Affected area: dependency model, supported algorithms, packaging, CI matrix
Source Mode: discover

### Why this looks like an architectural decision

The repository deliberately supports two runtime modes: a lighter base install and a crypto-enabled install. That choice affects dependency policy, feature availability, code paths in `jwt/algorithms.py`, installation guidance, and the tox matrix.

### Evidence

| Evidence | Type | Supports | Status |
|---|---|---|---|
| `pyproject.toml` | config | `cryptography` is declared as an optional dependency under the `crypto` extra | verified |
| `docs/installation.rst` | doc | Users are instructed to install `pyjwt[crypto]` for RSA, ECDSA, and related algorithms | verified |
| `jwt/algorithms.py` | code | Default algorithms include asymmetric families only when `cryptography` is available | verified |
| `jwt/api_jwk.py` | code | JWK parsing raises `MissingCryptographyError` when a selected algorithm requires unavailable crypto support | verified |
| `tox.ini` | config | The test matrix explicitly covers both `crypto` and `nocrypto` environments across supported Python versions | verified |

### Likely Alternatives

- Make `cryptography` a mandatory dependency for all users.
- Split asymmetric algorithm support into a separate package instead of an extra.

### Known Consequences

- Base consumers can use HMAC-only flows without pulling in heavy crypto dependencies.
- The implementation must maintain conditional imports, optional type aliases, and a broader compatibility matrix.
- Documentation and errors must explain feature availability clearly to avoid confusing runtime failures.

### Open Questions

- The repository does not record why the team preferred an optional extra over a mandatory dependency beyond the current installation guidance.
- It is not documented whether package size, build portability, or startup simplicity was the primary driver.

### Suggested Next Step

Generate ADR after review. This is a project-wide dependency and release-model choice with ongoing maintenance impact.

## CAND-003: Require caller-controlled algorithm allow-lists and reject unsafe key reuse

Candidate Status: new
Generate ADR: undecided
Suggested ADR: docs/adr/0003-enforce-explicit-algorithm-whitelists-and-safe-key-family-checks.md
Generated ADR: none
Decision Status: unknown
Confidence: high
Impact: high
Affected area: decode security boundary, key handling, backward compatibility
Source Mode: discover

### Why this looks like an architectural decision

PyJWT treats algorithm selection as a caller-owned trust boundary rather than inferring it from attacker-controlled token headers. The code and docs also contain specific defenses against key-family confusion, including rejecting PEM, SSH, certificate, and JWK-shaped inputs as HMAC secrets.

### Evidence

| Evidence | Type | Supports | Status |
|---|---|---|---|
| `jwt/api_jws.py` | code | `decode_complete()` raises when signature verification is enabled and `algorithms` is not provided for non-`PyJWK` keys | verified |
| `docs/algorithms.rst` | doc | The documentation explicitly warns against deriving `algorithms` from token data and against mixing symmetric and asymmetric families | verified |
| `jwt/algorithms.py` | code | `HMACAlgorithm.prepare_key()` rejects PEM, SSH, certificate-like, and JWK-shaped inputs to reduce algorithm-confusion risk | verified |
| `tests/test_advisory.py` | test | Regression coverage exists for the advisory around public-key bytes being misused as HMAC secrets | verified |
| `tests/test_api_jws.py` | test | Tokens are rejected when the decode-time algorithm allow-list does not include the token's `alg` | verified |

### Likely Alternatives

- Infer the permitted algorithm set from the token header.
- Accept any decodable key material and rely on callers to avoid key-family confusion.

### Known Consequences

- Callers must be explicit and cannot rely on implicit decode behavior for verified tokens.
- Security defaults are stronger, but integrations are slightly more verbose.
- The library must preserve nuanced validation logic across multiple key formats and algorithm families.

### Open Questions

- The repo does not contain a standalone decision note explaining when the current allow-list rule became mandatory.
- Minimum key length enforcement is documented and implemented, but the rationale for warning-by-default instead of fail-by-default is not captured in existing docs.

### Suggested Next Step

Prioritize this candidate for ADR generation. It is high-impact, security-sensitive, and well supported by docs, code, and tests.

## CAND-004: Treat JWK and JWK Set objects as first-class key inputs

Candidate Status: new
Generate ADR: undecided
Suggested ADR: docs/adr/0004-model-keys-as-jwk-objects.md
Generated ADR: none
Decision Status: unknown
Confidence: high
Impact: medium
Affected area: key ingestion, external identity-provider integration, algorithm selection
Source Mode: discover

### Why this looks like an architectural decision

Instead of forcing callers to translate every remote or structured key into raw bytes first, PyJWT exposes `PyJWK` and `PyJWKSet` as part of the public API. Those objects carry key metadata, drive algorithm selection, and filter unusable keys before verification logic runs.

### Evidence

| Evidence | Type | Supports | Status |
|---|---|---|---|
| `jwt/__init__.py` | code | `PyJWK` and `PyJWKSet` are exported as first-class public API objects | verified |
| `jwt/api_jwk.py` | code | `PyJWK` derives algorithms from `alg`, `kty`, and `crv` metadata and materializes a typed key object | verified |
| `jwt/api_jws.py` and `jwt/api_jwt.py` | code | Encode and decode methods accept `PyJWK` instances directly | verified |
| `tests/test_api_jwt.py` | test | Encoding with a `PyJWK` uses the key's algorithm when the caller does not pass one explicitly | verified |
| `jwt/api_jwk.py` | code | `PyJWKSet` skips unusable keys instead of failing the entire set unless no usable keys remain | verified |

### Likely Alternatives

- Treat JWK handling as a caller concern and accept only raw key bytes or crypto objects.
- Parse JWKs but keep them as internal-only helpers hidden from the public API.

### Known Consequences

- Identity-provider and JWKS integrations can stay closer to wire formats.
- Algorithm selection becomes partially metadata-driven, which is convenient but increases the importance of clear documented defaults.
- The library has to maintain format-specific validation and error reporting for multiple JWK families.

### Open Questions

- The current fallback defaults, such as `RSA -> RS256` and `oct -> HS256`, are implemented but their original rationale is not documented.
- It is unclear whether the team views these defaults as long-term API guarantees or pragmatic convenience behavior.

### Suggested Next Step

Keep as a candidate unless a near-term key-management change is planned. It is important, but less urgent than the decode security boundary.

## CAND-005: Bundle a conservative JWKS client with layered caching

Candidate Status: new
Generate ADR: undecided
Suggested ADR: docs/adr/0005-provide-a-built-in-jwks-client-with-safe-defaults.md
Generated ADR: none
Decision Status: unknown
Confidence: high
Impact: medium
Affected area: remote key retrieval, caching, network trust boundary
Source Mode: discover

### Why this looks like an architectural decision

PyJWT includes its own JWKS client instead of leaving remote key retrieval entirely to application code. That client makes specific choices about accepted URI schemes, cache topology, refresh behavior, timeout handling, and how strictly the returned payload must conform to a JWKS object.

### Evidence

| Evidence | Type | Supports | Status |
|---|---|---|---|
| `jwt/jwks_client.py` | code | `PyJWKClient` is a dedicated component for JWKS retrieval and signing-key lookup | verified |
| `jwt/jwks_client.py` | code | Only `http` and `https` schemes are accepted to avoid unintended `file:`, `ftp:`, `data:`, or similar fetch behavior | verified |
| `jwt/jwks_client.py` | code | The client uses a TTL JWK Set cache and an optional LRU per-key cache with distinct lifecycles | verified |
| `tests/test_jwks_client.py` | test | Non-HTTP schemes, timeout handling, SSL context behavior, invalid lifespan, and cache options are all explicitly tested | verified |
| `jwt/api_jwk.py` | code | JWKS responses are parsed into `PyJWKSet`, reinforcing a typed boundary between network data and verification logic | verified |

### Likely Alternatives

- No built-in JWKS client; callers fetch and parse keys themselves.
- A simpler client with no cache or with only one cache tier.

### Known Consequences

- Common identity-provider integrations are easier to adopt without extra libraries.
- Remote-key behavior becomes part of PyJWT's API and security contract.
- The project must now maintain network-facing behavior, cache invalidation rules, and error semantics in addition to token parsing.

### Open Questions

- The repo does not explain why the JWK Set cache defaults to 300 seconds or why per-key caching is opt-in.
- It is not documented whether the current caching strategy was chosen for operational evidence, compatibility, or conservative security posture.

### Suggested Next Step

Generate ADR if the maintainers want a durable record for remote-key handling and SSRF-adjacent scheme restrictions.

## CAND-006: Preserve explicit extension seams for algorithms and payload handling

Candidate Status: new
Generate ADR: undecided
Suggested ADR: docs/adr/0006-keep-algorithm-and-payload-processing-extensible.md
Generated ADR: none
Decision Status: unknown
Confidence: high
Impact: medium
Affected area: extensibility, advanced integrations, backward compatibility
Source Mode: discover

### Why this looks like an architectural decision

PyJWT exposes controlled extension points instead of treating algorithm support and payload encoding as permanently closed. `PyJWS` allows algorithm registration, and `PyJWT` documents payload encode/decode hooks intended for subclass overrides. The tests cover both behaviors.

### Evidence

| Evidence | Type | Supports | Status |
|---|---|---|---|
| `jwt/api_jws.py` | code | `register_algorithm()` and `unregister_algorithm()` are part of the class API and wired into the module-level facade | verified |
| `tests/test_api_jws.py` | test | Duplicate registration, invalid registration, and algorithm filtering are explicitly tested | verified |
| `jwt/api_jwt.py` | code | `_encode_payload()` and `_decode_payload()` are documented as subclass hooks for alternate payload handling | verified |
| `tests/test_compressed_jwt.py` | test | A `CompressedPyJWT` subclass overrides payload decoding to support compressed payloads | verified |
| `tests/test_algorithms.py` | test | Global registration behavior is preserved for backward compatibility with the top-level API | verified |

### Likely Alternatives

- Keep algorithm support fixed and require forks for non-standard cases.
- Expose only top-level functions and avoid subclass hooks entirely.

### Known Consequences

- Advanced integrations can extend behavior without modifying core code.
- Backward compatibility must account for extension hooks that external users may depend on.
- Non-standard behavior can diverge from JWT/JWS defaults, so extension documentation and test coverage remain important.

### Open Questions

- The repository does not document how stable these extension seams are intended to be across major versions.
- It is unclear whether compressed-payload support is a deliberate long-term use case or primarily a proof that the hook works.

### Suggested Next Step

Keep for review. Promote to an ADR if maintainers want to treat extensibility as a formal compatibility commitment.

## CAND-007: Default to standards-driven claim validation with opt-out switches

Candidate Status: new
Generate ADR: undecided
Suggested ADR: docs/adr/0007-default-to-registered-claim-validation-with-configurable-strictness.md
Generated ADR: none
Decision Status: unknown
Confidence: high
Impact: medium
Affected area: decode semantics, security defaults, interoperability
Source Mode: discover

### Why this looks like an architectural decision

Signature verification is not the only default-on behavior in PyJWT. The library has a dedicated claim-validation stage with per-claim switches, required-claim enforcement, leeway handling, and a `strict_aud` mode. That shapes how downstream applications rely on `jwt.decode()` and where caller policy ends versus library policy begins.

### Evidence

| Evidence | Type | Supports | Status |
|---|---|---|---|
| `jwt/api_jwt.py` | code | Default options enable `exp`, `nbf`, `iat`, `aud`, `iss`, `sub`, and `jti` verification alongside signature checks | verified |
| `jwt/api_jwt.py` | code | `_merge_options()` disables dependent claim checks when signature verification is disabled unless callers override them | verified |
| `jwt/api_jwt.py` | code | `_validate_claims()` applies ordered, standards-oriented validation after payload decoding | verified |
| `docs/diagrams/validation-flow.md` | doc | The repo documents claim validation as a distinct processing stage | verified |
| `tests/test_api_jwt.py` | test | `strict_aud`, required-claim handling, and verification-option interactions are explicitly exercised | verified |

### Likely Alternatives

- Verify signatures only and leave all registered-claim validation to application code.
- Make most claim checks opt-in instead of enabled by default.

### Known Consequences

- The default decode path is safer and closer to standards expectations.
- Callers that need looser interoperability can still opt out selectively.
- Option interactions become part of the compatibility surface and need careful regression coverage.

### Open Questions

- The repo does not explain why `strict_aud` defaults to `False` while other validations default to enabled.
- Could not find a historical rationale for the current validation order beyond the present implementation and tests.

### Suggested Next Step

Review with maintainers. This looks ADR-worthy if the team wants a clear record of PyJWT's default verification posture.

## Rejected Candidate Ideas

- Sphinx as the documentation toolchain: important for contributor workflow, but not clearly an architecture decision that shapes token processing or library boundaries.
- ReadTheDocs and packaging metadata details: operationally useful, but not ADR-worthy on current evidence.
- Individual algorithm implementations and helper utilities: these are necessary implementation details, but the architectural decisions are the dependency model, security boundaries, and extension strategy around them.

## Existing ADR Coverage

- No existing `docs/adr/`, `adr/`, or `ADRs/` directory was found during this review.
- Existing flow docs in `docs/diagrams/` explain implementation behavior but do not record decision rationale, trade-offs, or decision status.

## Open Questions and Gaps

- Could not find repository-local rationale for why `cryptography` is optional rather than mandatory.
- Could not find a historical decision note for making explicit `algorithms` mandatory on verified decode paths.
- Could not determine whether `PyJWS` is intended as a long-term stable extension surface or a backwards-compatible public artifact.
- Could not verify why JWKS cache defaults were chosen or whether they came from production usage evidence.
- Could not find explicit rationale for `strict_aud` defaulting to `False` while other verification options default to enabled.

## Suggested Next ADRs

- CAND-003: Require caller-controlled algorithm allow-lists and reject unsafe key reuse.
- CAND-001: Separate JWS processing from JWT claim validation.
- CAND-002: Keep asymmetric cryptography optional via `pyjwt[crypto]`.
- CAND-005: Bundle a conservative JWKS client with layered caching.

## Agent Work Guide

Before generating ADRs from this file:

1. Re-check the listed evidence in `jwt/`, `docs/`, `tests/`, `pyproject.toml`, and `tox.ini`.
2. Prefer CAND-001 through CAND-003 for the first ADRs because they have the clearest impact and evidence.
3. Keep security rationale marked as inferred when the repo shows the behavior but does not record the original discussion.
4. Avoid generating ADRs for lower-priority candidates unless a maintainer marks them `ready`, `approved`, or `selected` and sets `Generate ADR: yes`.