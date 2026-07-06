# PyJWT architecture documentation example

This folder contains example architecture documentation generated for the public `pyjwt` repository using the `archdoc` skill from `ai-craftkit`.

The purpose of this example is to show how the skill can inspect an existing repository and produce structured architecture documentation that is grounded in visible repository evidence.

## Source repository

The documentation in this folder is based on the public PyJWT repository:

```text id="7p2im5"
https://github.com/jpadilla/pyjwt
```

PyJWT is a Python library for working with JSON Web Tokens. It provides useful architecture documentation targets because it has a focused domain, a small codebase, clear module boundaries, tests, documentation, packaging configuration, and security-relevant behavior.

## Skill used

This example uses:

```text id="re5ktk"
skills/archdoc/SKILL.md
```

The `archdoc` skill is designed to inspect a repository and generate architecture documentation with a strong preference for evidence, uncertainty handling, and reviewable output.

## Prompt used

The prompt used for this example was:

```text id="slgrgn"
/archdoc generate the documentation docs for the pyjwt repository here in this workspace
```

The prompt is intentionally short. It relies on the skill to define the workflow: inspect the repository, identify relevant architectural structure, and create documentation that can be reviewed by a developer.

## Generated output

This folder contains generated architecture documentation for PyJWT.

The current `archdoc` skill is designed around four primary outputs:

```text id="ru6doe"
REPO_MAP.md
ARCHITECTURE.md
API_SURFACE.md
OPERATIONS.md
```

This stored example currently predates the `API_SURFACE.md` addition and only contains the older subset of generated files. The responsibility split, however, now expects interface contract detail to live in `API_SURFACE.md` rather than being spread across the other documents.

## What the skill looks for

When run against a repository like PyJWT, `archdoc` may inspect evidence such as:

* package and module structure
* public API entry points
* internal module boundaries
* tests
* documentation
* packaging configuration
* dependency declarations
* error and exception handling
* algorithm support
* validation behavior
* JWKS-related code
* project scripts and tooling configuration

The skill should avoid inventing architectural intent that is not visible in the repository.

## What good output should show

Good architecture documentation for this example should make clear:

* where the public API lives
* how JWT-level behavior relates to JWS-level behavior
* where payload decoding and claim validation happen
* how algorithms and keys are handled
* how exceptions are organized
* how JWKS support fits into the library
* how tests and documentation support the implementation
* which findings are verified and which are inferred

The output should be specific to PyJWT. Generic statements about “modular architecture” or “clean separation of concerns” are only useful when backed by repository evidence.

## How to review the output

Review the generated documentation with these questions:

* Does it describe PyJWT specifically?
* Does it separate verified facts from inferred conclusions?
* Are uncertain findings clearly marked?
* Are important modules and flows covered?
* Are claims supported by repository structure or code behavior?
* Is the documentation useful for onboarding?
* Would a maintainer recognize the system from this description?
* Is anything overstated?

A good `archdoc` result should feel like a careful repository walkthrough, not a marketing summary.

## Expected value

This example demonstrates how `archdoc` can create a first architecture documentation draft from an existing codebase.

The result can help with:

* onboarding developers
* understanding unfamiliar repositories
* preparing architecture reviews
* identifying documentation gaps
* creating context before ADR discovery
* selecting useful flows for Mermaid diagrams

The generated documentation should still be reviewed by a human before being treated as final.

## Limitations

This output should not be read as official PyJWT documentation.

It is an external documentation exercise based on repository inspection. Some findings may be inferred from code structure and naming. The skill should make those cases visible instead of presenting them as confirmed project intent.

## Suggested workflow

A useful workflow for this example is:

1. Run `archdoc` against the PyJWT repository.
2. Store the generated documentation in this folder.
3. Review the output against the source code.
4. Remove generic or unsupported claims.
5. Keep useful architecture explanations.
6. Use `mermaiddoc` for diagrams of selected flows.
7. Use `adrgen` to discover architectural decision candidates.

## Notes

The short prompt is intentional.

It demonstrates that the skill contains the documentation workflow. The user does not need to write a detailed architecture prompt to get structured repository documentation.
