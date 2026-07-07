# PyJWT C4 documentation example

This folder contains example documentation generated for the public `pyjwt` repository using the `c4doc` skill from `ai-craftkit`.

The purpose of this example is to show how a short prompt can produce a practical, reviewable C4-style documentation set without forcing artificial views onto a small library repository.

## Source repository

The documentation in this folder is based on the public PyJWT repository:

```text
https://github.com/jpadilla/pyjwt
```

PyJWT is a Python library for working with JSON Web Tokens. It is a good fit for this example because it has meaningful internal structure, but it does not have the kind of deployable runtime topology that would justify a full C4 stack.

## Skill used

This example uses:

```text
skills/c4doc/SKILL.md
```

The `c4doc` skill inspects a repository, decides which C4 views are actually useful, generates Markdown under `docs/c4-documentation/`, and explicitly explains which views were skipped.

## Prompt used

The prompt used for this example was intentionally short:

```text
/c4doc Create the c4 documentation for the pyjwt repo here in this workspace.
```

This was enough for the skill to identify a useful reduced documentation set:

1. a C1 system context view
2. a C3-style component view for the `jwt` package
3. a shared architecture model and generation report
4. explicit skipped views for container, deployment, dynamic, and code levels

## Generated files

This folder contains:

| File | Purpose |
| --- | --- |
| `c4-documentation/index.md` | Entry point and reading order for the generated C4 set |
| `c4-documentation/architecture-model.md` | Shared source-of-truth tables for systems, components, relationships, and omissions |
| `c4-documentation/generation-report.md` | Inspection summary, generated files, skipped views, confirmed facts, and review notes |
| `c4-documentation/system-context.md` | C1 view of PyJWT, its users, and the JWKS integration boundary |
| `c4-documentation/components/jwt-library.md` | Focused component view for the main `jwt` package responsibilities |

All generated files include:

* a provenance block with repository URL, commit hash, and exact prompt
* evidence-backed descriptions and confidence distinctions
* GitHub-compatible Mermaid diagrams where a diagram is useful
* explicit omissions when a C4 level would be artificial

## Why this example exists

This example demonstrates a practical C4 documentation workflow for a library:

* inspect a real repository
* generate only the views that fit the repository shape
* avoid inventing deployment or container boundaries that do not exist
* record evidence, inferences, and skipped views
* keep the output small enough for pull-request review

The goal is not to auto-generate a perfect architecture truth. The goal is to produce a grounded first draft that gives maintainers a usable review surface.

## What to look for

When reviewing the generated files, pay attention to whether the documentation is:

* specific to PyJWT
* appropriately selective about which C4 levels were generated
* clear about what is confirmed versus inferred
* honest about the lack of deployable runtime structure in the repository
* small enough to review and maintain
* consistent across the index, model, diagrams, and report

The most important quality check for this example is whether the skipped views feel justified rather than missing.

## Folder structure

```text
examples/pyjwt/c4doc/
├── README.md
└── c4-documentation/
    ├── architecture-model.md
    ├── generation-report.md
    ├── index.md
    ├── system-context.md
    └── components/
        └── jwt-library.md
```

## Notes

This example is intentionally conservative.

It shows that `c4doc` should not produce every C4 level by default. For a small library like PyJWT, a good result is a smaller set of useful views plus a clear explanation of what was intentionally omitted.