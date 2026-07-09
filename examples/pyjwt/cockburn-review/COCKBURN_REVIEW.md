# Cockburn Boundary Review

> Generated with `ai-craftkit` skill: `cockburn-review`  
> Source: `https://github.com/jpadilla/pyjwt.git` at commit `7144e4534c34810f4525dc4578a32addd8212cff`  
> Prompt: `Look into the pyjwt repo in this workspace and do the full cockburn-review`

Last Reviewed Scope: full repository  
Doc Status: DRAFT  
Last Review Update: 2026-07-09T20:33:12Z  
Updated By: agent  
Source Basis: README scan, docs scan, dependency scan, code scan, tests scan, commands run

## Purpose

This document reviews architectural weaknesses through the Cockburn-inspired questions:

- **Not my job**: Is a component doing work that appears to belong somewhere else?
- **No need to know**: Does a component know implementation details it should be insulated from?

The goal is to identify responsibility drift, knowledge leakage, boundary bypasses, and change-amplifying dependencies using concrete evidence from this repository.

## Evidence Legend

Use these labels for claims and findings:

- **verified**: directly confirmed from code, config, tests, local read-only command output, or explicit documentation.
- **inferred**: likely true based on naming, imports, structure, or partial evidence.
- **uncertain**: plausible but not sufficiently supported.
- **missing**: expected information was searched for but not found.

## Executive Summary

`pyjwt` is structurally small and mostly coherent as a library: `PyJWT` owns claim-oriented encode/decode behavior, `PyJWS` owns signing and signature verification, `jwt.algorithms` owns cryptographic implementations, and `PyJWK`/`PyJWKSet` translate JWK material into usable key objects. The main architectural pressure is not in the crypto core, but in extension and integration boundaries.

The strongest Cockburn theme is **both** responsibility drift and knowledge leakage at the edges. The package-level algorithm registration API mutates a process-global `PyJWS` singleton, which makes customization a shared mutable concern instead of an instance-local one. `PyJWKClient` also combines transport, caching, token header parsing, and key selection in one class, so changes to JWKS retrieval policy and JWT header handling are coupled together. A third, smaller issue is that `PyJWKSet` silently drops unusable keys, which keeps the happy path convenient but hides upstream data quality problems.

## Review Scope and Source Basis

| Area | What was inspected | Evidence | Status |
|---|---|---|---|
| Repository structure | tracked files, top-level package, docs, tests | `git rev-parse --show-toplevel`, `git status --short`, `git ls-files` | verified |
| Existing docs | README, docs index, API reference | `README.rst`, `docs/index.rst`, `docs/api.rst` | verified |
| Source modules | package exports, JWT/JWS/JWK/JWKS layers, algorithm layer, cache helper | `jwt/__init__.py`, `jwt/api_jwt.py`, `jwt/api_jws.py`, `jwt/api_jwk.py`, `jwt/jwks_client.py`, `jwt/algorithms.py`, `jwt/jwk_set_cache.py` | verified |
| Tests | API JWT, API JWS, JWK set, JWKS client tests | `tests/test_api_jwt.py`, `tests/test_api_jws.py`, `tests/test_api_jwk.py`, `tests/test_jwks_client.py` | verified |
| Runtime/config | packaging, dependency model, test matrix | `pyproject.toml`, `tox.ini` | verified |

Skipped or intentionally not inspected:

- `docs/c4-documentation/`: present as an untracked working-tree subtree, so it was not used as committed architectural evidence.
- Full test execution via `tox`: not run because the skill guidance recommends safe read-only inspection unless heavier verification is necessary.

## Inferred Architectural Map

The repository presents itself as a Python library rather than an application. The public boundary is the `jwt` package root plus generated docs. Within that boundary, the implementation appears layered around token operations, cryptographic algorithms, key translation, and one optional remote-key integration client.

| Architectural role | Apparent responsibility | Owns | Depends on | Used by | Evidence | Status |
|---|---|---|---|---|---|---|
| `jwt/__init__.py` package root | public API surface and convenience exports | root-level encode/decode helpers, exceptions, key classes, JWKS client | `api_jwt`, `api_jws`, `api_jwk`, `jwks_client` | library consumers and docs | `jwt/__init__.py:1-29`, `jwt/__init__.py:46-78`, `docs/api.rst:1-37` | verified |
| `jwt/api_jwt.py` | claim-aware JWT encode/decode orchestration | payload JSON conversion, registered claim validation, options merge rules | `api_jws`, exceptions, warnings | package root, tests | `jwt/api_jwt.py:35-88`, `jwt/api_jwt.py:90-170`, `jwt/api_jwt.py:174-421` | verified |
| `jwt/api_jws.py` | JWS encoding, header validation, signature verification, algorithm registry | allowed algorithms, signature verification workflow, global convenience singleton | `algorithms`, `api_jwk`, utils | `api_jwt`, package root, tests | `jwt/api_jws.py:33-57`, `jwt/api_jws.py:59-107`, `jwt/api_jws.py:219-446`, `jwt/api_jws.py:449-455` | verified |
| `jwt/algorithms.py` | cryptographic algorithm implementations and key conversion | algorithm classes, key preparation, JWK conversion | stdlib hashing plus optional `cryptography` | `api_jws`, `api_jwk`, tests | `jwt/algorithms.py:1-157` and class definitions in the remainder of the file | verified |
| `jwt/api_jwk.py` and `jwt/jwk_set_cache.py` | JWK/JWKS translation and in-memory set caching | JWK parsing, key material conversion, usable-key filtering, timestamped cache wrapper | `algorithms`, exceptions | `jwks_client`, tests | `jwt/api_jwk.py:19-167`, `jwt/jwk_set_cache.py:1-23` | verified |
| `jwt/jwks_client.py` | remote JWKS retrieval and signing-key lookup | URI validation, HTTP fetch, cache management, JWK set loading, `kid` matching | stdlib `urllib`, `api_jwk`, `api_jwt`, cache helper | package root, tests | `jwt/jwks_client.py:17-226`, `tests/test_jwks_client.py:181-375` | verified |

## Responsibility and Knowledge Boundaries

| Boundary | Expected responsibility split | Observed evidence | Boundary health | Status |
|---|---|---|---|---|
| Package root vs mutable algorithm registry | Consumers should be able to use convenience helpers without accidentally sharing mutable configuration state | root exports `register_algorithm` and `unregister_algorithm` from `api_jws`, while `api_jws` binds those helpers to a module-global `_jws_global_obj` | stressed | verified |
| Remote JWKS retrieval vs token parsing | JWKS retrieval should own transport/cache policy; JWT parsing should own token structure concerns | `PyJWKClient` imports `decode_complete` from `api_jwt` and uses it to extract `kid` before key lookup | stressed | verified |
| JWK set ingestion vs provider/error visibility | keyset parsing should decide whether partial failures are acceptable, but callers should be able to observe bad input when needed | `PyJWKSet` silently skips unusable keys unless all keys fail, and tests assert this filtered behavior | stressed | verified |

Boundary notes:

- The crypto core itself is relatively cleanly separated: `api_jws` depends on `algorithms`, and `api_jwt` composes `PyJWS` instead of duplicating signature logic.
- The most change-sensitive boundaries are the package convenience layer and the optional JWKS integration layer.

## Finding Summary

| # | Finding | Type | Severity | Confidence | Affected area | Main evidence |
|---|---|---|---|---|---|---|
| 1 | Package-level algorithm customization mutates global verification state | Both | High | High | `jwt/api_jws.py`, `jwt/__init__.py` | module-global `_jws_global_obj` plus root exports |
| 2 | `PyJWKClient` collapses transport, caching, token parsing, and key selection | Responsibility drift | Medium | High | `jwt/jwks_client.py` | one class owns HTTP fetch, cache policy, unverified decode, and `kid` matching |
| 3 | `PyJWKSet` silently drops unusable keys | Data ownership confusion | Medium | High | `jwt/api_jwk.py` | parsing loop filters exceptions and tests rely on partial acceptance |

## Boundary Findings

### Finding 1: Package-level algorithm customization mutates global verification state

**Type**: Both  
**Severity**: High  
**Confidence**: High  
**Affected area**: package root convenience API and JWS algorithm registry

#### Evidence

| Evidence | What it shows | Status |
|---|---|---|
| `jwt/api_jws.py:36-53` | `PyJWS` instances own a mutable algorithm map and mutable valid-algorithm set. | verified |
| `jwt/api_jws.py:59-74` | `register_algorithm()` mutates that in-memory registry. | verified |
| `jwt/api_jws.py:449-455` | module-level `encode`, `decode`, `decode_complete`, and registry helpers are bound to a singleton `_jws_global_obj`. | verified |
| `jwt/__init__.py:1-9` and `jwt/__init__.py:46-58` | the package root re-exports those singleton-backed helpers as the main public API. | verified |
| `tests/test_api_jws.py:51-85` | tests explicitly exercise algorithm registration and removal as mutable behavior on `PyJWS`. | verified |

#### Observed Behavior

The repository exposes two styles of JWS/JWT usage at once: instance-based use through `PyJWS`/`PyJWT`, and package-level convenience functions through `jwt.encode`, `jwt.decode`, `jwt.register_algorithm`, and `jwt.unregister_algorithm`. The package-level path is backed by a module-global `PyJWS` instance, so algorithm registration changes shared process state rather than a caller-local registry.

#### Cockburn Framing

- **Not my job**: the package convenience layer is not only exposing a stable façade; it is also acting as a mutable runtime registry owner.
- **No need to know**: callers using top-level convenience helpers need to understand that customization is global and shared, not local to one encoder/decoder instance.

#### Why This May Be an Architectural Weakness

This boundary couples extension policy to process-wide mutable state. A consumer adding or removing an algorithm for one integration scenario changes the behavior of all top-level calls in the same interpreter. That raises risk for test isolation, embedded-library use, and multi-tenant applications that want different allow-lists or custom algorithms without sharing side effects.

#### Future Change Likely to Become Harder

Adding tenant-specific algorithm registries, per-request allow-lists, or temporary custom algorithms for one subsystem will be harder because the current public mutation path is global. Changes would have to preserve backward compatibility for singleton-backed helpers while introducing a safer ownership model.

#### Suggested Architectural Move

Keep the convenience API, but move customization behind an explicit registry-owning object. For example, keep `jwt.encode` and `jwt.decode` as singleton convenience helpers, but stop exposing package-root mutation hooks for the singleton and prefer instance- or registry-scoped registration for advanced use cases.

#### What Not to Over-Fix

Do not remove the convenience encode/decode façade. The problem is shared mutable registration state, not the existence of easy entry points.

### Finding 2: `PyJWKClient` collapses transport, caching, token parsing, and key selection

**Type**: Responsibility drift  
**Severity**: Medium  
**Confidence**: High  
**Affected area**: remote JWKS integration path

#### Evidence

| Evidence | What it shows | Status |
|---|---|---|
| `jwt/jwks_client.py:3-14` | the client imports stdlib HTTP machinery, JWK parsing classes, JWT decode logic, and the cache helper in one module. | verified |
| `jwt/jwks_client.py:17-104` | constructor configuration spans URI validation, key-cache policy, set-cache policy, headers, timeout, and SSL context. | verified |
| `jwt/jwks_client.py:106-158` | the same class owns HTTP fetch, JSON loading, cache updates, and conversion into `PyJWKSet`. | verified |
| `jwt/jwks_client.py:160-226` | the class also owns signing-key filtering, `kid` matching, refresh retry logic, and unverified JWT header parsing via `decode_complete(..., verify_signature=False)`. | verified |
| `tests/test_jwks_client.py:181-237` and `tests/test_jwks_client.py:291-375` | tests for the class cover cache behavior, token-driven key lookup, refresh policy, failure preservation, timeout handling, SSL handling, and URI-scheme security in one surface. | verified |

#### Observed Behavior

`PyJWKClient` is both an adapter to a remote JWKS endpoint and an orchestrator for several policy decisions: when to refresh, how to cache, how to read a token header without verification, how to filter usable signing keys, and how to react to failures.

#### Cockburn Framing

- **Not my job**: the remote-key client is doing more than transport and key retrieval; it also owns JWT-header extraction and retry/cache policy.
- **No need to know**: the client needs direct knowledge of JWT decode semantics even though its main advertised responsibility is fetching signing keys from JWKS.

#### Why This May Be an Architectural Weakness

This concentrates multiple change axes in one class. Transport changes, cache-policy changes, JWT-header parsing changes, and signing-key selection changes all accumulate in the same surface. The result is a useful API for consumers, but it also means the integration boundary is harder to evolve in smaller pieces.

#### Future Change Likely to Become Harder

Supporting alternate key discovery flows such as pre-parsed headers, custom `kid` extraction, async transports, or richer cache invalidation would likely require editing the same class and tests together, rather than swapping one narrow dependency.

#### Suggested Architectural Move

Split the orchestration into narrower collaborators without changing the public `PyJWKClient` entry point yet. A small first step would be to isolate token-header extraction behind a helper that returns `kid`, and keep transport/cache behavior behind a separate fetch-or-load path.

#### What Not to Over-Fix

Do not break the current synchronous, batteries-included API unless there is a concrete use case. The issue is internal responsibility concentration, not consumer ergonomics.

### Finding 3: `PyJWKSet` silently drops unusable keys

**Type**: Data ownership confusion  
**Severity**: Medium  
**Confidence**: High  
**Affected area**: JWK set ingestion and provider-data visibility

#### Evidence

| Evidence | What it shows | Status |
|---|---|---|
| `jwt/api_jwk.py:135-157` | `PyJWKSet.__init__` catches `PyJWTError`, re-raises only `MissingCryptographyError`, and otherwise skips unusable keys. | verified |
| `tests/test_api_jwk.py:309-324` | tests confirm that a mixed-validity keyset is accepted with bad keys silently removed, while an all-invalid keyset raises only after filtering everything out. | verified |
| `jwt/jwks_client.py:160-183` | downstream signing-key selection operates on the already-filtered `jwk_set.keys`, so callers do not see which keys were dropped. | verified |

#### Observed Behavior

The JWK set boundary chooses partial acceptance by default. If some keys are malformed, unsupported, or otherwise unusable, they disappear from the set without being surfaced to the caller unless every key fails.

#### Cockburn Framing

- **Not my job**: the parsing layer is implicitly making a provider-quality and observability decision, not just translating data structures.
- **No need to know**: downstream callers receive a clean list of usable keys but lose knowledge of which upstream keys were rejected and why.

#### Why This May Be an Architectural Weakness

This makes the happy path resilient, but it also hides boundary failures. When an identity provider begins serving malformed or unsupported keys, the library consumer gets less visibility than the parser has. That can delay debugging and make provider compatibility problems harder to diagnose, especially when only one of several keys is silently dropped.

#### Future Change Likely to Become Harder

Adding diagnostics, audit logging, provider-compatibility reporting, or stricter fail-fast modes will be harder because the current behavior discards rejection details at parse time.

#### Suggested Architectural Move

Preserve the default tolerant behavior if backward compatibility matters, but carry rejected-key metadata alongside the usable set or add an opt-in strict mode that surfaces rejected keys and reasons.

#### What Not to Over-Fix

Do not force all mixed-validity JWKS responses to fail immediately by default. The compatibility trade-off is valuable; the missing piece is observability or opt-in strictness.

## Change-Stress Scenarios

### Scenario: support per-tenant custom algorithms and stricter JWKS diagnostics

| Step likely to change | Current evidence | Architectural concern | Status |
|---|---|---|---|
| isolate algorithm registration per consumer | `jwt/api_jws.py:59-74`, `jwt/api_jws.py:449-455`, `jwt/__init__.py:46-58` | current public mutation path targets a singleton, so per-tenant customization is not naturally isolated | verified |
| expose better JWKS rejection reporting | `jwt/api_jwk.py:145-157`, `tests/test_api_jwk.py:309-324` | rejected keys are discarded early, so richer diagnostics need a new data path | verified |
| customize remote key lookup without full token decode coupling | `jwt/jwks_client.py:213-226` | header parsing is wired directly into the client, so alternate lookup strategies require editing the same integration class | verified |

Assessment:

This change looks moderately change-amplifying. None of the issues demand a rewrite, but each one pushes policy and integration concerns through shared surfaces that are broader than they need to be.

## Architectural Hotspots

| Hotspot | Why it matters | Evidence | Risk | Status |
|---|---|---|---|---|
| `jwt/api_jws.py` | owns both core JWS behavior and the mutable global registry used by package-level helpers | `jwt/api_jws.py:33-57`, `jwt/api_jws.py:59-107`, `jwt/api_jws.py:449-455` | extension changes can affect global behavior | verified |
| `jwt/jwks_client.py` | optional integration boundary where transport, cache, and JWT knowledge meet | `jwt/jwks_client.py:17-226`, `tests/test_jwks_client.py:181-375` | future integration features accumulate in one class | verified |
| `jwt/api_jwk.py` | owns tolerant parsing policy that hides malformed keys from downstream consumers | `jwt/api_jwk.py:19-82`, `jwt/api_jwk.py:135-157`, `tests/test_api_jwk.py:309-324` | upstream incompatibilities can be obscured | verified |

## Evidence Register

| Claim | Evidence | Status |
|---|---|---|
| The public package surface mixes instance APIs with singleton-backed convenience functions. | `jwt/__init__.py:1-9`, `jwt/__init__.py:46-58`, `jwt/api_jws.py:449-455` | verified |
| `PyJWKClient` owns remote fetch, cache policy, token-header extraction, and key selection. | `jwt/jwks_client.py:17-226`, `tests/test_jwks_client.py:181-375` | verified |
| `PyJWKSet` filters out unusable keys instead of surfacing all failures to callers. | `jwt/api_jwk.py:145-157`, `tests/test_api_jwk.py:309-324` | verified |
| The core library boundary between claim validation and signature verification is otherwise explicit. | `jwt/api_jwt.py:35-88`, `jwt/api_jwt.py:174-421`, `jwt/api_jws.py:219-446` | verified |

## Recommendations

### Fix Now

1. Move algorithm-registration ownership away from the package-root singleton path.  
   Evidence: Finding 1; `jwt/api_jws.py:59-74`, `jwt/api_jws.py:449-455`, `jwt/__init__.py:46-58`  
   Expected benefit: customization becomes local and predictable instead of process-global.

2. Add an internal seam inside `PyJWKClient` between token-header extraction and JWKS retrieval/caching.  
   Evidence: Finding 2; `jwt/jwks_client.py:106-226`  
   Expected benefit: future transport, cache, and lookup changes become easier to localize.

### Watch

1. Add an opt-in strict or diagnostic mode for `PyJWKSet` rejection handling.  
   Evidence: Finding 3; `jwt/api_jwk.py:145-157`, `tests/test_api_jwk.py:309-324`  
   Reason to watch instead of fix now: the current tolerant behavior is useful for interoperability, so observability is more urgent than changing defaults.

### Accept as Trade-Off

1. Keep the current broad package root API for encode/decode ergonomics.  
   Evidence: `README.rst:24-33`, `docs/api.rst:1-37`, `jwt/__init__.py:46-58`  
   Reason: the convenience API is a core product feature; the architectural issue is the mutable global extension hook, not the existence of top-level helpers.

## Known Unknowns

- The untracked `docs/c4-documentation/` subtree may contain additional local architectural notes, but it was intentionally excluded because it is not part of the committed repository state reviewed here.
- Full behavioral verification through `tox` was not run. Confirming whether any boundary changes preserve the complete supported interpreter and optional-crypto matrix would require running `tox`.

## Agent Work Guide

Before changing code near the findings above:

1. Read the evidence paths for the relevant finding.
2. Decide whether the change is package-root API work, crypto-core work, or optional JWKS integration work.
3. Avoid widening shared mutable state; prefer instance-local or collaborator-local ownership.
4. Preserve the library’s consumer ergonomics while narrowing internal responsibility boundaries.
5. Update this review if algorithm registration, JWKS retrieval, or JWK-set parsing behavior materially changes.

Useful searches:

```bash
rg "register_algorithm|unregister_algorithm|_jws_global_obj"
rg "get_signing_key_from_jwt|fetch_data|get_jwk_set|match_kid"
rg "skip unusable keys|MissingCryptographyError|PyJWKSet"
```