# PyJWT C4 documentation example

This folder contains example documentation generated for the public `pyjwt` repository using the `c4doc` skill from `ai-craftkit`.

The example is meant to show the current output shape of the skill for a library-shaped repository: a selective C4 set with explicit skipped views rather than a forced full-stack diagram pack.

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

## Generated output

The live skill writes its generated files to the target repository's `docs/c4-documentation/` directory.

For this checked-in example, that output is stored locally under:

```text
c4-documentation/
```

This example currently contains:

```text
c4-documentation/index.md
c4-documentation/architecture-model.md
c4-documentation/generation-report.md
c4-documentation/system-context.md
c4-documentation/components/jwt-library.md
```

The responsibility split is:

* `index.md`: entry point and reading order for the generated C4 set
* `architecture-model.md`: shared source-of-truth tables for systems, components, relationships, evidence, and omissions
* `generation-report.md`: inspection summary, generated files, skipped views, confirmed facts, and review notes
* `system-context.md`: C1 view of PyJWT, its users, and external integration boundary
* `components/jwt-library.md`: focused component view for the main `jwt` package responsibilities

## What this checked-in example reflects

The generated files in `c4-documentation/` reflect the current skill conventions rather than an older all-levels format. In particular, they now include:

* a lightweight provenance block near the top of each generated document
* explicit skipped-view reporting instead of empty placeholder diagrams
* evidence-backed descriptions and confidence distinctions
* GitHub-compatible Mermaid diagrams only where a diagram adds clarity
* a smaller view set because PyJWT is a library rather than a deployable multi-container system

The checked-in PyJWT docs are intentionally a selective architecture pass, not official project documentation.

## Prompt and provenance

The exact prompt used for the checked-in example is recorded inside the generated C4 documents themselves in the provenance block at the top of each file.

That is the current source of truth for the example run, because the skill now requires generated documents to preserve directly available provenance rather than reconstructing it later in this README.

## What the skill looks for

When run against a repository like PyJWT, `c4doc` may inspect evidence such as:

* repository and package structure
* public API entry points
* internal module boundaries
* tests and supporting docs
* packaging metadata
* optional integration surfaces such as JWKS support
* runtime or deployment artifacts when present

For a library like PyJWT, a good result may intentionally skip container, deployment, dynamic, or code views when the repository does not justify them.

## How to review the output

Review the generated documentation with these questions:

* Does it choose the right subset of C4 views for PyJWT?
* Are the generated diagrams small, readable, and GitHub-compatible?
* Are confirmed and inferred elements separated clearly?
* Are skipped views justified rather than simply missing?
* Would a maintainer recognize the library structure from this documentation?
* Is anything overstated as deployable topology when the repository is really a library?

A good `c4doc` result should feel selective and defensible rather than exhaustive.

## Expected value

This example demonstrates how `c4doc` can document a real repository without forcing every C4 level into existence.

The value is in producing:

* a reviewable system context
* one useful component view
* a shared architecture model
* a generation report that explains omissions and review needs

## Limitations

This output should not be read as official PyJWT documentation.

It is an external documentation exercise based on repository inspection. Some structure is inferred from code organization, tests, and existing docs rather than confirmed by project maintainers. The skill should make those cases visible.

## Suggested workflow

1. Run `c4doc` against the target repository.
2. Store the generated `docs/c4-documentation/` output in this example folder.
3. Review the generated view set against the repository shape.
4. Remove unsupported claims and merge or skip weak views.
5. Keep the useful model, diagrams, and generation report.
6. Use `archdoc` or `cockburn-review` when deeper architecture context is needed.

## Notes

This example is intentionally conservative.

It shows that `c4doc` should not produce every C4 level by default. For a small library like PyJWT, a good result is a smaller set of useful views plus a clear explanation of what was intentionally omitted.