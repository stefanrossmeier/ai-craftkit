---
name: archdoc
description: Inspect a repository and create or refresh concise, evidence-based architecture documentation under docs/archdoc/. Use for repository orientation, static architecture, interface surfaces, and operational/runtime documentation.
license: Apache-2.0
---

# Archdoc Skill

Command: `/archdoc`

`archdoc` is the central repository-documentation skill in `ai-craftkit`. It turns repository evidence into a small set of maintained architecture documents for humans and coding agents.

## Outputs

Write architecture documentation under:

```text
docs/archdoc/
```

Canonical files:

```text
docs/archdoc/REPO_MAP.md
docs/archdoc/ARCHITECTURE.md
docs/archdoc/API_SURFACE.md    # when the repository exposes meaningful interfaces
docs/archdoc/OPERATIONS.md     # when runtime, build, release, deploy, or support behavior is meaningful
```

Always create or refresh `REPO_MAP.md` and `ARCHITECTURE.md`.

Create `API_SURFACE.md` only when there is a public or integration-relevant contract such as HTTP, RPC, events, CLI commands, webhooks, schemas, plugin points, or public library exports.

Create `OPERATIONS.md` when there is meaningful execution, packaging, runtime, deployment, observability, release, debugging, or recovery behavior. Do not create an empty operations document merely to complete a set.

Use the bundled templates as starting shapes, not as mandatory checklists:

```text
skills/archdoc/templates/REPO_MAP.template.md
skills/archdoc/templates/ARCHITECTURE.template.md
skills/archdoc/templates/API_SURFACE.template.md
skills/archdoc/templates/OPERATIONS.template.md
```

Remove irrelevant sections and all unresolved placeholders.

## Document Responsibilities

Keep the documents distinct.

### `REPO_MAP.md`

Repository orientation only:

- what this repository is
- important top-level paths
- entry points
- important modules/packages
- build, test, run, and verification commands that are actually evidenced
- important config, generated, and artifact paths
- observed repository conventions when useful
- recommended reading order
- known gaps

Do **not** put a domain glossary in `REPO_MAP.md`. Use the `glossary` skill when a domain glossary is useful.

Do **not** turn `REPO_MAP.md` into an `AGENTS.md` replacement. It may help navigation, but normative agent instructions belong in `AGENTS.md` or the repository's instruction mechanism.

### `ARCHITECTURE.md`

`ARCHITECTURE.md` is the main explanation of how the repository is shaped and why a maintainer should care about that shape. Keep it concise, but do not reduce it to a component inventory. A useful architecture document should answer these questions when the repository provides evidence:

1. **Scope and context** — what does this repository own, who/what uses it, and what lies outside its boundary?
2. **Architecture drivers** — which explicit requirements, quality goals, or hard constraints materially shape the architecture?
3. **Solution strategy** — what top-level decomposition and mechanisms organize the implementation?
4. **Building blocks and dependencies** — what are the major components, responsibilities, dependency directions, and owned state/data?
5. **Cross-cutting concepts** — how are architecture-significant concerns such as security/trust, validation, errors, consistency, concurrency, caching, configuration boundaries, or extensibility handled when relevant?
6. **Interactions, interfaces, decisions, and risks** — which representative flows and boundaries matter, which ADRs explain decisions, and which important risks or unknowns remain?

These are content responsibilities, not a demand for long prose. Omit irrelevant subsections, but do not omit a material architecture topic merely to keep the file short. If an expected driver, rationale, or quality goal cannot be established, record it as missing instead of inventing it.

Detailed contracts belong in `API_SURFACE.md`. Deployment topology, startup/run procedures, observability, operational failure handling, and recovery belong in `OPERATIONS.md`, except where a short reference is necessary to understand an architecture-significant boundary or flow.

### `API_SURFACE.md`

Detailed public and integration-relevant contracts:

- interface inventory
- consumers and owners
- contract sources
- inputs/outputs or payloads
- authentication/authorization when evidenced
- validation and failure behavior
- versioning/compatibility constraints
- tests or other contract verification

Prefer links to canonical OpenAPI, GraphQL, protobuf, schemas, or generated reference docs over duplicating them.

### `OPERATIONS.md`

Runtime and operational knowledge:

- execution modes and startup paths
- safe local run/build/test instructions
- configuration names and sources, never secret values
- runtime dependencies
- deployment/release shape when present
- important runtime flows
- observability signals and where they are produced
- failure modes and recovery/verification steps
- operational gaps

`OPERATIONS.md` describes what repository evidence says about runtime behavior. It does not replace live runtime observation.

## Evidence Policy

Every material claim must be grounded in repository evidence or clearly marked as an inference.

Use these labels where uncertainty matters:

- **verified**: directly supported by current code, config, schema, tests, commands, or explicit documentation
- **inferred**: strongly suggested by multiple repository signals but not directly confirmed
- **uncertain**: plausible but weakly supported
- **missing**: expected information was searched for and not found

Prefer specific evidence such as:

```text
path/to/file
path/to/file:SymbolName
manifest script name
route/handler registration
schema or migration
specific test
safe command and observed result
```

Do not invent architectural intent from implementation shape. Code can prove that something exists; it usually cannot prove why humans chose it. Use ADRs or explicit human sources for rationale.

Do not promote recurring implementation patterns into normative engineering standards. If a pattern is worth mentioning, call it an **observed convention** and cite evidence. A human-owned standard or ADR overrides an observed convention.

## Inspection Workflow

Use the smallest inspection set that supports the requested scope. Do not read the repository indiscriminately.

1. **Read repository instructions and existing docs**
   - `AGENTS.md` and equivalent agent instructions
   - `README*`, `CONTRIBUTING*`, existing architecture docs
   - `docs/adr/` and other explicit decision records
   - existing `docs/archdoc/`

2. **Identify the repository shape**
   - language/package manifests and lockfiles
   - workspace/module definitions
   - build/test/lint configuration
   - CI workflows
   - main source/test directories

3. **Trace important structure and architecture drivers**
   - entry points and public exports
   - module/package boundaries and dependency direction
   - explicit requirements, quality goals, compatibility/security constraints, and ADRs
   - data/state ownership, persistence, and external integrations
   - architecture-significant cross-cutting mechanisms
   - representative tests that establish boundaries or invariants

4. **Inspect runtime/contract evidence when relevant**
   - routes, schemas, event contracts, CLI registration
   - config/env declarations
   - Docker/deployment/runtime files
   - logging, metrics, tracing, health checks
   - release/package configuration

5. **Use history only when it adds evidence**
   - git history, issues, or PRs may clarify change history or explicit decisions
   - do not infer motives merely from commit shape

For a large repository, sample representative areas first and state the review scope. Expand only when necessary.

## Commands and Safety

Start read-only.

Safe examples include repository listing, text search, manifest inspection, and existing read-only project commands. Run tests, builds, linters, or local commands only when they materially verify a claim and are reasonably safe.

Do not by default:

- install dependencies
- start long-running servers
- run deployments
- mutate databases or external services
- execute destructive cleanup commands
- copy secret values into documentation

Environment variable **names** and secret **locations** may be documented. Secret values may not.

## Writing Rules

1. Be concise. Prefer a useful summary plus precise links over exhaustive inventories.
2. Preserve human-authored information when updating an existing file unless it is demonstrably stale or wrong.
3. Do not silently overwrite explicit human decisions with inferred repository behavior.
4. Remove template sections that do not apply.
5. Keep generated tables bounded; list representative or important entries and link to canonical sources for exhaustive detail.
6. Avoid repeating the same facts in multiple archdoc files. Put each fact in the document that owns it and cross-reference when useful.
7. Do not duplicate a domain glossary, ADR rationale, engineering standards, or agent workflow instructions inside archdoc.
8. If repository evidence contradicts existing documentation, report the conflict explicitly instead of choosing silently.
9. Mark review scope and source revision when available so future readers can judge staleness.

## Provenance

Each generated document should contain a small provenance/status block near the top with fields equivalent to:

```text
Review Scope: [full | targeted area | delta]
Doc Status: [MAINTAINED | DRAFT | NEEDS REVIEW]
Last Updated: [YYYY-MM-DDTHH:MM:SSZ]
Updated By: [human | agent | human+agent]
Source Revision: [git SHA | unavailable]
Source Basis: [short list of inspected evidence]
```

Do not fabricate a revision or timestamp. Use `unavailable` when it cannot be established.

## Diagrams

A diagram is optional. Add one only when it explains structure or behavior more clearly than prose/table form.

When a diagram is useful, use the `mermaiddoc` helper guidance and keep the diagram focused. `archdoc` remains responsible for the validity of Mermaid that it writes: use conservative GitHub-compatible syntax, quote human-readable flowchart labels (for example `Endpoint["Remote HTTP(S) endpoint"]`), and validate with an existing parser/renderer when one is available. If syntax is uncertain and cannot be validated, prefer prose or a table over a broken diagram.

Do not create a second architecture model merely because Mermaid is available.

## Existing Documentation

When `docs/archdoc/` already exists:

1. read it before rewriting it
2. preserve still-correct human notes and review annotations
3. verify important claims against current repository evidence
4. update changed paths, commands, contracts, and boundaries
5. remove stale generated material only when the replacement is supported
6. keep unresolved disagreements visible as gaps or review notes

Do not regenerate all files blindly when only one document or area changed.

## Completion Report

At the end, report only what matters:

```text
Archdoc complete.

Created/updated:
- docs/archdoc/REPO_MAP.md
- docs/archdoc/ARCHITECTURE.md
- docs/archdoc/API_SURFACE.md [if applicable]
- docs/archdoc/OPERATIONS.md [if applicable]

Skipped:
- [document]: [why not applicable]

Verification performed:
- [read-only scan / tests / build / none]

Important gaps:
- [gap]
- [gap]
```

## Non-Goals

`archdoc` does not:

- invent architecture or rationale
- create a domain glossary
- discover organization-wide engineering standards
- replace ADRs
- perform a boundary/quality review
- guarantee runtime truth from static repository evidence

## Core Principle

Create the smallest set of architecture documents that lets a future human or coding agent understand **what is here, how it is structured, where its contracts are, and how it runs**, while making the limits of repository evidence explicit.
