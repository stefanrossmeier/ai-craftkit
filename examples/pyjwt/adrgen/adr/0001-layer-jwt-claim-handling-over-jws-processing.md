# ADR-0001: Layer JWT Claim Handling Over JWS Processing

Decision Status: PROPOSED
Implementation Status: IMPLEMENTED
Decision Date: unknown
Doc Status: DRAFT
Last Updated: 2026-10-04
Updated By: agent
Source Mode: generate
Source Basis: code/config/tests

Related docs:
- `../archdoc/ARCHITECTURE.md` -- current component boundaries.
- `../archdoc/API_SURFACE.md` -- public Python contracts.
- `README.md` -- ADR index.

## Decision

Maintain separate processing layers: `PyJWS` owns compact JWS parsing, protected-header handling, algorithm selection, and signing or signature verification; `PyJWT` owns JSON-object payload processing and registered-claim validation while delegating signature work to `PyJWS`.

## Context

PyJWT exposes JWT encode/decode APIs as well as the lower-level `PyJWS` API. The current implementation composes these responsibilities rather than combining them in a single processing component.

Evidence:
- `jwt/api_jwt.py` constructs `PyJWS`, delegates `decode_complete()` to it, then decodes the payload and calls `_validate_claims()` -- verified.
- `jwt/api_jws.py` owns compact serialization and signature behavior -- verified.
- `docs/archdoc/ARCHITECTURE.md` describes these component boundaries as current-system evidence -- verified.

## Decision Drivers

- Preserve separately consumable JWT and JWS public APIs -- verified by `jwt/__init__.py` and `docs/archdoc/API_SURFACE.md`.
- Keep JWT registered-claim validation separate from signature processing -- verified by `jwt/api_jwt.py`.

## Options

### Separate JWT and JWS layers

- **Status**: selected
- **Benefits**: Keeps JWT claim logic and reusable JWS signing/verification responsibilities distinct.
- **Costs / risks**: Delegation boundaries require options and decoded data to be passed between components.
- **Evidence that this option was historically considered**: none found.

### Unified JWT and signature processor

- **Status**: reconstructed-for-review
- **Benefits**: Could reduce delegation between public APIs.
- **Costs / risks**: Would conflate JWS and JWT responsibilities and change the existing lower-level API boundary.
- **Evidence that this option was historically considered**: none found.

## Rationale

**Original rationale**: not recovered from available evidence.

The implemented boundary currently supports both a high-level JWT API and a lower-level JWS API without making claim validation part of the JWS component.

## Consequences

### Positive

- Claim-validation changes can remain in `PyJWT` without changing `PyJWS` signature behavior.
- JWS consumers retain a lower-level compact-signature interface.

### Negative / Trade-offs

- Behavior spanning signatures and claims must preserve the handoff between two components.

### Constraints Created

- New JWT claim behavior belongs in the JWT layer unless it changes JWS semantics.
- Signature-format and algorithm behavior belongs in the JWS layer.

## Affected Architecture

| Area | Effect | Evidence | Status |
| --- | --- | --- | --- |
| `jwt/api_jwt.py` | Owns payload and claim processing; delegates signatures. | `PyJWT.decode_complete()` | verified |
| `jwt/api_jws.py` | Owns compact JWS parsing and signature verification. | `PyJWS.decode_complete()` | verified |
| Public API | Exposes both `PyJWT` and `PyJWS`. | `jwt/__init__.py` | verified |

## Verification / Implementation Evidence

| Evidence | What it establishes | Status |
| --- | --- | --- |
| `tests/test_api_jwt.py` | JWT encode/decode, payload, and claim behavior. | verified |
| `tests/test_api_jws.py` | Compact JWS and signature behavior. | verified |

## Open Questions and Gaps

| Question / gap | Why it matters | Next step |
| --- | --- | --- |
| Historical acceptance and rationale | Code cannot establish what was decided or why. | Recover issue, PR, or maintainer evidence before changing status. |

## Relationships

- **Supersedes**: none
- **Superseded by**: none
- **Related ADRs**: ADR-0002