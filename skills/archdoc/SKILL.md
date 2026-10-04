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

Use the bundled templates as starting shapes:

```text
skills/archdoc/templates/REPO_MAP.template.md
skills/archdoc/templates/ARCHITECTURE.template.md
skills/archdoc/templates/API_SURFACE.template.md
skills/archdoc/templates/OPERATIONS.template.md
```

Adapt headings to the repository and remove unresolved placeholders. For `ARCHITECTURE.md`, the template also defines a **coverage model**: a heading may be omitted, but the underlying architecture concern must first be accounted for as documented, cross-referenced, not applicable, or missing. Do not silently drop a material concern merely to make the file shorter.

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

`ARCHITECTURE.md` is the main explanation of how the repository is shaped and which architectural properties a maintainer must understand before changing it. Keep it concise, but do not reduce it to a component inventory.

Account for these architecture perspectives:

1. **Purpose, scope, and system boundary** — what does this repository own, who/what uses it, and what lies outside its boundary?
2. **Architecture drivers and quality goals** — which explicit security, reliability, compatibility, performance, portability, maintainability, or other requirements materially shape the architecture?
3. **Hard constraints** — which imposed platform, protocol, dependency, regulatory, runtime, or compatibility limits constrain the solution?
4. **Solution strategy** — what top-level decomposition and mechanisms organize the implementation?
5. **Building blocks and dependency direction** — what are the major components, responsibilities, and important dependency/boundary rules?
6. **Data and state ownership** — what state exists, who owns it, where it lives, and which state is caller/external/process-local when applicable?
7. **Cross-cutting concepts** — how are architecture-significant concerns such as security/trust, validation, errors, serialization, consistency, concurrency, caching, configuration boundaries, or extensibility handled when relevant?
8. **Representative interactions and interface ownership** — which flows and boundaries are necessary to understand collaboration between the building blocks?
9. **Architecture-relevant constraints and invariants** — which evidenced properties must remain true for the current architecture/contracts to remain valid?
10. **Decisions, risks, and unknowns** — which ADRs explain deliberate choices, which rationale is missing, and which architecture-significant risks or unknowns remain?

Do not conflate the perspectives:

- A **driver/quality goal** is a property the system is expected to achieve or preserve.
- A **hard constraint** is an externally imposed limit on the solution space.
- An **architectural consequence** is how the current design responds to a driver or constraint.
- Implementation can establish the consequence; only explicit human-owned sources establish historical rationale or acceptance.

### Architecture completeness gate

Before finishing `ARCHITECTURE.md`, account for each perspective above as one of:

- **documented** — relevant evidence exists and the document explains it
- **cross-referenced** — another canonical archdoc file owns the detail and `ARCHITECTURE.md` links to it
- **not applicable** — the concern genuinely does not apply to this repository type or scope
- **missing** — the concern is relevant, but expected evidence was searched for and not found

This is a generation-time coverage check, not a mandatory table to publish. A short architecture document is fine; a silently incomplete one is not. `not applicable` must not be used merely because evidence is difficult to find.

For **system context**, separate external actors/systems from internal components. A library's host application is outside the library boundary even though it shares a process; a remote service is external; ordinary in-process package dependencies normally belong in constraints/building blocks rather than being modeled as external systems.

For **data and state ownership**, explicitly say when a repository is stateless. Distinguish caller-owned or externally authoritative data from process-local caches/configuration and durable repository-owned state.

For **invariants**, require concrete evidence from code, tests, schemas, contracts, ADRs, or explicit documentation. An enforced contract or security property may be architecture-relevant even without a recovered historical ADR; a recurring coding style is not automatically an invariant.

Detailed contracts belong in `API_SURFACE.md`. Deployment topology, startup/run procedures, observability, operational failure handling, and recovery belong in `OPERATIONS.md`, except where a short reference is necessary to understand an architecture-significant boundary, state model, invariant, or flow.

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
   - entry points, public exports, primary consumers/actors, and the explicit repository/system boundary
   - directly connected external systems and the protocols/boundaries between them
   - module/package boundaries and dependency direction
   - explicit quality goals/requirements separately from hard platform/protocol/dependency constraints
   - ADRs and other human-owned rationale sources
   - caller-owned, external, transient/process-local, cached, and durable state/data ownership
   - architecture-significant cross-cutting mechanisms
   - representative tests that establish contracts, boundary rules, or invariants

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
4. Remove template sections only after the underlying concern has been accounted for by the architecture completeness gate.
5. Keep generated tables bounded; list representative or important entries and link to canonical sources for exhaustive detail.
6. Avoid repeating the same facts in multiple archdoc files. Put each fact in the document that owns it and cross-reference when useful.
7. Do not duplicate a domain glossary, ADR rationale, engineering standards, or agent workflow instructions inside archdoc.
8. If repository evidence contradicts existing documentation, report the conflict explicitly instead of choosing silently.
9. Mark review scope, canonical source repository, and source revision when available so future readers can judge staleness and inspect the exact evidence snapshot.
10. When the repository is on GitHub and an exact revision is known, prefer revision-pinned GitHub permalinks for source evidence; keep links between generated archdoc files relative.

## Provenance

Each generated document should contain a small provenance/status block near the top with fields equivalent to:

```text
Review Scope: [full | targeted area | delta]
Doc Status: [MAINTAINED | DRAFT | NEEDS REVIEW]
Last Updated: [YYYY-MM-DDTHH:MM:SSZ]
Updated By: [human | agent | human+agent]
Source Repository: [canonical repository URL | unavailable]
Source Revision: [git SHA | unavailable]
Source Basis: [short list of inspected evidence]
```

Do not fabricate a revision or timestamp. Use `unavailable` when it cannot be established.

When a canonical GitHub repository URL and exact commit SHA are available, make the provenance and evidence reproducible:

- link `Source Repository` to the repository tree at that SHA (`.../tree/<sha>`)
- link `Source Revision` to the commit (`.../commit/<sha>`)
- link source files to `.../blob/<sha>/<path>` and source directories to `.../tree/<sha>/<path>`
- do not use a moving branch such as `main` or `master` for evidence links when the exact SHA is known
- keep cross-links among `REPO_MAP.md`, `ARCHITECTURE.md`, `API_SURFACE.md`, `OPERATIONS.md`, and local ADRs relative

For non-GitHub repositories or when a canonical remote cannot be established safely, use repository-relative source links or plain paths. Never copy credentials, access tokens, or credential-bearing remote URLs into documentation.

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
