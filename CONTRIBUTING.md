# Contributing

Thank you for considering a contribution to `ai-craftkit`.

This repository contains reusable skills, templates, and examples for AI-assisted software engineering workflows. Contributions should make those workflows more useful, safer, clearer, or easier to apply in real repositories.

## Project Principles

Contributions should follow the core style of this project:

* Prefer practical workflows over generic prompt text.
* Use repository evidence instead of guesses.
* Mark uncertainty clearly.
* Keep generated documentation useful for both humans and agents.
* Avoid unnecessary command options or fake CLI complexity.
* Keep templates readable and maintainable.
* Avoid bloated output.
* Do not expose secrets or encourage unsafe repository inspection.

The goal is not to collect prompts. The goal is to build small, reusable engineering skills that produce useful artifacts.

## Repository Structure

Important areas:

```text
skills/
  archdoc/
  adrgen/
  mermaiddoc/

examples/
README.md
LICENSE
CONTRIBUTING.md
```

Each skill should usually contain:

```text
SKILL.md
README.md
templates/
```

Examples should go into:

```text
examples/
```

## Adding or Changing a Skill

A good skill should have a clear purpose and a small number of meaningful workflows.

When adding or changing a skill, check that it includes:

* a clear command name
* a concrete purpose
* expected inputs
* generated outputs
* repository inspection rules, if needed
* safety rules
* evidence and uncertainty rules
* template handling rules, if templates are used
* completion report expectations
* failure handling
* non-goals

Avoid adding many command-line-like options unless they represent real, important workflows.

Good:

```text
/adrgen discover
/adrgen generate
/adrgen capture
/adrgen prepare
```

Avoid:

```text
/skill --dry-run
/skill --no-run
/skill --scope full
/skill --focus src/auth
/skill --ids CAND-001,CAND-002
```

Skills should read like instructions for a capable AI agent, not like a CLI manual with unsupported switches.

## Templates

Templates should be specific enough to guide useful output, but not so rigid that generated documents look like empty forms.

Templates should:

* include clear headings
* explain the purpose of the document
* include evidence labels where relevant
* distinguish verified, inferred, uncertain, and missing information
* include agent guidance when useful
* avoid placeholder-heavy final output
* avoid generic boilerplate

Generated documents should not leave unresolved placeholders such as:

```text
[Describe ...]
[Insert ...]
[path]
[command]
[verified/inferred]
```

If information is missing, the generated document should state the gap clearly.

## Evidence and Uncertainty

Use these evidence labels consistently:

```text
verified
inferred
uncertain
missing
```

Definitions:

* `verified`: directly confirmed from code, config, tests, documentation, local execution, or explicit human input.
* `inferred`: likely true based on naming, imports, structure, repeated patterns, or partial evidence.
* `uncertain`: plausible but not sufficiently supported.
* `missing`: expected information was searched for but not found.

Do not present inferred rationale as verified history.

Do not invent original intent.

Do not hide missing information.

## Safety Rules

Skills that inspect repositories should start with safe read-only inspection.

Do not encourage agents to:

* print secret values
* read sensitive files in full
* install dependencies by default
* start servers by default
* run Docker by default
* run deployment commands
* modify application source code unless the skill is explicitly about code changes
* perform destructive operations

Sensitive files should not be copied into generated documentation.

Examples:

```text
.env
.env.*
*.pem
*.key
*.crt
id_rsa
id_ed25519
secrets.*
credentials.*
```

It is fine to document that such a file exists if that is relevant, but do not copy its values.

## Documentation Style

Use plain, direct Markdown.

Keep documentation:

* concise
* concrete
* practical
* easy to scan
* consistent with existing skill files
* useful for future maintainers
* useful for coding agents

Avoid:

* marketing language
* vague claims
* unnecessary abstractions
* long option lists
* decorative diagrams
* large generated examples with little signal

## Mermaid Diagrams

Mermaid diagrams should render directly in GitHub Markdown.

Prefer:

```text
flowchart LR
sequenceDiagram
```

Diagrams should be small, readable, and focused.

Use `docs/diagrams/` for generated diagram documentation.

Avoid custom CSS, theme blocks, or layout tricks that may render poorly on GitHub.

## Examples

Examples are welcome when they help users understand what a skill produces.

Good examples should:

* be easy to find
* show realistic output
* be small enough to read
* follow the skill’s own rules
* avoid fake complexity
* avoid secrets or real credentials

Place examples under:

```text
examples/
```

## Pull Request Checklist

Before opening a pull request, check:

* The changed skill still has a clear purpose.
* The generated outputs are named consistently.
* Templates and `SKILL.md` agree with each other.
* README files reference the current behavior.
* Removed or renamed files are not still referenced.
* Markdown code fences are valid.
* Examples match the current skill behavior.
* No secrets or private data are included.
* The contribution avoids unnecessary command options.
* Evidence and uncertainty rules are preserved.

## Commit Scope

Prefer small, focused changes.

Good pull requests:

* add one new skill
* improve one existing skill
* update one template family
* add examples for one skill
* clean up one documentation inconsistency

Avoid large mixed changes unless they are needed for consistency.

## Reporting Issues

When opening an issue, include:

* which skill or template is affected
* what you expected
* what happened instead
* an example input, if possible
* the generated output, if relevant
* why the current behavior is confusing, unsafe, or incomplete

## License

By contributing, you agree that your contribution will be licensed under the repository license.
