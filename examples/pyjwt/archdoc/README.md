# PyJWT architecture documentation example

This folder contains example architecture documentation generated for the public `pyjwt` repository using the `archdoc` skill from `ai-craftkit`.

The example is meant to show the current output shape of the skill: evidence-based repository documentation split across repository map, architecture, interface surface, and operations documents.

## Source repository

The documentation in this folder is based on the public PyJWT repository:

```text
https://github.com/jpadilla/pyjwt
```

PyJWT is a useful example target because it is a focused Python library with clear module boundaries, public APIs, tests, packaging metadata, documentation, and security-relevant behavior.

## Skill used

This example uses:

```text
skills/archdoc/SKILL.md
```

The `archdoc` skill inspects a repository and generates architecture documentation with a strong preference for concrete evidence, explicit uncertainty handling, and practical guidance for future agents and maintainers.

## Generated output

This folder currently contains the full four-document output set expected by the current version of the skill:

```text
REPO_MAP.md
ARCHITECTURE.md
API_SURFACE.md
OPERATIONS.md
```

The responsibility split is:

* `REPO_MAP.md`: repository orientation, important files, commands, conventions, and agent navigation
* `ARCHITECTURE.md`: static structure, modules, boundaries, dependencies, and data ownership
* `API_SURFACE.md`: public and integration-relevant interfaces, including Python imports and JWKS-related integration points
* `OPERATIONS.md`: local execution, verification, packaging, publishing, debugging, and runtime behavior

## What this checked-in example reflects

The generated documents in this folder reflect the current skill conventions rather than an older format. In particular, they now include:

* a lightweight provenance block near the top of each file
* status fields such as review scope, doc status, update timestamp, updater, and source basis
* a separate `API_SURFACE.md` document for contract and interface detail
* explicit handling of verified, inferred, and missing information where useful

The checked-in PyJWT docs are intentionally marked as a draft-quality architecture pass rather than official project documentation.

## Prompt and provenance

The exact prompt used for the checked-in example is recorded inside the generated documents themselves in the provenance block at the top of each file.

That is the current source of truth for the example run, because the skill now requires generated documents to preserve directly available provenance rather than reconstruct it later in the example README.

## What the skill looks for

When run against a repository like PyJWT, `archdoc` may inspect evidence such as:

* package and module structure
* public API entry points
* internal module boundaries
* tests
* existing documentation
* packaging configuration
* dependency declarations
* runtime and CI workflow files
* error and exception handling
* algorithm support
* validation behavior
* JWK and JWKS-related code

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
* which findings are verified, inferred, or still missing

The output should be specific to PyJWT. Generic statements about modularity or separation of concerns are only useful when backed by repository evidence.

## How to review the output

Review the generated documentation with these questions:

* Does it describe PyJWT specifically?
* Does it separate verified facts from inferred conclusions?
* Are important modules, flows, and integration points covered?
* Are claims supported by repository structure, code behavior, or configuration?
* Is the split between repo map, architecture, API surface, and operations actually useful?
* Would a maintainer recognize the system from this description?
* Is anything overstated?

A good `archdoc` result should feel like a careful repository walkthrough, not a marketing summary.

## Expected value

This example demonstrates how `archdoc` can create a first documentation pass for an existing codebase.

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

It is an external documentation exercise based on repository inspection. Some findings may be inferred from code structure, naming, or documentation gaps. The skill should make those cases visible instead of presenting them as confirmed project intent.

## Suggested workflow

1. Run `archdoc` against the target repository.
2. Store the generated documents in this example folder.
3. Review the output against the source code and existing project docs.
4. Remove unsupported claims and tighten weak sections.
5. Keep useful architecture explanations and repository-specific guidance.
6. Use `mermaiddoc` for diagrams of selected flows.
7. Use `adrgen` to discover architectural decision candidates.

## Notes

This example is useful partly because PyJWT is not a web service. It shows that `archdoc` should adapt to a library-shaped repository and document the real integration surface instead of inventing endpoints, infrastructure, or runtime components that are not present.
