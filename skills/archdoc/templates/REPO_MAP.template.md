# Repository Map

Review Scope: [full | targeted area | delta]
Doc Status: [MAINTAINED | DRAFT | NEEDS REVIEW]
Last Updated: [YYYY-MM-DDTHH:MM:SSZ]
Updated By: [human | agent | human+agent]
Source Revision: [git SHA | unavailable]
Source Basis: [README, manifests, source tree, tests, commands, other]

Related docs:
- `ARCHITECTURE.md` — static architecture, boundaries, dependencies, and data ownership.
- `API_SURFACE.md` — detailed public and integration-relevant contracts, when present.
- `OPERATIONS.md` — runtime, verification, deployment, and failure handling, when present.
- `../adr/` — architectural decisions and rationale, when present.

## Purpose

This document is an orientation map for the repository. It should help a reader find the important code, commands, tests, and configuration without duplicating architecture or contract detail from the related documents.

## Repository Summary

- **Purpose**: [short description]
- **Primary technologies**: [languages/frameworks]
- **Repository type**: [service | app | library | CLI | worker | monorepo | mixed]
- **Primary entry points**: [`path`, `path`]
- **Build/package system**: [tool]
- **Main test command**: `[command]`
- **Main run command**: `[command or not applicable]`

## Root Structure

```text
[repo-root]/
├── [path]    # [why it matters]
├── [path]    # [why it matters]
└── [path]    # [why it matters]
```

Keep this map to important top-level paths; do not mirror the whole repository tree.

## Important Areas

| Path | Responsibility | Important files / symbols | Status |
|---|---|---|---|
| `[path]` | [responsibility] | [`path` / symbol] | [verified/inferred] |
| `[path]` | [responsibility] | [`path` / symbol] | [verified/inferred] |

## Entry Points

| Entry point | Type | Purpose | Leads to | Evidence | Status |
|---|---|---|---|---|---|
| [`path` / symbol] | [server/CLI/library/worker/etc.] | [purpose] | [module] | [`path`] | [verified/inferred] |

## Build, Test, and Verification Commands

| Command | Purpose | Defined by | Notes | Status |
|---|---|---|---|---|
| `[command]` | [build/test/lint/run/etc.] | [`path`] | [safe notes] | [verified/inferred] |

Only include commands supported by repository evidence. Do not invent conventional commands.

## Important Files

| File | Why it matters | Read when | Status |
|---|---|---|---|
| [`path`] | [reason] | [situation] | [verified/inferred] |

## Tests

| Test area | Path / command | What it verifies | Known gap | Status |
|---|---|---|---|---|
| [unit/integration/e2e/etc.] | [`path` / command] | [coverage] | [gap] | [verified/inferred/missing] |

## Configuration and Generated Paths

| Path / name | Type | Purpose | Notes | Status |
|---|---|---|---|---|
| [`path` / `ENV_NAME`] | [config/generated/cache/artifact] | [purpose] | [no secret values] | [verified/inferred] |

## Observed Repository Conventions

These are descriptive observations, **not engineering standards**.

| Area | Observed pattern | Evidence | Confidence |
|---|---|---|---|
| [naming/testing/error handling/etc.] | [pattern] | [`path`, `path`] | [verified/inferred] |

Omit this section when patterns are inconsistent or not useful. Never convert an observed pattern into a `MUST`/`SHOULD` rule unless an explicit human-owned standard says so.

## Recommended Reading Order

1. [`path`] — [why]
2. [`path`] — [why]
3. [`path`] — [why]

Keep this to the smallest useful sequence for understanding the repository.

## Open Questions and Gaps

| Question / gap | Why it matters | Evidence checked | Suggested next step |
|---|---|---|---|
| [question] | [reason] | [`path` / command] | [next step] |
