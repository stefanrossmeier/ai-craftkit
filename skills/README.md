# Skills

`ai-craftkit` contains reusable Agent Skills for evidence-based engineering workflows.

Each skill has YAML frontmatter with at least:

```yaml
---
name: skill-name
description: When and why the agent should use the skill.
license: Apache-2.0
---
```

The description is part of skill routing. Keep it concrete enough that an agent can decide whether the skill applies without loading the entire skill body.

## Skill map

| Skill | Role | Durable output |
|---|---|---|
| `archdoc` | **Central repository documentation** | `docs/archdoc/` |
| `adrgen` | Architecture decision discovery/preparation/capture | `docs/adr/` |
| `glossary` | Domain terminology | `docs/GLOSSARY.md` |
| `mermaiddoc` | Focused diagram helper | Usually inserted into an existing doc |
| `c4doc` | Optional C4-style documentation | `docs/c4-documentation/` |
| `cockburn-review` | Point-in-time boundary review | review report |
| `overengineering-review` | Point-in-time complexity review | review report |

## Shared design principles

### Evidence first

Repository-facing skills should inspect concrete evidence before writing conclusions. Important uncertainty can be marked as:

```text
verified
inferred
uncertain
missing
```

### Keep authority boundaries clear

Current code can show what is implemented. It usually cannot prove why a historical decision was made or whether it was formally accepted.

Generated observations should also not silently become engineering policy. An observed repository convention is descriptive unless an explicit human-owned standard or decision says otherwise.

### Prefer progressive disclosure

`SKILL.md` should contain the core workflow and rules. Put reusable output shapes in templates/examples rather than duplicating large examples inside the skill body.

### Keep outputs distinct

Do not create several independent documents that all try to be the architecture source of truth. The main split is:

```text
docs/archdoc/   current repository architecture knowledge
docs/adr/       decision records and rationale
AGENTS.md        agent instructions and routing
```

Other skills should add specialized artifacts only when they have a clear purpose.

## `archdoc`

`archdoc` is the primary repository-documentation workflow.

Outputs:

```text
docs/archdoc/REPO_MAP.md
docs/archdoc/ARCHITECTURE.md
docs/archdoc/API_SURFACE.md    # conditional
docs/archdoc/OPERATIONS.md     # conditional
```

`REPO_MAP.md` is orientation, not a glossary and not an `AGENTS.md` replacement.

Use `archdoc` when onboarding to an unfamiliar repository, refreshing architecture docs, preparing architecture review context, or creating durable context for coding agents.

## `adrgen`

Modes:

```text
/adrgen discover
/adrgen generate
/adrgen capture
/adrgen prepare
```

`discover` finds implemented architecture-significant choices; `generate` turns reviewed candidates into ADR drafts; `capture` records an explicit human decision source; `prepare` structures an unresolved decision before the discussion.

The key rule is:

> Implementation tells you what exists. Explicit decision evidence tells you what humans decided and why.

## `mermaiddoc`

`mermaiddoc` is a helper for one specific Mermaid diagram.

Prefer `flowchart LR` and `sequenceDiagram`. Insert the diagram into the document that needs it. Do not create a repository-wide diagram tree by default.

## `glossary`

Use `glossary` for candidate ubiquitous language and repository-specific business/domain terminology. Keep technical framework vocabulary out unless it has a specific domain meaning.

## `c4doc`

Use `c4doc` when the project intentionally wants C4-style views. Do not run it automatically just because `archdoc` exists; that can create overlapping architecture documentation.

## Review skills

`cockburn-review` and `overengineering-review` are diagnostic workflows. Their findings are point-in-time analyses, not automatically durable architecture truth.

## Recommended documentation workflow

For a repository that needs agent-friendly documentation:

1. Run `archdoc` and review `docs/archdoc/`.
2. Use `adrgen discover` to identify architecture-significant choices missing decision records.
3. Human-review the candidates, then use `adrgen generate` for selected items.
4. Use `glossary` only when domain terminology is important enough to justify a maintained glossary.
5. Use `mermaiddoc` only where a specific visual improves a document.
6. Use C4/review skills deliberately for their specialized purpose rather than as mandatory stages.
7. Keep `AGENTS.md` small and point it to the relevant documents by task.

## Adding or changing a skill

A skill should have:

- YAML frontmatter with a routing-quality description
- a clear purpose and invocation model
- the smallest useful workflow
- explicit outputs when it creates artifacts
- evidence/safety rules when repository inspection is involved
- non-goals that prevent scope creep
- templates or examples only when they reduce repetition

Avoid giant `SKILL.md` files that contain tutorials, many repeated examples, or document templates inline. Keep the core workflow in the skill and move output structure to supporting files.
