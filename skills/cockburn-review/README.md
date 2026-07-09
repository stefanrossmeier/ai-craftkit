# Cockburn Review

`cockburn-review` is an evidence-based architectural boundary review skill for `ai-craftkit`.

## Command

```text
/cockburn-review
```

This is a skill invocation for VS Code / agent workflows, not a shell command. It has no command-line parameters, flags, modes, or options.

When a caller wants a narrower review, they should write that request in normal text after invoking the skill. The skill should interpret that text as guidance, not as parsed command syntax.

Examples:

```text
/cockburn-review
```

```text
/cockburn-review Please focus on billing, payment, and notification boundaries.
```

```text
/cockburn-review Review the current repository and pay special attention to whether domain logic knows infrastructure details.
```

## Inspiration

This skill is inspired by Alistair Cockburn's "not my job" and "no need to know" discussions.

The review treats modules, packages, services, components, classes, and folders as architectural roles. A healthy role should be able to say:

- **Not my job**: this responsibility belongs somewhere else.
- **No need to know**: this implementation detail should be hidden behind a boundary.

The skill uses that lens to discover architectural weaknesses such as responsibility drift, knowledge leakage, boundary bypasses, semantic duplication, utility sinkholes, and change-amplifying dependencies.

## Primary Output

The skill generates or updates one repository-local Markdown report:

```text
docs/COCKBURN_REVIEW.md
```

The report is based on the template stored inside the skill package:

```text
templates/COCKBURN_REVIEW.template.md
```

The final report must not look like an unfilled template. The skill should remove placeholder-only sections, unused example rows, empty tables, and unresolved bracket placeholders before writing the final file.

## Evidence Requirement

Every architectural claim in `docs/COCKBURN_REVIEW.md` must be supported by evidence from the repository under investigation.

Acceptable evidence includes:

- source files
- imports and dependency direction
- call chains
- public exports
- tests and test setup
- configuration files
- manifests and package scripts
- existing documentation
- local read-only command output
- observed file and folder structure

A finding without concrete repository evidence must not be reported as a finding. If the skill suspects a weakness but cannot support it, it should either omit it or list it under an explicit "insufficient evidence" section.

## What the Report Should Answer

The report should help future humans and agents understand:

- which architectural roles the repository appears to contain
- where responsibilities appear to be misplaced
- where code appears to know details it should not need
- where boundaries are bypassed or unclear
- which future changes may become unnecessarily hard
- which findings are well supported versus tentative
- which improvements are worth doing now, watching, or accepting as trade-offs

## Review Style

The skill should be pragmatic and non-dogmatic.

It must not enforce Clean Architecture, DDD, hexagonal architecture, microservices, or any other style unless the repository itself provides evidence that such a style is intended.

The report should separate:

1. observed facts from the repository
2. architectural interpretation
3. Cockburn framing
4. change risk
5. suggested moves
6. what not to over-fix

## Safety

The skill should start with safe read-only inspection.

It must not:

- modify application source code
- install dependencies unless explicitly asked
- start servers unless explicitly asked
- run Docker unless explicitly asked
- deploy anything
- copy secret values into the report
- treat missing evidence as proof of a problem

It may create the `docs/` directory and write `docs/COCKBURN_REVIEW.md`.
