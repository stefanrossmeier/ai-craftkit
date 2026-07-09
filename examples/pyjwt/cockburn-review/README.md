# PyJWT Cockburn boundary review example

This folder contains example boundary review output generated for the public `pyjwt` repository using the `cockburn-review` skill from `ai-craftkit`.

The example is meant to show the current output shape of the skill: one evidence-rich architectural review that focuses on responsibility drift, knowledge leakage, and future changes that look harder than they should be.

## Source repository

The documentation in this folder is based on the public PyJWT repository:

```text
https://github.com/jpadilla/pyjwt
```

PyJWT is a useful example target because it is a focused Python library with clear public APIs, layered JWT and JWS behavior, optional remote-key integration, tests, packaging metadata, and a small enough codebase to review carefully.

## Skill used

This example uses:

```text
skills/cockburn-review/SKILL.md
```

The `cockburn-review` skill inspects a repository with a Cockburn-inspired lens:

* **Not my job**: a component may be doing work that belongs elsewhere
* **No need to know**: a component may know implementation details that should stay behind a boundary

## Generated output

The live skill writes its generated report to the target repository's `docs/` directory.

For this checked-in example, that generated output is stored locally as:

```text
COCKBURN_REVIEW.md
```

The single report is expected to carry:

* a lightweight provenance block near the top
* review scope and update metadata
* an executive summary of the main architectural pressure points
* evidence-backed findings with severity, confidence, and suggested moves
* change-stress scenarios and improvement guidance where useful

## What this checked-in example reflects

The generated review reflects the current skill conventions rather than an older lightweight notes format. In particular, it includes:

* direct repository evidence for each top finding
* explicit `verified`, `inferred`, `uncertain`, and `missing` language where useful
* Cockburn framing for each major issue
* a pragmatic focus on change amplification instead of style policing

The checked-in PyJWT review is intentionally a draft-quality architecture critique, not official project documentation.

## Prompt and provenance

The exact prompt used for the checked-in example is recorded inside `COCKBURN_REVIEW.md` itself in the provenance block at the top of the document.

That is the current source of truth for the example run, because the skill now requires generated reports to preserve directly available provenance rather than reconstructing it later in this README.

## What the skill looks for

When run against a repository like PyJWT, `cockburn-review` may inspect evidence such as:

* public API exports
* module boundaries and import direction
* integration classes and helper surfaces
* tests that reveal boundary expectations
* caching, configuration, and extension seams
* places where one class or module owns multiple change axes

In the current PyJWT example, the strongest findings center on shared mutable algorithm registration, responsibility concentration in the JWKS client path, and silent loss of upstream key-quality information.

## How to review the output

Review the generated report with these questions:

* Does each finding cite concrete repository evidence?
* Are the Cockburn interpretations specific and defensible rather than generic?
* Are the suggested moves proportionate to the actual problem?
* Does the report separate important architectural pressure from small local smells?
* Would a maintainer recognize the trade-offs being described?

A good `cockburn-review` result should feel like a careful architectural critique, not a style checklist.

## Expected value

This example demonstrates how `cockburn-review` can turn repository inspection into a reviewable architecture critique.

The result can help with:

* preparing refactoring work around boundaries
* identifying shared mutable state or responsibility concentration
* stress-testing architecture against future changes
* creating evidence-backed input for ADRs or architecture discussions

## Limitations

This output should not be read as official PyJWT documentation.

It is an external documentation exercise based on repository inspection. Architectural interpretation is necessarily a human review surface, not final project truth. The skill should make that visible by grounding findings in evidence and marking uncertainty when needed.

## Suggested workflow

1. Run `archdoc` first if the repository is unfamiliar.
2. Run `cockburn-review` to challenge the current boundaries.
3. Review the findings against source code and tests.
4. Use `adrgen` to capture decisions or trade-offs worth preserving.
5. Use `mermaiddoc` or `c4doc` when a visual explanation will help.

## Notes

This example is useful because PyJWT is small enough to inspect carefully but still contains real architectural seams. It shows that `cockburn-review` can produce meaningful results for a library repository without inventing service boundaries or operational architecture that are not present.