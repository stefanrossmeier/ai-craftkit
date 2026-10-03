# ai-craftkit

Reusable AI agent skills for evidence-based software engineering work.

The repository focuses on a simple idea: coding agents should not have to rediscover a repository from scratch, but the documentation they consume should also not become a large pile of duplicated or speculative AI-generated text.

`ai-craftkit` therefore favors small, reviewable artifacts with explicit evidence boundaries.

## Core model

The current toolkit separates several kinds of knowledge:

| Artifact / skill | Responsibility |
|---|---|
| `AGENTS.md` | Human-owned agent instructions and routing: what must be followed and which docs to read for a task. |
| `archdoc` | Current repository facts: orientation, static architecture, interfaces, and operations. |
| `adrgen` | Architectural decisions: what humans decided, what is only implemented, and what rationale is actually evidenced. |
| `glossary` | Domain language and terminology. |
| `mermaiddoc` | A small helper for one specific diagram when a visual is useful. |
| review skills | Point-in-time analysis of boundaries or unnecessary complexity. |
| `c4doc` | Optional C4-style views when a project deliberately wants C4 documentation. |

The important separation is:

- repository implementation can establish **what exists**
- explicit decision sources establish **what humans decided and why**
- repeated implementation patterns are **observed conventions**, not automatically engineering standards
- agent instructions belong in `AGENTS.md` or the repository's instruction mechanism, not inside generated architecture documents

## Skills

### `archdoc` — central repository documentation

`archdoc` is the primary documentation skill.

It creates or refreshes evidence-based architecture documentation under:

```text
docs/archdoc/
```

Canonical outputs:

```text
docs/archdoc/REPO_MAP.md
docs/archdoc/ARCHITECTURE.md
docs/archdoc/API_SURFACE.md    # when a meaningful interface surface exists
docs/archdoc/OPERATIONS.md     # when operational/runtime behavior is meaningful
```

The responsibility split is deliberate:

- `REPO_MAP.md`: repository orientation, important paths, entry points, commands, tests, generated paths, and observed conventions.
- `ARCHITECTURE.md`: static architecture, boundaries, dependencies, state/data ownership, and high-level interface ownership.
- `API_SURFACE.md`: detailed public and integration-relevant contracts.
- `OPERATIONS.md`: runtime/build/release/deploy behavior, configuration, observability, failure handling, and verification.

`REPO_MAP.md` no longer contains a domain glossary or a generic agent work guide. Use the `glossary` skill for domain terminology and `AGENTS.md` for agent instructions.

### `adrgen` — architecture decisions

`adrgen` supports four modes:

```text
/adrgen discover
/adrgen generate
/adrgen capture
/adrgen prepare
```

The key rule is that **implementation and decision status are separate**.

A repository can clearly implement a choice while the historical decision status or original rationale is unknown. In that case, `adrgen` records the implementation evidence but does not silently label the choice `ACCEPTED`.

Typical output lives under:

```text
docs/adr/
```

### `mermaiddoc` — focused diagram helper

`mermaiddoc` is intentionally small. It creates one focused GitHub-renderable Mermaid diagram when a document or explanation benefits from a visual.

It does not own a separate documentation model and it does not create `docs/diagrams/` by default. Prefer inserting the diagram into the document that needs it.

### Other skills

| Skill | Purpose |
|---|---|
| `glossary` | Discover and document repository-specific business/domain language. |
| `c4doc` | Generate selective C4-style architecture views when C4 is intentionally used. |
| `cockburn-review` | Review responsibility drift, knowledge leakage, and boundary problems. |
| `overengineering-review` | Review accidental or unjustified implementation complexity. |

All skills contain Agent Skills YAML frontmatter with at least `name`, `description`, and `license`.

## Repository structure

```text
ai-craftkit/
├── README.md
├── skills/
│   ├── README.md
│   ├── archdoc/
│   ├── adrgen/
│   ├── mermaiddoc/
│   ├── glossary/
│   ├── c4doc/
│   ├── cockburn-review/
│   └── overengineering-review/
├── examples/
│   ├── AGENTS.md
│   └── pyjwt/
└── scripts/
```

## Recommended use with `AGENTS.md`

Generated architecture documents are most useful when an agent is told **when** to consult them rather than loading everything for every task.

A repository can use a small `AGENTS.md` such as:

```md
# Agent instructions

## Repository context

Start with `docs/archdoc/REPO_MAP.md` when you need orientation.

For architecture-sensitive changes, read:
- `docs/archdoc/ARCHITECTURE.md`
- relevant records under `docs/adr/`

For interface changes, also read:
- `docs/archdoc/API_SURFACE.md`

For runtime, deployment, configuration, reliability, or observability changes, also read:
- `docs/archdoc/OPERATIONS.md`

## Rules

- Treat `docs/archdoc/` as descriptive repository knowledge, not as organization-wide engineering policy.
- Preserve accepted ADRs unless the task explicitly revisits the decision.
- Search for an existing pattern before introducing a new one.
- Run the repository's documented verification commands before finishing a code change.
```

A fuller generic example is checked in at [`examples/AGENTS.md`](examples/AGENTS.md).

## Evidence model

Most repository-inspection skills use these labels when uncertainty matters:

- **verified** — directly supported by code, configuration, tests, schemas, commands, explicit docs, or explicit human input
- **inferred** — strongly suggested by repository evidence but not directly confirmed
- **uncertain** — plausible but weakly supported
- **missing** — expected information was searched for and not found

The labels should be used where they add value, not mechanically on every sentence.

## How to use

Architecture documentation:

```text
Use the archdoc skill.
Inspect this repository and create or refresh its architecture documentation.
```

ADR discovery:

```text
Use the adrgen skill in discover mode.
Identify architecture-significant choices that are implemented but not adequately documented.
Do not invent historical rationale.
```

Decision capture:

```text
Use adrgen capture with these meeting notes.
Create an ADR that records only the decision, alternatives, and rationale supported by the notes.
```

A focused diagram:

```text
Use mermaiddoc to create a sequence diagram for the token refresh flow and insert it into the relevant architecture document.
```

## Design principles

The skills should:

- prefer evidence over confident guesses
- separate current implementation from historical decision intent
- keep generated artifacts concise and maintainable
- make important uncertainty visible
- avoid duplicating the same facts across several documents
- preserve useful human-authored material during updates
- avoid reading or copying secrets
- use deterministic validation where it is already available instead of relying on prose alone

## Examples

The `examples/pyjwt/` directory contains checked-in examples produced by earlier iterations of the skills. Examples are useful for understanding the style, but the current `SKILL.md` files and templates are normative when behavior has changed.

## Status

This repository is experimental and evolving. The skills are intended to be directly useful in coding-agent workflows today, but generated documentation still requires human review.

A repository may not contain enough evidence to support a confident architecture claim or ADR. In that case, the correct result is to state what is missing rather than fill the gap with plausible text.

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md). Contributions should keep skills small, task-oriented, evidence-based, and internally consistent with their templates and README files.

## License

See [`LICENSE`](LICENSE).
