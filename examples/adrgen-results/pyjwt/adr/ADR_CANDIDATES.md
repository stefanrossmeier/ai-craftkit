# ADR Candidates

Last Reviewed Scope: full review
Doc Status: DRAFT
Last ADR Candidate Update: 2026-07-06T14:52:12Z
Updated By: agent
Source Basis: README scan; code scan; tests scan; workflow scan; git history

## Purpose

This document records architectural decisions that appear to exist in the PyJWT repository but are not yet captured as ADRs.

The goal is to give maintainers a reviewable funnel before generating final ADR files.

## Evidence Legend

- `verified`: directly confirmed from repository files, code, tests, or workflow configuration.
- `inferred`: likely true from recurring structure or partial supporting evidence.
- `uncertain`: plausible but not strongly supported enough to treat as established.
- `missing`: expected rationale or history was searched for but not found.

## Candidate Summary

| ID | Title | Confidence | Impact | Affected area | Generation readiness | Notes |
|---|---|---|---|---|---|---|
| CAND-001 | Expose PyJWT through a single `jwt` package facade | high | high | public API, package structure | not ready | Strong implementation evidence; original rationale missing |
| CAND-002 | Keep asymmetric crypto support optional behind the `crypto` extra | high | high | dependency model, algorithm support | not ready | Strong packaging and code evidence |
| CAND-003 | Provide built-in JWKS retrieval with restricted schemes and in-memory caching | high | high | remote key integration, security boundary | not ready | Strong code and test evidence |
| CAND-004 | Use tox-driven multi-environment validation and executable docs as a release gate | high | medium | quality model, release process | not ready | Strong workflow and tooling evidence |

## Candidates

## CAND-001: Expose PyJWT through a single `jwt` package facade

Candidate Status: new
Generate ADR: undecided
Suggested ADR: docs/adr/0001-expose-pyjwt-through-a-single-package-facade.md
Generated ADR: none
Decision Status: unknown
Confidence: high
Impact: high
Affected area: public API, package structure, extension surface
Source Mode: discover

### Why this looks like an architectural decision

PyJWT presents one stable import path and one consolidated public namespace rather than pushing users toward direct imports from internal modules. That shapes compatibility expectations, extension points, and how internal refactors can happen without breaking callers.

### Evidence

| Evidence | Type | Supports | Status |
|---|---|---|---|
| `README.rst` | doc | Public usage is documented as `import jwt` with `jwt.encode` and `jwt.decode` | verified |
| `jwt/__init__.py` | code | The package re-exports the main classes, helper functions, warnings, and exception types from one module | verified |
| `jwt/api_jwt.py` and `jwt/api_jws.py` | code | Module-level helper functions are backed by global `PyJWT` and `PyJWS` instances rather than requiring callers to construct objects | verified |

### Likely Alternatives

- Require callers to instantiate `PyJWT` or `PyJWS` explicitly for all operations.
- Expose narrower submodule APIs and avoid a broad top-level re-export surface.

### Known Consequences

- Adoption stays simple because most users only need one import path.
- Global helper instances and algorithm registration become process-wide behavior, which constrains future refactors.

### Open Questions

- Could not determine why the maintainers preferred global helper wrappers over an instance-only API.
- Could not confirm whether the current top-level export breadth is considered a long-term compatibility guarantee or just accumulated convenience.

### Suggested Next Step

Review candidate. This looks ADR-worthy if maintainers want the public API stability contract documented explicitly.

## CAND-002: Keep asymmetric crypto support optional behind the `crypto` extra

Candidate Status: new
Generate ADR: undecided
Suggested ADR: docs/adr/0002-keep-asymmetric-crypto-support-optional.md
Generated ADR: none
Decision Status: unknown
Confidence: high
Impact: high
Affected area: dependency model, algorithm support, compatibility matrix
Source Mode: discover

### Why this looks like an architectural decision

PyJWT supports both a minimal install and a richer asymmetric-crypto mode. That affects packaging, test matrix breadth, algorithm availability, and how downstream users reason about supported features.

### Evidence

| Evidence | Type | Supports | Status |
|---|---|---|---|
| `pyproject.toml` | config | `cryptography` is provided as an optional `crypto` extra rather than a mandatory dependency | verified |
| `jwt/algorithms.py` | code | The algorithm registry exposes only `none` and HMAC algorithms without `cryptography`, and adds RSA, EC, PSS, and EdDSA when the dependency is available | verified |
| `tox.ini` | config | The test matrix explicitly distinguishes `-crypto` and `-nocrypto` environments | verified |
| `.github/workflows/main.yml` | workflow | CI verifies installation both with no extras and with the `crypto` extra | verified |

### Likely Alternatives

- Require `cryptography` for all installs.
- Split asymmetric support into a separate package or plugin layer.

### Known Consequences

- Base installs stay smaller and simpler for HMAC-only use cases.
- Maintainers must preserve and test two meaningful runtime modes with different algorithm availability.

### Open Questions

- Could not determine the original maintainers' cost, packaging, or platform reasons for keeping `cryptography` optional.
- Could not confirm whether the optional dependency model is expected to stay long-term or mainly preserves backward compatibility.

### Suggested Next Step

Review candidate. This is one of the strongest inputs for a future ADR because it affects packaging, testing, and user-visible capability boundaries.

## CAND-003: Provide built-in JWKS retrieval with restricted schemes and in-memory caching

Candidate Status: new
Generate ADR: undecided
Suggested ADR: docs/adr/0003-provide-built-in-jwks-retrieval-with-caching.md
Generated ADR: none
Decision Status: unknown
Confidence: high
Impact: high
Affected area: remote key integration, security boundary, runtime behavior
Source Mode: discover

### Why this looks like an architectural decision

PyJWT includes a first-party networked integration for remote signing-key lookup instead of leaving JWKS retrieval entirely to callers. That creates a security boundary, a cache policy, and an opinionated runtime path inside an otherwise local library.

### Evidence

| Evidence | Type | Supports | Status |
|---|---|---|---|
| `jwt/jwks_client.py` | code | The repository ships a dedicated `PyJWKClient` for JWKS fetching, key selection, and cache management | verified |
| `jwt/jwks_client.py` | code | Non-HTTP(S) URI schemes are rejected eagerly, limiting dangerous fetch targets such as `file://` | verified |
| `jwt/jwks_client.py` and `jwt/jwk_set_cache.py` | code | The client uses a TTL JWK-set cache and an optional LRU per-key cache | verified |
| `tests/test_jwks_client.py` | test | Caching behavior, filtering of signing keys, fetch failures, and JWT-to-JWK lookup are tested explicitly | verified |

### Likely Alternatives

- Leave all remote JWKS retrieval outside the library and accept only caller-supplied keys.
- Provide a JWKS client without built-in caching.
- Permit broader URI schemes and leave scheme validation entirely to callers.

### Known Consequences

- Callers get a supported remote-verification path without building their own JWKS lookup layer.
- The library now owns network behavior, cache semantics, and part of the security posture for remote key discovery.

### Open Questions

- Could not determine why the chosen cache defaults are `cache_jwk_set=True`, `cache_keys=False`, and `lifespan=300` from repository history alone.
- Could not find a documented retry or backoff policy beyond the current single-request behavior.

### Suggested Next Step

Review candidate. This is ADR-worthy if maintainers want the built-in remote verification model and its security constraints documented explicitly.

## CAND-004: Use tox-driven multi-environment validation and executable docs as a release gate

Candidate Status: new
Generate ADR: undecided
Suggested ADR: docs/adr/0004-use-tox-driven-multi-environment-validation-and-executable-docs.md
Generated ADR: none
Decision Status: unknown
Confidence: high
Impact: medium
Affected area: quality model, compatibility policy, release process
Source Mode: discover

### Why this looks like an architectural decision

The repository treats validation breadth as part of the package contract: multiple Python runtimes, optional dependency modes, typing, docs, doctests, and packaging checks all participate in the supported maintenance model. That is more than routine CI plumbing because it constrains how code, docs, and releases evolve.

### Evidence

| Evidence | Type | Supports | Status |
|---|---|---|---|
| `tox.ini` | config | Tox defines lint, typing, multi-version test envs, docs, package-description checks, and coverage reporting | verified |
| `tox.ini` | config | The docs env builds Sphinx output, runs Sphinx doctest, and runs Python doctest against `README.rst` and `docs/usage.rst` | verified |
| `.github/workflows/main.yml` | workflow | CI runs tox across CPython 3.9-3.14, PyPy, and multiple operating systems, plus install verification with and without extras | verified |
| `.readthedocs.yaml` | config | Hosted docs install `.[crypto]` with the docs group and fail on warnings | verified |
| `.github/workflows/pypi-package.yml` | workflow | Build verification and publishing are gated through dedicated package jobs rather than ad hoc release steps | verified |

### Likely Alternatives

- Narrow the supported matrix to fewer Python versions or one operating system.
- Treat docs as advisory and avoid blocking release flows on docs or doctest failures.
- Use direct CI commands without tox as the maintainer contract surface.

### Known Consequences

- Compatibility confidence stays high across runtimes and packaging modes.
- Contributor and maintainer overhead rises because docs, typing, packaging, and runtime support all remain first-class obligations.

### Open Questions

- Could not find a single maintainer-authored policy document explaining which parts of the matrix are essential versus historical accumulation.
- Could not determine whether the current breadth is expected to shrink, stay stable, or expand with future Python releases.

### Suggested Next Step

Review candidate. Generate an ADR only if maintainers want the release and validation model treated as a deliberate long-term policy rather than just current tooling.

## Rejected Candidate Ideas

- Use reStructuredText for user-facing docs: important repo convention, but the current evidence does not show a broader architectural consequence beyond documentation format.
- Use Ruff and pre-commit for formatting and hygiene: useful contributor tooling, but lower architectural impact than the package facade, dependency model, JWKS integration, and release-validation model.
- Support Python 3.9 and newer: significant compatibility policy, but it is already embedded inside CAND-004's broader validation and release model rather than standing alone as a clearer ADR.

## Existing ADR Coverage

- No existing `docs/adr/` directory or ADR files were present before this discovery pass.
- No repository-authored ADR numbering or status conventions existed before this document.

## Open Questions And Gaps

- Could not find human-authored architecture or decision documents in the repository; candidate rationale is derived directly from code, tests, packaging config, and workflows.
- Could not determine original maintainer intent for several choices from git history alone, so the strongest candidates still have missing historical rationale even when implementation evidence is strong.

## Suggested Next ADRs

1. CAND-002: optional crypto support, because it shapes dependency policy, runtime capability, and the test matrix.
2. CAND-003: built-in JWKS retrieval, because it creates a security-sensitive integration boundary and runtime cache policy.
3. CAND-001: single package facade, if API stability and global helper behavior are important to document explicitly.

## Agent Work Guide

Before generating ADRs from this file:

1. Review each candidate's `Open Questions` and decide whether the missing rationale blocks ADR generation.
2. Mark candidates with `Candidate Status: ready` or `approved` and `Generate ADR: yes` only when the team wants an ADR draft.
3. Re-check the cited code paths if the repository changes before generation.
4. Preserve `unknown` or inferred rationale instead of promoting it to verified history.

Rules:

- Do not generate ADRs from all candidates by default.
- Do not treat these candidates as accepted decisions without human review.
- If a future ADR duplicates an existing one, update this file rather than creating parallel decision records.