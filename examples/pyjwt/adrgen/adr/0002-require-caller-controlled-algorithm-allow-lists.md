# ADR-0002: Require Caller-Controlled Algorithm Allow-Lists for Signature Verification

Decision Status: PROPOSED
Implementation Status: IMPLEMENTED
Decision Date: unknown
Doc Status: DRAFT
Last Updated: 2026-10-04
Updated By: agent
Source Mode: generate
Source Basis: code/config/tests

Related docs:
- `../archdoc/ARCHITECTURE.md` -- current security boundary.
- `../archdoc/API_SURFACE.md` -- public verification contract.
- `README.md` -- ADR index.

## Decision

When signature verification is enabled, require callers to supply an allowed `algorithms` list unless the verification key is a `PyJWK`; do not select verification algorithms from attacker-controlled token header data.

## Context

JWT headers declare an algorithm, but headers arrive with the token and cannot safely determine the set of algorithms trusted for verification. The current decode path rejects a missing algorithm allow-list except when a `PyJWK` supplies algorithm information.

Evidence:
- `jwt/api_jws.py` raises `DecodeError` when verification is enabled, the key is not a `PyJWK`, and `algorithms` is absent -- verified.
- `docs/usage.rst` warns callers not to compute the allowed algorithm list from the token's `alg` header -- verified.
- `tests/test_api_jwt.py` exercises decode with explicit `algorithms` input and `PyJWK` algorithm selection -- verified.

## Decision Drivers

- Keep the signature-verification trust policy under caller control -- verified by `jwt/api_jws.py` and `docs/usage.rst`.
- Permit key metadata to provide the algorithm only for the dedicated `PyJWK` key abstraction -- verified by `jwt/api_jwt.py` and tests.

## Options

### Caller-controlled allow-list with `PyJWK` exception

- **Status**: selected
- **Benefits**: Keeps the verification algorithm policy independent of untrusted token metadata while supporting typed JWK key material.
- **Costs / risks**: Callers using ordinary keys must supply an algorithm list.
- **Evidence that this option was historically considered**: none found.

### Derive the allowed algorithm from the token header

- **Status**: reconstructed-for-review
- **Benefits**: Reduces explicit caller configuration.
- **Costs / risks**: Lets token-controlled metadata determine an important verification input.
- **Evidence that this option was historically considered**: none found.

## Rationale

**Original rationale**: not recovered from available evidence.

Current code and documentation treat the algorithm allow-list as security-sensitive caller input rather than token data.

## Consequences

### Positive

- The verification policy remains outside the token's control.
- `PyJWK` can carry key-associated algorithm metadata through a specific API path.

### Negative / Trade-offs

- Normal decode callers must know and provide compatible algorithms.

### Constraints Created

- New decode APIs must preserve the explicit algorithm-policy boundary when signature verification is enabled.

## Affected Architecture

| Area | Effect | Evidence | Status |
| --- | --- | --- | --- |
| `jwt/api_jws.py` | Enforces algorithm input during signature verification. | `PyJWS.decode_complete()` | verified |
| `jwt/api_jwt.py` | Passes decode configuration through to JWS verification. | `PyJWT.decode_complete()` | verified |
| User documentation | Advises callers against deriving algorithms from token headers. | `docs/usage.rst` | verified |

## Verification / Implementation Evidence

| Evidence | What it establishes | Status |
| --- | --- | --- |
| `tests/test_api_jwt.py` | Decoding works with an explicit algorithm list and JWK keys. | verified |
| `tests/test_api_jws.py` | JWS decode enforces algorithm requirements. | verified |

## Open Questions and Gaps

| Question / gap | Why it matters | Next step |
| --- | --- | --- |
| Historical acceptance and rationale | Code and documentation do not establish decision history. | Recover security review, issue, PR, or maintainer evidence before changing status. |

## Relationships

- **Supersedes**: none
- **Superseded by**: none
- **Related ADRs**: ADR-0001, ADR-0003