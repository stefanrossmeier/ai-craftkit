# Skills

This folder contains reusable AI agent skills for software engineering workflows.

Each skill is written as a `SKILL.md` file. A skill defines how an AI assistant should approach a specific task, what output it should produce, and which quality rules it should follow.

The goal is repeatable behavior. A good skill should make AI output more structured, more reviewable, and less dependent on one-off prompting.

## Available skills

| Skill        | Purpose                                             | Best used for                                                         |
| ------------ | --------------------------------------------------- | --------------------------------------------------------------------- |
| `archdoc`    | Architecture documentation from repository evidence | Architecture overviews, onboarding docs, repository discovery         |
| `adrgen`     | ADR discovery and draft generation                  | Capturing architectural decisions and decision candidates             |
| `mermaiddoc` | Practical Mermaid diagram generation                | Flowcharts, sequence diagrams, component diagrams, data flow diagrams |

## Skill design principles

The skills in this repository follow a few shared principles.

### Evidence first

Generated documentation should be grounded in repository evidence.

A skill should guide the AI assistant to inspect files, folder structure, configuration, dependencies, scripts, tests, documentation, and naming conventions before writing conclusions.

When evidence is weak, the output should say so.

### Explicit uncertainty

AI-generated documentation becomes risky when uncertainty is hidden.

Skills should make the difference clear between:

* verified facts
* reasonable inferences
* uncertain findings
* missing information

This is especially important for architecture documentation and ADR generation.

### Reviewable output

The output should help a human reviewer.

That means short sections, clear structure, concrete claims, and visible assumptions. Long generic explanations are less useful than compact findings with evidence and open questions.

### Practical diagrams

Mermaid diagrams should be small enough to read and simple enough to render.

A diagram that looks clever but fails in GitHub is not useful. The `mermaiddoc` skill favors simple syntax, stable node IDs, short labels, and direct relationships.

### Human ownership

The skills can prepare documentation, diagrams, and ADR drafts. They should not silently turn uncertain findings into final architectural truth.

Humans still own the final interpretation and approval.

## `archdoc`

`archdoc` guides an AI assistant through repository inspection and architecture documentation.

It is useful when you want to understand how a codebase is structured, where the main components are, and how the system appears to work.

Typical outputs include:

* architecture overview
* component map
* repository structure summary
* runtime or deployment observations
* data flow notes
* dependency observations
* uncertainty and missing information

Use `archdoc` when:

* onboarding to an unfamiliar repository
* preparing architecture documentation
* reviewing a codebase before modernization
* creating technical context for developers
* documenting a system before deeper refactoring

Avoid using `archdoc` to invent architecture that is not visible in the repository.

## `adrgen`

`adrgen` helps discover and prepare Architecture Decision Records.

It looks for architectural decisions that are visible in the repository. Examples include framework choices, dependency choices, persistence decisions, communication patterns, deployment decisions, folder structure conventions, and testing approaches.

Typical outputs include:

* ADR candidates
* reviewable ADR drafts
* decision context
* observed consequences
* evidence references
* open questions

Use `adrgen` when:

* a project has implicit decisions that should be documented
* architecture choices are visible in code but missing from documentation
* a team wants to create ADRs after decisions were already made
* a reviewer needs to distinguish accepted decisions from weak assumptions

The skill should be careful with status. If the repository does not prove that a decision was formally accepted, the output should use candidate or proposed status.

## `mermaiddoc`

`mermaiddoc` helps create GitHub-compatible Mermaid diagrams.

It focuses on practical diagrams that explain structure or behavior without unnecessary complexity.

Typical outputs include:

* flowcharts
* sequence diagrams
* component diagrams
* data flow diagrams
* startup or processing sequences
* simplified system maps

Use `mermaiddoc` when:

* text alone is hard to understand
* a repository needs a visual overview
* a sequence of calls or events should be explained
* a system has clear components and relationships
* documentation should render directly in GitHub

The skill should avoid oversized diagrams, decorative styling, fragile syntax, and labels that make diagrams unreadable.

## How to use a skill

Reference the skill directly in your AI assistant prompt.

Example:

```text
Use the archdoc skill.

Inspect this repository and create an architecture overview.
Separate verified facts, inferred conclusions, uncertain findings, and missing information.
Keep the output concise and reviewable.
```

Example:

```text
Use the adrgen skill.

Inspect this repository and identify architectural decision candidates.
Create ADR drafts only where the evidence is strong enough.
Mark uncertain decisions as candidates and list the missing evidence.
```

Example:

```text
Use the mermaiddoc skill.

Create a Mermaid sequence diagram for the startup and data processing flow.
Use GitHub-compatible syntax, short labels, and stable node names.
```

## Recommended workflow

A useful documentation workflow is:

1. Run `archdoc` to understand the repository.
2. Use `mermaiddoc` to visualize the main structure or flows.
3. Use `adrgen` to capture architectural decisions that are visible in the codebase.
4. Review all generated output manually.
5. Commit only the parts that are accurate, useful, and maintainable.

## Quality checklist

Before accepting AI-generated output from a skill, check the following:

* Does it reference actual repository evidence?
* Are assumptions clearly marked?
* Is missing information visible?
* Is the output specific to this repository?
* Can another developer review it quickly?
* Are diagrams small and readable?
* Does Mermaid syntax render in GitHub?
* Are ADR statuses justified by evidence?
* Would this documentation still be useful in three months?

## Adding a new skill

A new skill should include:

* a clear purpose
* when to use it
* when to avoid it
* expected inputs
* expected outputs
* step-by-step behavior
* quality rules
* failure modes
* examples where useful

A skill should solve a recurring engineering workflow problem. Avoid adding prompts that are too generic or only useful once.

## Current maturity

These skills are early and evolving.

They are intended to be useful today as reusable AI assistant instructions. Over time, they may become part of a more structured toolkit with examples, validation, and packaging.
