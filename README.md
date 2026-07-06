# ai-craftkit

Reusable AI agent skills for evidence-based repository documentation, architecture mapping, ADR capture, and Mermaid diagrams.

AI agents can move quickly through a codebase, but speed alone is not useful when the output is vague, overconfident, or hard to review. This repository collects practical skill definitions that guide an AI assistant toward structured, evidence-based engineering work.

The focus is currently on software architecture documentation and repository understanding. The skills are written for use with AI coding assistants, agent workflows, or prompt-based development setups where repeatable behavior matters.

## What this repository contains

`ai-craftkit` is an early collection of reusable skills and supporting examples.

Current focus areas:

| Area                         | Purpose                                                                 |
| ---------------------------- | ----------------------------------------------------------------------- |
| Architecture documentation   | Inspect a repository and produce grounded architecture documentation.   |
| ADR generation               | Identify architectural decisions and prepare reviewable ADR candidates. |
| Mermaid diagrams             | Create small, readable, GitHub-compatible Mermaid diagrams.             |
| Developer workflow utilities | Small scripts and examples that support day-to-day repository work.     |

The repository is intentionally lightweight. It is currently a collection of skill definitions, documentation patterns, and examples. It is not packaged as a CLI or framework yet.

## Why this exists

AI-assisted development creates a new documentation problem.

A human can usually tell when a generated explanation is weak, but teams need stronger guardrails when AI output becomes part of engineering workflows. Architecture documents, ADRs, and diagrams should be grounded in repository evidence. They should also make uncertainty visible.

The skills in this repository are designed around a few principles:

* Prefer evidence over confident guesses.
* Separate verified facts from inferred conclusions.
* Keep generated documentation reviewable by humans.
* Use small, practical outputs over large, decorative documents.
* Make diagrams simple enough to render reliably in GitHub.
* Treat missing information as useful information.

## Repository structure

Typical layout:

```text
ai-craftkit/
├── README.md
├── skills/
│   ├── README.md
│   ├── archdoc/
│   │   └── SKILL.md
│   ├── adrgen/
│   │   └── SKILL.md
│   └── mermaiddoc/
│       └── SKILL.md
├── examples/
│   └── ...
└── scripts/
    └── ...
```

The exact structure may evolve as the repository grows.

## Skills

### `archdoc`

Creates architecture documentation from a repository inspection.

The skill guides an AI assistant to inspect files, identify system boundaries, describe components, and separate verified findings from assumptions. Its canonical outputs are `REPO_MAP.md`, `ARCHITECTURE.md`, `API_SURFACE.md`, and `OPERATIONS.md`.

`API_SURFACE.md` is the detailed contract document for public and integration-relevant interfaces. `ARCHITECTURE.md` stays focused on static structure and high-level interface ownership, while `OPERATIONS.md` stays focused on runtime behavior, verification, and failure handling.

Use it when you want an AI assistant to explain how a codebase is structured without pretending to know more than the repository proves.

### `adrgen`

Generates ADR candidates from repository evidence.

The skill helps identify decisions that are already visible in the codebase, configuration, dependencies, deployment setup, or documentation. It can prepare ADR drafts, but it should not silently mark weakly supported assumptions as accepted decisions.

Use it when a repository contains architectural choices that should be captured, reviewed, and made explicit.

### `mermaiddoc`

Creates practical Mermaid diagrams.

The skill focuses on diagrams that are small, readable, and compatible with GitHub rendering. It includes guidance for flowcharts, sequence diagrams, component diagrams, labels, node IDs, and common Mermaid pitfalls.

Use it when documentation needs a visual explanation of structure, flow, or interaction.

## How to use

These skills are meant to be referenced by an AI assistant or copied into an agent setup.

A typical prompt looks like this:

```text
Use the archdoc skill from ai-craftkit.

Inspect this repository and create a concise architecture overview.
Mark each claim as verified, inferred, uncertain, or missing.
Prefer repository evidence over assumptions.
```

For ADR discovery:

```text
Use the adrgen skill from ai-craftkit.

Inspect this repository and identify architectural decision candidates.
Create reviewable ADR drafts only where the repository provides enough evidence.
Mark weak findings as candidates, not accepted decisions.
```

For diagrams:

```text
Use the mermaiddoc skill from ai-craftkit.

Create a GitHub-compatible Mermaid diagram that shows the main components
and the data flow between them. Keep the diagram small and readable.
```

## Example use cases

This repository is useful for:

* creating a first architecture overview of an unfamiliar repository
* documenting the main components of an application
* generating onboarding material for developers
* preparing ADR candidates from existing code
* turning repository structure into Mermaid diagrams
* creating consistent documentation prompts for AI-assisted workflows
* making AI-generated documentation easier to review

## Output style

The skills favor practical engineering documentation.

Good output should be:

* specific
* traceable to repository evidence
* explicit about uncertainty
* readable by developers and architects
* small enough to review
* easy to maintain

Poor output should be rejected when it is:

* generic
* speculative
* too broad
* visually overdesigned
* disconnected from the repository
* missing clear evidence

## Status

This repository is early and experimental.

The current goal is to collect and refine reusable skill definitions for AI-assisted software engineering work. The repository is useful as a prompt and documentation toolkit today, but it is not yet a complete product.

Planned improvements include:

* more complete examples
* before-and-after documentation samples
* stronger usage documentation
* validation checklists
* possible packaging for easier reuse
* more skills for common engineering workflows

## Limitations

These skills do not replace architectural judgment.

They help structure AI-assisted work, but the generated output still needs human review. A repository may also lack enough evidence to support a confident architecture document or ADR. In that case, the right result is to state what is missing.

The skills are especially useful when teams want AI support without losing engineering discipline.

## Contributing

Contributions are welcome when they improve practical usefulness.

Good contributions include:

* clearer skill instructions
* better examples
* realistic documentation outputs
* safer evidence handling
* Mermaid diagrams that render reliably
* workflow scripts with clear usage instructions

Please avoid adding generic prompts. The goal is reusable engineering guidance that produces reviewable output.

## License

See the repository license for usage terms.
