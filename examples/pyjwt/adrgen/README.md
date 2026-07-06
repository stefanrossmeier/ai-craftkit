# PyJWT ADR discovery example

This folder contains example ADR discovery output generated for the public `pyjwt` repository using the `adrgen` skill from `ai-craftkit`.

The example is meant to show the current output shape of the skill in `discover` mode: a reviewable ADR index plus an `ADR_CANDIDATES.md` funnel that captures evidence-backed decision candidates before any final ADRs are generated.

## Source repository

The documentation in this folder is based on the public PyJWT repository:

```text
https://github.com/jpadilla/pyjwt
```

PyJWT is a useful example target because it is a focused Python library with clear public APIs, explicit JWT and JWS layering, optional cryptography support, JWK and JWKS handling, tests, packaging metadata, and security-relevant validation behavior.

## Skill used

This example uses:

```text
skills/adrgen/SKILL.md
```

The current `adrgen` skill supports four modes:

```text
/adrgen discover
/adrgen generate
/adrgen capture
/adrgen prepare
```

This checked-in example specifically demonstrates `discover` mode.

## Generated output

The live skill writes discover-mode output to the target repository's `docs/adr/` directory.

For this checked-in example, that generated output is stored locally under:

```text
adr/README.md
adr/ADR_CANDIDATES.md
```

The responsibility split is:

* `adr/README.md`: ADR index for the run, including status legend, candidate document listing, and agent guidance
* `adr/ADR_CANDIDATES.md`: reviewable list of discovered decision candidates, evidence tables, open questions, and suggested next steps

At the moment, this example contains discovery output only. It does not include generated ADR drafts or accepted ADRs.

## What this checked-in example reflects

The generated files in `adr/` reflect the current skill conventions rather than an older single-file format. In particular, they now include:

* a lightweight provenance block near the top of each generated document
* update metadata such as review scope, doc status, timestamp, updater, and source basis
* an ADR index file in addition to `ADR_CANDIDATES.md`
* candidate summary and per-candidate review fields such as `Candidate Status`, `Generate ADR`, `Suggested ADR`, and `Generated ADR`
* explicit handling of `verified`, `inferred`, and `missing` evidence states where useful

The checked-in PyJWT docs are intentionally a discovery pass, not official project documentation.

## Prompt and provenance

The exact prompt used for the checked-in example is recorded inside the generated files themselves in the provenance block at the top of `adr/README.md` and `adr/ADR_CANDIDATES.md`.

That is the current source of truth for the example run, because the skill now requires generated ADR-related documents to preserve directly available provenance instead of reconstructing it later in this README.

## What the skill looks for

When run against a repository like PyJWT, `adrgen discover` may identify candidate decisions from evidence such as:

* public API structure
* module boundaries and layering
* dependency and packaging choices
* key handling and algorithm support
* validation defaults and strictness options
* JWK and JWKS integration behavior
* security-relevant implementation choices
* tests and documentation that reinforce architectural boundaries

The current PyJWT example surfaces candidates around:

* separation of JWS processing from JWT claim validation
* optional `cryptography` support via `pyjwt[crypto]`
* explicit decode-time algorithm allow-lists and key-family safety checks
* first-class JWK and JWKS abstractions
* conservative built-in JWKS client behavior
* extension seams for custom algorithms and payload handling
* standards-driven claim validation with opt-out controls

The skill should prefer repository evidence over assumptions. If the repository does not prove that a decision was formally accepted, the output should remain a candidate and should not be presented as accepted history.

## How to review the output

Review the generated candidate set with these questions:

* Does each candidate describe a real architectural choice rather than a local implementation detail?
* Is the evidence concrete and specific to PyJWT?
* Are important claims marked as verified, inferred, or missing appropriately?
* Are the consequences and trade-offs useful to a future maintainer or agent?
* Do the suggested ADR filenames and next steps make sense?
* Is anything overstated as accepted when it should still be treated as a review candidate?

A good `adrgen discover` result should help a human decide which choices deserve formal ADRs, not just restate the codebase in prose.

## Expected value

This example demonstrates how `adrgen` can help with a common documentation problem: important architectural decisions often exist in code long before they exist in decision records.

The discovery pass creates a review funnel first. A human reviewer can then decide which candidates should become formal ADR drafts, which should remain open questions, and which should be rejected or merged.

## Limitations

This output should not be read as official PyJWT documentation.

It is an external documentation exercise based on repository inspection. Some rationale is necessarily inferred from code, tests, and docs rather than confirmed by project maintainers. The skill should make those cases visible instead of presenting them as settled project history.

## Suggested workflow

1. Run `adrgen discover` against the target repository.
2. Store the generated `docs/adr/` output in this example folder.
3. Review `adr/ADR_CANDIDATES.md` against the source code and existing project docs.
4. Mark strong candidates with `Candidate Status: ready` or `approved` and `Generate ADR: yes`.
5. Run `adrgen generate` to turn selected candidates into ADR drafts.
6. Review the generated ADRs before changing any `Decision Status` to `ACCEPTED`.
7. Use `archdoc` or `mermaiddoc` to add supporting architecture context where helpful.

## Notes

This example is intentionally useful even though PyJWT is a library rather than a service.

It shows that `adrgen` should adapt to a library-shaped repository, focus on real design decisions such as security boundaries and API layering, and produce a reviewable ADR candidate funnel instead of inventing operational architecture that is not present.
