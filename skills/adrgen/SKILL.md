---
name: adrgen
description: Discover, prepare, capture, or generate evidence-based Architecture Decision Records under docs/adr/. Use when architectural choices need to be surfaced, discussed, or recorded without inventing historical rationale.
license: Apache-2.0
---

# Adrgen Skill

Command: `/adrgen`

`adrgen` supports architecture decision work while keeping a strict boundary between **what the repository implements** and **what humans explicitly decided**.

## Modes

```text
/adrgen discover
/adrgen generate
/adrgen capture
/adrgen prepare
```

Treat additional user text as plain-language scope or source material, not shell-style flags.

### `discover`

Find architecture-significant choices that appear in the repository but are not adequately documented.

Default output:

```text
docs/adr/ADR_CANDIDATES.md
docs/adr/README.md
```

Discovery identifies **implemented decision candidates**. It must not claim that a choice was historically accepted, or invent why it was chosen, merely because the code consistently implements it.

Good candidates usually have meaningful consequences for boundaries, data ownership, integration, deployment, security, reliability, technology/platform commitment, or future change cost.

Do not treat ordinary implementation details, style conventions, or every dependency as ADR-worthy.

### `generate`

Turn reviewed/selected candidates into ADR drafts.

Read:

```text
docs/adr/ADR_CANDIDATES.md
docs/adr/README.md
docs/adr/*.md
```

Generate only candidates explicitly marked selected/approved/ready, or directly requested by the user.

Default decision status for a candidate inferred from repository implementation is `PROPOSED`, even when the implementation already exists. Record implementation separately as `IMPLEMENTED`, `PARTIAL`, or `UNKNOWN`.

An ADR may be marked `ACCEPTED` only when explicit human evidence establishes acceptance, for example:

- user-provided confirmation
- existing decision documentation
- meeting/discussion notes
- issue or pull-request decision text
- an authoritative project document that clearly records the decision

Code shape alone is not evidence of historical acceptance.

### `capture`

Turn an explicit human decision source into an ADR.

Typical sources:

- meeting notes or transcript
- issue/PR discussion
- architecture review notes
- user-provided decision summary
- existing design document

Capture the decision actually supported by the source. Preserve disagreement, unresolved points, and missing rationale rather than completing the story from repository guesses.

`ACCEPTED` is appropriate only when the source shows that the decision was accepted. Otherwise use `PROPOSED` or `NEEDS REVIEW` as appropriate.

### `prepare`

Prepare a decision before it is made.

Default output:

```text
docs/adr/ADR_PREP-<topic>.md
docs/adr/README.md
```

A preparation document may contain problem framing, drivers, constraints, options, trade-offs, evidence, and questions. It must say clearly that **no decision has been made yet**.

If the user explicitly asks for a proposed ADR instead, create an ADR with `Decision Status: PROPOSED`.

## Output Directory

All decision artifacts belong under:

```text
docs/adr/
```

Typical files:

```text
docs/adr/README.md
docs/adr/ADR_CANDIDATES.md
docs/adr/ADR_PREP-<topic>.md
docs/adr/NNNN-<decision-title>.md
```

Use the bundled templates:

```text
skills/adrgen/templates/adr-0000.template.md
skills/adrgen/templates/ADR_CANDIDATES.template.md
skills/adrgen/templates/ADR_PREP.template.md
```

Templates are shapes, not forms to fill mechanically. Remove irrelevant sections and unresolved placeholders.

## Source Authority Model

Keep these concepts separate:

| Evidence | Can establish implementation? | Can establish historical rationale? | Can establish acceptance? |
|---|---:|---:|---:|
| Current code/config/tests | yes | usually no | no |
| Existing ADR/design decision doc | yes/possibly | yes | yes, if explicit |
| Meeting/issue/PR discussion | possibly | yes | yes, if explicit |
| Human input in current task | possibly | yes | yes, if explicit |
| Naming/pattern inference | possibly/inferred | no | no |

A repository may contain an architecture choice that is clearly implemented while the original rationale is unknown. Document exactly that state.

Never rewrite inferred rationale as historical fact.

## Evidence Labels

Use these labels when useful:

- **verified**: directly supported by repository evidence or explicit human source
- **inferred**: strongly suggested but not directly confirmed
- **uncertain**: plausible with weak support
- **missing**: sought but not found

For decision history, source quality matters more than code consistency.

## Relationship to Archdoc

When present, read architecture context from:

```text
docs/archdoc/REPO_MAP.md
docs/archdoc/ARCHITECTURE.md
docs/archdoc/API_SURFACE.md
docs/archdoc/OPERATIONS.md
```

Use these as current-system evidence, not as proof of original decision rationale unless they explicitly record it.

Do not copy large parts of archdoc into ADRs. ADRs should explain the **decision and consequences**, not re-document the entire current architecture.

## Inspection Workflow

Use only the amount of repository inspection needed for the mode.

### Discover

1. Read existing ADRs and explicit architecture/design docs first.
2. Read relevant `docs/archdoc/` files when present.
3. Inspect manifests, boundaries, major dependencies, schemas, deployment/config, and representative tests.
4. Look for consequential, stable choices and compare them with existing ADR coverage.
5. Write a candidate only when there is concrete evidence and a meaningful architectural consequence.
6. Record missing historical rationale instead of reconstructing it.

### Generate

1. Read candidates and existing ADRs.
2. Select only approved/requested candidates.
3. Re-check evidence needed to keep the draft current.
4. Create one ADR per selected decision.
5. Update candidate status and ADR index.

### Capture

1. Identify the explicit human source.
2. Extract problem, decision, alternatives actually discussed, drivers, consequences, and unresolved points.
3. Verify current repository impact only where useful.
4. Do not add historical alternatives or motives that the source does not support.
5. Create/update the ADR and index.

### Prepare

1. Define the decision question and scope.
2. Gather current constraints and evidence.
3. Identify plausible options without pretending they were historically considered.
4. Compare trade-offs against explicit drivers.
5. List information still needed before deciding.
6. Create the preparation document and index entry.

## Candidate Quality Test

A discovered item is ADR-worthy when most of these are true:

- changing it would affect multiple modules, boundaries, deployments, contracts, or data ownership
- it creates a meaningful long-term constraint or commitment
- future engineers could reasonably reopen the question without context
- there are realistic alternatives
- the consequences are larger than a local implementation detail
- repository evidence shows the choice is real and currently relevant

Reject or defer candidates that are merely naming/style choices, local refactors, obvious framework mechanics, or weak speculation.

## ADR Status Rules

Allowed decision statuses:

```text
PROPOSED
ACCEPTED
REJECTED
SUPERSEDED
DEPRECATED
```

Track implementation independently:

```text
NOT STARTED
PARTIAL
IMPLEMENTED
UNKNOWN
```

Important rules:

- `discover` does not establish `ACCEPTED`
- `generate` from code-discovered candidates defaults to `PROPOSED`
- `capture` may use `ACCEPTED` when the human source explicitly establishes it
- `prepare` has no decision status unless the user requests a proposed ADR
- a decision may be `PROPOSED` while implementation is already `IMPLEMENTED`; this means the repository implements the choice but its formal/historical decision status is not established

## Alternatives and Rationale

Only claim an option was **historically considered** when evidence supports that claim.

If alternatives are reconstructed for current review, label them explicitly as current/reconstructed options. Do not imply they were part of the original decision process.

If the original rationale cannot be recovered, write:

```text
Original rationale: not recovered from available evidence.
```

You may document current constraints or consequences that make the implemented choice understandable today, but keep that separate from historical rationale.

## ADR Numbering

Use the repository's existing convention when one exists. Otherwise use:

```text
docs/adr/NNNN-short-kebab-case-title.md
```

Rules:

1. inspect existing ADR filenames first
2. use the next available number
3. never renumber existing ADRs
4. never reuse a number
5. update an existing ADR rather than create a duplicate
6. keep superseded ADRs and link both directions when possible

Preparation files do not consume numbers by default.

## ADR Index

Maintain `docs/adr/README.md` as a concise index when decision artifacts exist.

Suggested minimum:

```md
# Architecture Decision Records

## ADRs
| ID | Title | Decision Status | Implementation | Date |
|---|---|---|---|---|

## Preparation Documents
| Topic | File | Status |
|---|---|---|

## Candidate Documents
- `ADR_CANDIDATES.md`
```

Do not put general agent instructions or architecture documentation into the index.

## Existing ADRs

When updating existing ADRs:

- preserve historical decision content unless an explicit correction is supported
- do not rewrite past rationale to match the current implementation
- distinguish current review notes from original decision text
- preserve supersession/deprecation history
- report contradictions between ADR and implementation instead of silently making them agree

## Commands and Safety

Start read-only. Use repository searches and safe inspection first.

Do not by default:

- modify application source
- install dependencies
- run deployments or state-changing commands
- expose secrets
- create ADRs for every candidate
- mark a decision accepted because the code happens to implement it

## Completion Report

Report the mode, files changed, decision statuses used, evidence gaps, and any candidates intentionally skipped.

Keep the report short; the decision artifacts are the durable output.

## Non-Goals

`adrgen` does not:

- invent historical rationale
- infer formal human acceptance from code
- replace architecture documentation
- create organization-wide engineering standards
- turn routine implementation details into ADRs
- decide unresolved architecture questions on behalf of humans

## Core Principle

**Implementation tells you what exists. Explicit decision evidence tells you what humans decided and why. Keep those two kinds of knowledge separate.**
