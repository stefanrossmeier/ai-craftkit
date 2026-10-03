# Architecture

Review Scope: [full | targeted area | delta]
Doc Status: [MAINTAINED | DRAFT | NEEDS REVIEW]
Last Updated: [YYYY-MM-DDTHH:MM:SSZ]
Updated By: [human | agent | human+agent]
Source Revision: [git SHA | unavailable]
Source Basis: [source scan, manifests, tests, existing docs, other]

Related docs:
- `REPO_MAP.md` — repository orientation and important paths.
- `API_SURFACE.md` — detailed contracts, when present.
- `OPERATIONS.md` — runtime and operational behavior, when present.
- `../adr/` — architectural decisions and rationale, when present.

## Purpose

Describe the repository's static architecture: major parts, responsibilities, boundaries, dependency direction, state/data ownership, and external relationships.

Detailed interface inventories belong in `API_SURFACE.md`. Commands, deployment, failure recovery, and runtime verification belong in `OPERATIONS.md`.

## Architecture Summary

[Concise repository-specific explanation of the architecture and its main organizing idea. Avoid generic claims such as “modular” unless repository evidence makes them meaningful.]

## System / Repository Boundary

- **Inside this repository**: [major responsibilities]
- **Outside dependencies/systems**: [important external responsibilities]
- **Primary architectural boundary**: [what this code owns vs. does not own]

## Major Components

| Component / module | Responsibility | Main paths | Depends on | Owned state/data | Status |
|---|---|---|---|---|---|
| [name] | [responsibility] | [`path`] | [dependencies] | [state/data] | [verified/inferred] |

## Dependency Direction

[Describe important dependency rules that are evidenced by imports, package/module structure, configuration, or tests. Do not infer intended layering from names alone.]

```mermaid
flowchart LR
    A[Component A] --> B[Component B]
```

Remove the diagram if prose/table form is clearer or the relationships are not sufficiently evidenced.

## External Systems and Dependencies

| External system / dependency | Used by | Purpose | Boundary / protocol | Evidence | Status |
|---|---|---|---|---|---|
| [name] | [module] | [purpose] | [HTTP/DB/library/queue/etc.] | [`path`] | [verified/inferred] |

Focus on architecture-relevant dependencies, not every package in a lockfile.

## Data and State Ownership

| Data / state | Owner | Readers | Writers | Storage / transport | Evidence | Status |
|---|---|---|---|---|---|---|
| [entity/state] | [module] | [modules] | [modules] | [DB/file/cache/API/queue] | [`path`] | [verified/inferred] |

## Important Interaction Paths

### [Flow name]

1. [entry event/request]
2. [component interaction]
3. [state/external interaction]
4. [result]

Evidence:
- [`path` / symbol] — [what it confirms] [verified/inferred]

Add only representative flows that clarify architecture. Detailed runtime diagnostics belong in `OPERATIONS.md`.

## Interface Ownership

| Interface area | Owning component | Contract source | Architectural significance | Status |
|---|---|---|---|---|
| [HTTP/CLI/event/library/etc.] | [component] | [`path` / `API_SURFACE.md`] | [why this boundary matters] | [verified/inferred] |

## Architecture-Relevant Constraints

| Constraint | Source | Architectural effect | Status |
|---|---|---|---|
| [constraint] | [`path`, ADR, explicit doc] | [effect] | [verified/inferred] |

Do not turn a recurring implementation pattern into a normative constraint without explicit evidence.

## Related Decisions

| ADR / source | Decision | Affected area | Status |
|---|---|---|---|
| [`../adr/NNNN-...md`] | [decision] | [area] | [current/superseded/etc.] |

Omit when no decision records exist.

## Risks, Tensions, and Unknowns

| Item | Evidence | Why it matters | Status / next step |
|---|---|---|---|
| [risk/tension/unknown] | [`path`] | [reason] | [uncertain/missing/action] |
