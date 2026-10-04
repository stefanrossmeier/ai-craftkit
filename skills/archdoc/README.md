# Archdoc

`archdoc` is the central repository-documentation skill in `ai-craftkit`.

## Command

```text
/archdoc
```

It inspects a repository and creates a concise, evidence-based architecture documentation set under:

```text
docs/archdoc/
```

Canonical outputs:

- `docs/archdoc/REPO_MAP.md` — repository orientation, important paths, entry points, commands, tests, and observed conventions.
- `docs/archdoc/ARCHITECTURE.md` — architecture drivers, context, solution strategy, major building blocks, dependencies, data/state ownership, cross-cutting concepts, representative interactions, decisions, and risks.
- `docs/archdoc/API_SURFACE.md` — detailed public and integration-relevant contracts, when such a surface exists.
- `docs/archdoc/OPERATIONS.md` — runtime, build/release/deploy, verification, observability, and failure handling, when operational behavior is meaningful.

`REPO_MAP.md` deliberately does **not** contain a domain glossary or a general agent work guide. Domain language belongs to the `glossary` skill; normative agent instructions belong in `AGENTS.md` or the repository's instruction mechanism.

## Design Rules

`archdoc` should:

- prefer repository evidence over assumptions
- mark material uncertainty as verified, inferred, uncertain, or missing
- separate observed conventions from human-owned standards
- avoid duplicating the same detail across the four documents
- preserve useful human-authored material during updates
- cover the essential architecture story without turning the document into an exhaustive inventory
- use optional diagrams only when they improve understanding, and keep Mermaid syntax conservative and GitHub-renderable
- avoid exhaustive generated inventories when a canonical spec already exists

## Recommended Workflow

1. Read repository instructions, existing docs, ADRs, and existing `docs/archdoc/` files.
2. Inspect manifests, source structure, entry points, tests, and important runtime/configuration files.
3. Trace representative structure and interfaces rather than reading everything indiscriminately.
4. Create or refresh only the archdoc files that are useful for the repository.
5. Report skipped documents and important evidence gaps.

See [`SKILL.md`](SKILL.md) for the full workflow and evidence rules.
