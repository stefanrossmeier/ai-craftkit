# PyJWT ADR discovery example

This folder contains example output generated for the public `pyjwt` repository using the `adrgen` skill from `ai-craftkit`.

The purpose of this example is to show how the skill can inspect an existing codebase and identify architectural decision candidates that may be worth documenting as ADRs.

## Source repository

The documentation in this folder is based on the public PyJWT repository:

```text id="htc686"
https://github.com/jpadilla/pyjwt
```

PyJWT is a Python library for working with JSON Web Tokens. It contains visible architectural choices around public API design, JWT and JWS separation, algorithm handling, validation behavior, exceptions, packaging, testing, and JWKS support.

## Skill used

This example uses:

```text id="s6ynts"
skills/adrgen/SKILL.md
```

The `adrgen` skill is designed to discover architectural decisions from repository evidence and prepare reviewable decision candidates.

## Prompt used

The prompt used for this example was intentionally short:

```text id="mlt4tw"
/adrgen discover the repo pyjwt
```

This prompt asks the skill to inspect the repository and discover decisions instead of generating ADRs from a predefined list.

## Generated file

This run produced a single discovery file:

```text id="3x5lxh"
ADR_CANDIDATES.md
```

The file contains a list of architectural decision candidates discovered from the PyJWT repository.

It should be treated as **discovery output**, not as accepted project history. The candidates may describe visible design choices, but they still require human review before being turned into formal ADRs.

## What the skill looks for

When run against a repository like PyJWT, `adrgen` may identify decision candidates from evidence such as:

* public API structure
* module boundaries
* dependency choices
* packaging configuration
* test structure
* error handling patterns
* supported algorithms
* validation behavior
* documentation conventions
* security-relevant implementation choices

The skill should prefer repository evidence over assumptions. If the repository does not prove that a decision was formally accepted, the output should mark it as a candidate or discovered decision rather than an accepted ADR.

## How to review `ADR_CANDIDATES.md`

Review each candidate with these questions:

* Is the decision actually visible in the repository?
* Does the candidate describe enough evidence?
* Is the status justified?
* Is the context specific to PyJWT?
* Are consequences concrete?
* Are assumptions clearly marked?
* Would this help a future maintainer?
* Is this useful documentation, or only a restatement of code?

A good candidate should explain why a design choice matters, not only that the choice exists.

## Expected value

This example demonstrates how `adrgen` can help with a common documentation problem: important architectural decisions often exist in code long before they exist in documentation.

The skill can help create a first inventory of those decisions. A human reviewer still needs to decide which candidates should become accepted ADRs, which should remain open questions, and which should be discarded.

## Limitations

This output should not be read as official PyJWT documentation.

It is an external documentation exercise created from repository inspection. Some decisions may be inferred from code structure rather than confirmed by maintainers. Those cases should remain clearly marked as inferred or candidate decisions.

## Suggested workflow

A useful workflow for this example is:

1. Run `adrgen` against the PyJWT repository.
2. Store the generated `ADR_CANDIDATES.md` file in this folder.
3. Review each candidate against the source code.
4. Keep strong candidates as documentation or convert them into formal ADR files.
5. Mark weak or speculative candidates as open questions.
6. Use `archdoc` or `mermaiddoc` to add supporting architecture context where helpful.

## Notes

The short prompt is intentional.

It demonstrates that the skill carries the workflow guidance. The user does not need to write a long prompt to get structured ADR discovery behavior.
