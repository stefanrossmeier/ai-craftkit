# PyJWT example

This folder contains example documentation generated for the public `pyjwt` repository using the `mermaiddoc` skill from `ai-craftkit`.

The purpose of this example is to show how a small, focused prompt can produce useful explanatory diagrams and Markdown documentation for an existing codebase.

## Source repository

The documentation in this folder is based on the public PyJWT repository:

```text
https://github.com/jpadilla/pyjwt
```

PyJWT is a Python library for working with JSON Web Tokens. It is small enough to inspect, but still contains meaningful flows around token decoding, signature verification, claim validation, algorithms, exceptions, and JWKS support.

## Skill used

This example uses:

```text
skills/mermaiddoc/SKILL.md
```

The `mermaiddoc` skill focuses on practical Mermaid diagrams that are readable, GitHub-compatible, and useful for developers.

## Prompt used

The prompt used for this example was intentionally short:

```text
/mermaiddoc In the pyjwt repo describe the encode workflow with a new md file. Also describe the decode workflow with a separate md file.
```

This was enough for the skill to identify two useful documentation targets:

1. the JWT encode workflow
2. the JWT decode workflow

## Generated files

This folder contains documentation for:

| File                              | Purpose                                                        |
| --------------------------------- | -------------------------------------------------------------- |
| `diagrams/jwt-encode-workflow.md` | Explains how `jwt.encode()` builds and signs a compact JWT.    |
| `diagrams/jwt-decode-workflow.md` | Explains how `jwt.decode()` verifies, parses, and validates a token. |

Both generated files include:

* a provenance block with repository URL, commit hash, and exact prompt
* a focused Mermaid diagram that renders in GitHub
* a short source basis section listing inspected files
* concise notes that distinguish verified behavior from omitted detail

## Why this example exists

The example demonstrates a practical use case for AI-assisted documentation:

* take an existing repository
* ask for documentation around one focused workflow
* generate Markdown that developers can review
* include diagrams that explain control flow
* keep the result small enough to maintain

The goal is not to produce perfect final documentation automatically. The goal is to create a useful first draft that is grounded in the repository and easy for a developer to check.

## What to look for

When reviewing the generated files, pay attention to whether the documentation is:

* specific to PyJWT
* focused on one behavior per file
* readable without knowing the entire repository
* clear about the control flow from public API to internal implementation
* supported by the actual code structure
* simple enough to maintain

The diagrams should explain the main encode and decode paths. They should not try to model every implementation detail or exception branch.

## Notes

This example is intentionally small.

It shows how `mermaiddoc` can be used as part of a repository documentation workflow without requiring a long prompt or a large setup. The current example focuses on two adjacent public APIs so the output stays easy to verify against the repository.

A more complete documentation run could add separate diagrams for claim validation, algorithm selection, or JWKS-based key lookup, or combine this with the `archdoc` skill for higher-level repository structure.
