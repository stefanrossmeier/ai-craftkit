# ADR-0003: Cache Remote JWKS In Memory and Refresh Once on a Key Miss

Decision Status: PROPOSED
Implementation Status: IMPLEMENTED
Decision Date: unknown
Doc Status: DRAFT
Last Updated: 2026-10-04
Updated By: agent
Source Mode: generate
Source Basis: code/config/tests

Related docs:
- `../archdoc/ARCHITECTURE.md` -- current JWKS-client boundary.
- `../archdoc/OPERATIONS.md` -- network and failure behavior.
- `README.md` -- ADR index.

## Decision

Use `PyJWKClient` to cache remotely retrieved JWKS data in process memory with a configurable lifespan, optionally cache individual signing keys, and perform one forced JWKS refresh after a signing-key `kid` miss before raising an error.

## Context

Remote JWKS endpoints provide verification keys outside the consuming process. The client must balance availability and request volume against timely discovery of a newly rotated key. Current caches are process-local and are not replaced when a fetch fails.

Evidence:
- `jwt/jwks_client.py` creates a `JWKSetCache` when `cache_jwk_set` is enabled and can wrap signing-key lookup in an LRU cache -- verified.
- `jwt/jwk_set_cache.py` stores a timestamped JWK set and expires it after the configured lifespan -- verified.
- `jwt/jwks_client.py` retries lookup with `refresh=True` once after an initial signing-key miss -- verified.
- `tests/test_jwks_client.py` covers caching, lifespan, key caching, refresh, and connection-failure behavior -- verified.

## Decision Drivers

- Reduce repeated remote JWKS requests while retaining bounded cache lifetime -- verified by `PyJWKClient` constructor defaults and `JWKSetCache` expiry behavior.
- Accommodate a newly available key without making every lookup force a network request -- verified by the one-refresh lookup path.
- Preserve a previously cached JWKS when a refresh fetch fails -- verified by `fetch_data()` behavior and focused tests.

## Options

### In-memory JWKS cache with one refresh on key miss

- **Status**: selected
- **Benefits**: Reduces requests during normal operation and attempts recovery when a key set changes.
- **Costs / risks**: Each process has independent cache state; a newly rotated key can require a refresh before it is usable.
- **Evidence that this option was historically considered**: none found.

### Fetch the JWKS for every signing-key lookup

- **Status**: reconstructed-for-review
- **Benefits**: Avoids cache staleness.
- **Costs / risks**: Increases dependency on endpoint availability and request volume.
- **Evidence that this option was historically considered**: none found.

### Use shared or durable cache storage

- **Status**: reconstructed-for-review
- **Benefits**: Could coordinate cache state across processes.
- **Costs / risks**: Adds external state and configuration to an in-process library.
- **Evidence that this option was historically considered**: none found.

## Rationale

**Original rationale**: not recovered from available evidence.

The current implementation uses only caller-process memory, exposes cache configuration in `PyJWKClient`, and retries once specifically after a key-selection miss.

## Consequences

### Positive

- Reuses a successful JWKS response until its configured expiry.
- Has a defined recovery path for key rotation or a stale key set.
- Does not add durable or shared-state dependencies to the library.

### Negative / Trade-offs

- Cache state is lost on process restart and differs between processes.
- A forced refresh still depends on remote endpoint availability.

### Constraints Created

- Cache and refresh changes must retain predictable behavior for callers configuring `cache_jwk_set`, `lifespan`, and `cache_keys`.
- Fetch failures must not discard a previously usable cached JWK set.

## Affected Architecture

| Area | Effect | Evidence | Status |
| --- | --- | --- | --- |
| `jwt/jwks_client.py` | Owns remote retrieval, cache configuration, key selection, and refresh. | `PyJWKClient` | verified |
| `jwt/jwk_set_cache.py` | Owns timestamped in-memory JWKS lifetime. | `JWKSetCache` | verified |
| Consumer runtime | Supplies endpoint, timeout, headers, and optional TLS context. | `PyJWKClient.__init__()` | verified |

## Verification / Implementation Evidence

| Evidence | What it establishes | Status |
| --- | --- | --- |
| `tests/test_jwks_client.py` | Cache lifetime, key cache, refresh-on-miss, and failure paths. | verified |
| `docs/archdoc/OPERATIONS.md` | Current network configuration and failure behavior. | verified |

## Open Questions and Gaps

| Question / gap | Why it matters | Next step |
| --- | --- | --- |
| Historical acceptance and rationale | Current code does not explain why these defaults or storage scope were chosen. | Recover issue, PR, or maintainer evidence before changing status. |
| Shared-cache support | A future distributed consumer may require different cache scope. | Prepare a decision document only when that requirement is concrete. |

## Relationships

- **Supersedes**: none
- **Superseded by**: none
- **Related ADRs**: ADR-0002