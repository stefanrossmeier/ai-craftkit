---
name: glossary
description: Discover and document repository-specific business and domain language from a Domain-Driven Design perspective. Use when asked to identify ubiquitous language, domain terminology, bounded-context vocabulary, ambiguous business terms, or to create or refresh docs/GLOSSARY.md.
license: Apache-2.0
---

# Glossary Skill

Command: `/glossary`

Identify the repository's domain-specific language and create an evidence-based glossary from a Domain-Driven Design perspective.

The skill focuses on the language of the problem domain: business concepts, actors, rules, events, states, processes, classifications, measures, and artifacts. It deliberately excludes ordinary software-engineering vocabulary unless a technical-looking term has a specific meaning in the domain.

## Invocation Model

Use this skill when the user calls:

```text
/glossary
```

This is a skill invocation, not a shell command.

It has no command-line flags, parameters, modes, or options. If the user adds text after the invocation, treat it as plain-language scoping guidance.

Examples:

```text
/glossary

/glossary focus on the claims workflow

/glossary inspect only the reserving and settlement areas

/glossary refresh the existing glossary and highlight terminology drift
```

Do not document or advertise flag-based usage.

## Purpose

Generate or update:

```text
docs/GLOSSARY.md
```

The document should help developers, architects, analysts, testers, product experts, and future agents use the repository's domain language consistently.

The skill should:

- identify terms that carry domain meaning
- explain those terms in plain business language
- connect definitions to repository evidence
- group terms by candidate bounded context when useful
- expose inconsistent, ambiguous, overloaded, or competing terminology
- distinguish observed language from domain-expert-approved language
- identify important domain concepts whose meaning cannot be recovered from the repository
- avoid filling the glossary with frameworks, infrastructure, and implementation jargon

A repository can reveal language that is encoded in software. It cannot, by itself, prove that this language is accepted by domain experts or used consistently in real conversations.

Therefore, treat the result as an **observed or candidate ubiquitous language** until a knowledgeable human reviews it.

## DDD Interpretation

Use the Domain-Driven Design meaning of ubiquitous language:

- it is a shared, rigorous language used by developers and domain experts
- it is based on the domain model
- it should appear consistently in conversation, documentation, tests, and code
- it should evolve as the team's understanding improves
- ambiguity and inconsistency are findings, not details to hide

Do not reduce ubiquitous language to a list of class names.

The glossary should explain the model expressed by the repository, not merely inventory identifiers.

## Required Output File

Generate or update exactly this primary document:

```text
docs/GLOSSARY.md
```

Create `docs/` if it does not exist.

Do not place the generated glossary outside `docs/`.

Do not modify application source code.

Do not rename domain concepts in code.

Do not modify unrelated documentation unless the user explicitly asks.

## Template Location

Use the bundled template as the conceptual source:

```text
templates/GLOSSARY.template.md
```

The template lives inside this skill package.

Adapt the template to the repository under inspection. The final `docs/GLOSSARY.md` must not look like an unfilled template.

Before writing the final document:

1. Fill sections with repository-specific findings.
2. Delete placeholder-only sections.
3. Delete irrelevant sections.
4. Delete empty tables.
5. Delete unused example rows.
6. Delete unresolved bracket placeholders.
7. Keep unknowns only when they help a reviewer.
8. Prefer a compact, evidence-rich glossary over a large vocabulary dump.

## Lightweight Provenance Block

Place a small provenance block directly after the title.

Include only information that is directly available. Do not invent missing metadata.

Use:

```markdown
> Generated with `ai-craftkit` skill: `glossary`
> Source: `<repository-url>` at commit `<commit-hash>`
> Prompt: `<exact-user-prompt>`
```

If the repository URL or commit hash cannot be determined, write `unknown`.

## Document Status Fields

Place these fields after the provenance block:

```markdown
Last Reviewed Scope: [full review | delta update | targeted area]
Doc Status: [MAINTAINED | DRAFT | NEEDS REVIEW]
Last Glossary Update: [YYYY-MM-DDTHH:MM:SSZ]
Updated By: [human | agent | human+agent]
Source Basis: [docs scan | code scan | tests scan | UI text | schemas | other]
Domain Expert Review: [NOT REVIEWED | PARTIAL | CONFIRMED]
```

Rules:

- Use `DRAFT` when the glossary is newly generated from repository inspection.
- Use `NEEDS REVIEW` when important meanings are inferred, disputed, or incomplete.
- Use `MAINTAINED` only when the file is already established, evidence is current, and important definitions appear complete.
- Never set `Domain Expert Review` to `CONFIRMED` unless the repository or user explicitly proves that review occurred.
- Use UTC timestamps.

## Core Principles

### Domain meaning over implementation shape

A definition must explain what a term means in the domain.

Good:

```text
Reserve: an estimate of the amount expected to be required to settle an obligation.
```

Poor:

```text
Reserve: a class in src/models/reserve.py with an amount field.
```

Repository paths belong in evidence, not in the business definition.

### Context before global consistency

The same word can have different meanings in different bounded contexts.

Do not merge terms merely because they share a spelling.

Do not assume that a folder, package, microservice, database, or deployable unit is automatically a bounded context.

Use labels such as `candidate context` or `inferred context` when the boundary is not explicit.

### Evidence before confidence

Every included term should have locatable repository evidence.

Repeated usage is stronger than a single isolated identifier.

Behavior, tests, rules, transitions, examples, and user-facing wording are stronger than filenames alone.

### Language tensions are valuable findings

Do not silently choose one word when the repository uses competing terms.

Expose:

- synonyms used for the same concept
- one term used for different concepts
- abbreviations with unclear meanings
- legacy and current names
- technical names leaking into business-facing language
- business concepts represented with inconsistent names across layers
- code concepts that have no discoverable domain definition

### Human ownership

The skill discovers and organizes candidate language.

Domain experts and maintainers own the final meaning and preferred terminology.

Do not present inferred definitions as organizational truth.

## What Counts as a Domain Term

Include a term when repository evidence indicates that it names a concept important to the problem being solved.

Strong candidates include:

- business actors and roles
- business objects and records
- products, contracts, agreements, and obligations
- domain events
- business commands or intentions
- lifecycle states and transitions
- policies, eligibility rules, limits, and constraints
- calculations and business measures
- processes and workflow stages
- classifications and categories
- domain-specific time periods
- money concepts and accounting concepts
- business documents and artifacts
- exceptions with domain significance
- terms that distinguish this domain from ordinary software projects

A useful test is:

```text
Would a knowledgeable person need this term to explain why the system behaves as it does?
```

Another useful test is:

```text
Would changing the meaning of this term change business behavior, rules, or decisions?
```

## What Does Not Count by Default

Exclude ordinary technical vocabulary such as:

```text
API
adapter
cache
class
client
config
controller
cron
database
DTO
endpoint
entity framework
enum
event bus
factory
handler
HTTP
ID
JSON
manager
message broker
microservice
middleware
model
module
queue
repository
request
response
schema
serializer
service
table
UUID
worker
```

Also exclude:

- programming language names
- framework and library names
- infrastructure products
- generic CRUD terms
- generated identifiers
- vendored vocabulary
- test framework vocabulary
- file-format terminology with no special domain meaning
- generic suffixes such as `Manager`, `Helper`, `Util`, or `Processor`
- database table and column names that merely mirror implementation structure

Exceptions are allowed when a normally technical word has a specific domain meaning.

Examples:

- `Policy` may be an insurance contract rather than a software policy object.
- `Claim` may be a request for indemnification rather than an assertion.
- `Order` may be a customer purchase, a trading instruction, or a court directive.
- `Settlement` may be a business process rather than a technical completion state.

When including such a term, define the domain meaning and make the context explicit.

## Domain Concept Categories

Use a category only when it helps readers. Do not force every term into a tactical DDD stereotype.

Recommended categories:

- Actor or Role
- Business Object
- Agreement or Contract
- Business Document
- Command or Intent
- Domain Event
- State or Status
- Policy or Rule
- Process or Activity
- Classification
- Measure or Metric
- Monetary Concept
- Time Concept
- Exception
- Other Domain Concept

DDD tactical categories such as `Entity`, `Value Object`, `Aggregate`, or `Domain Service` may be recorded only when the repository explicitly supports that interpretation and it adds value.

A class name alone is not enough evidence.

## Evidence Strength

Use this rough evidence hierarchy.

### Strong evidence

- explicit domain definitions in maintained documentation
- business rule descriptions
- acceptance tests or BDD scenarios
- tests named in domain language
- state-transition tests
- calculations and validation rules
- domain event and command definitions
- user-facing labels, messages, forms, reports, or help text
- examples that show the term in a real workflow
- consistent use across documentation, code, and tests

### Medium evidence

- repeated identifiers across several relevant modules
- API or schema names that reflect business concepts
- enum values representing business states
- route or CLI names reflecting user intentions
- error messages that describe business rule violations
- persistence names confirmed by behavior elsewhere

### Weak evidence

- one isolated filename
- one class name
- one database table
- one abbreviation
- one comment without supporting behavior
- a generated schema or vendored file
- naming that could be purely technical

Do not create a confident definition from weak evidence alone.

## Claim Status Labels

Use these labels where needed:

- **verified**: the meaning is explicitly defined or strongly demonstrated by consistent behavior and repository evidence
- **inferred**: the meaning is reasonably reconstructed from usage, relationships, rules, or lifecycle behavior
- **uncertain**: the term is visible but its meaning or context is not sufficiently supported
- **missing**: an important concept is referenced but no usable definition could be recovered

A term may be present in code with `verified` occurrence but still have an `inferred` meaning.

Be clear about which part is verified.

## Repository Inspection Process

When `/glossary` is invoked, inspect the repository from the current working directory.

Start with safe, read-only inspection.

Recommended first pass:

```bash
pwd
git rev-parse --show-toplevel
git status --short
git ls-files
```

If `git ls-files` is unavailable, use a bounded `find` command.

Do not scan large ignored or generated directories manually.

Skip or summarize these unless directly relevant:

```text
.git/
node_modules/
vendor/
dist/
build/
target/
coverage/
.cache/
.venv/
venv/
__pycache__/
.pytest_cache/
.idea/
.vscode/
```

Do not read or reproduce secret values.

## Files and Signals to Inspect

Inspect in this rough order.

### 1. Existing domain documentation

Look for:

```text
README.md
docs/
domain notes
business requirements
glossaries
product documentation
ADRs that discuss business boundaries
examples/
sample data documentation
```

Extract:

- stated business purpose
- actors and stakeholders
- business capabilities
- explicitly defined terms
- named workflows
- rules and constraints
- known context boundaries
- synonyms or legacy terminology

### 2. Tests and scenarios

Tests often contain the clearest executable domain language.

Look for:

```text
tests/
test/
spec/
features/
e2e/
acceptance/
*.feature
*.spec.*
*.test.*
fixtures/
examples/
```

Inspect:

- test names
- scenario names
- given/when/then wording
- fixture names
- expected business outcomes
- business-rule failures
- state transitions
- boundary cases
- calculations

Do not treat test framework terminology as domain language.

### 3. Domain-oriented source areas

Look for likely domain-bearing areas:

```text
domain/
core/
model/
models/
entities/
value-objects/
aggregates/
policies/
rules/
workflows/
use-cases/
commands/
events/
states/
calculations/
```

Also inspect business concepts outside conventionally named domain folders.

Extract:

- recurring domain nouns
- meaningful verbs
- business relationships
- lifecycle rules
- invariants
- decisions
- state changes
- business errors
- event names
- command names

Do not assume a `domain/` directory proves that the repository follows DDD.

Do not assume files outside `domain/` lack domain language.

### 4. User-facing language

Look for:

```text
UI labels
form labels
menu items
report headings
CLI help
validation messages
business error messages
email templates
notification templates
localization files
```

User-facing wording is useful because it may show the language used outside implementation internals.

Mark copy-only wording as uncertain if no behavior supports it.

### 5. Interfaces and schemas

Inspect relevant:

```text
OpenAPI or Swagger files
GraphQL schemas
protobuf definitions
event schemas
message contracts
public types
import and export formats
```

Use interfaces as evidence for domain concepts, not as a reason to include technical transport vocabulary.

### 6. Persistence and migrations

Inspect persistence names only as supporting evidence.

Database names can preserve important legacy vocabulary, but they can also expose implementation accidents.

Do not define a domain concept from a table name alone.

### 7. Git history

Use only when locally available and useful.

Safe examples:

```bash
git log --oneline -n 30
git log -S"<term>" --oneline --all
```

History can reveal renamed or legacy terms, but current repository behavior remains the primary source.

## Candidate-Term Discovery

Build an internal candidate list before writing the glossary.

For each candidate, capture:

```text
canonical term
observed spellings
possible meaning
candidate context
category
related terms
behavior or rules
evidence paths
confidence
language tension
review question
```

Search for recurring business nouns and verbs across documentation, tests, source, schemas, and user-facing text.

Useful signals include:

- PascalCase or camelCase identifiers repeated across domain-bearing files
- enum values that describe lifecycle states
- method names that express business actions
- past-tense event names
- validation errors stating business constraints
- calculations with named business variables
- test fixtures named after domain scenarios
- reports and UI labels
- terms used by more than one layer

Do not use frequency alone. A highly repeated technical word is still technical.

## Candidate Bounded Context Discovery

Group terms by candidate bounded context only when repository evidence supports a meaningful language boundary.

Useful signals:

- a business capability with its own rules and lifecycle
- terms that have locally consistent meanings
- separate models for the same real-world concept
- explicit integration or translation between vocabularies
- different actors or decisions
- separate ownership stated in documentation
- context-specific events, commands, or policies
- anti-corruption or mapping code between models

Weak signals:

- folder boundaries alone
- database boundaries alone
- microservice boundaries alone
- team names alone
- framework modules alone

If the evidence is weak, use one repository-level glossary and list candidate contexts as open questions.

## Definition Rules

Definitions must:

- use plain domain language
- begin with the canonical term's business meaning
- be understandable without reading the code
- state the relevant context when meanings differ
- include a distinguishing rule, lifecycle role, or relationship when useful
- avoid circular definitions
- avoid implementation details
- avoid unsupported assumptions
- preserve meaningful capitalization and spelling
- identify an abbreviation as unresolved rather than inventing an expansion

Prefer singular nouns for business objects and roles.

Prefer past tense for domain events when the repository uses event language.

Prefer imperative or intention-revealing phrasing for commands.

Examples:

Good:

```text
Settlement: the process that finalizes an agreed obligation and records the resulting payment or transfer.
```

Poor:

```text
Settlement: the SettlementService and SettlementRepository implementation.
```

Good:

```text
Open: a claim state in which assessment or settlement work remains possible.
```

Poor:

```text
Open: enum value 1.
```

## Canonical Term Selection

When multiple names appear to mean the same thing:

1. Do not silently normalize them.
2. Record the observed forms.
3. Identify which form is dominant, if evidence supports that.
4. Note which layers or contexts use each form.
5. Recommend a canonical term only as a review proposal.
6. Preserve a human-confirmed canonical term if one already exists.

When one term appears to have different meanings:

1. Split it by context.
2. Define each meaning separately.
3. Record the collision in `Language Tensions`.
4. Do not force one global definition.

## Required Glossary Content

Include the sections that repository evidence supports.

### Purpose and Scope

State:

- what repository or area was inspected
- whether the review was full, targeted, or incremental
- that the document describes observed or candidate ubiquitous language
- any important scope limitations

### Domain Overview

Summarize the problem domain in a few evidence-based sentences.

Do not turn this into architecture documentation.

### Candidate Bounded Contexts

Include only when useful.

Recommended table:

```markdown
| Candidate Context | Business Capability | Distinctive Language | Evidence | Confidence |
|---|---|---|---|---|
```

### Ubiquitous Language

Group terms by context when appropriate.

Recommended table:

```markdown
| Term | Meaning | Category | Related Terms | Evidence | Confidence |
|---|---|---|---|---|---|
```

For ambiguous or central concepts, add a short detailed subsection after the table.

Each term should include at least one evidence path.

### Domain Rules Encoded in Language

Use this section when terms are inseparable from important rules.

Example:

```markdown
| Concept | Rule expressed by the repository | Evidence | Confidence |
|---|---|---|---|
```

### Lifecycle and State Language

Use when the repository has important states or transitions.

Example:

```markdown
| Subject | State or Event | Meaning | Allowed or Observed Transition | Evidence |
|---|---|---|---|---|
```

Do not invent a complete state machine from partial enum values.

### Language Tensions

Include findings such as:

- competing synonyms
- overloaded terms
- inconsistent state names
- technical leakage
- unexplained abbreviations
- names that differ between code, tests, UI, and documentation
- concepts represented but never named clearly

Recommended table:

```markdown
| Terms or Forms | Tension | Evidence | Impact | Review Question |
|---|---|---|---|---|
```

### Missing Definitions

List important concepts whose meaning could not be recovered.

State where the skill searched.

### Domain Expert Review Questions

Ask concrete questions that can validate or improve the language.

Good:

```text
Are "case" and "claim" different concepts, or are they competing names for the same concept?
```

Poor:

```text
Is the glossary correct?
```

## Technical Leakage

Technical leakage occurs when implementation vocabulary appears to substitute for a domain concept.

Examples:

- business users are asked to discuss a `transaction header`
- UI wording exposes a database column name
- domain behavior is named after a framework abstraction
- one layer uses a business term while another uses a storage term
- a business process is named after the screen or table that originally implemented it

Do not label every technical name as harmful.

Report technical leakage only when it weakens, obscures, or competes with domain meaning.

## Existing Glossary Handling

If `docs/GLOSSARY.md` already exists:

1. Read it before generating changes.
2. Preserve domain-expert-confirmed definitions.
3. Preserve useful manual notes.
4. Update evidence paths when the repository moved.
5. Add newly observed terms only when they meet the inclusion criteria.
6. Remove obsolete terms only when evidence is strong.
7. Mark conflicting evidence instead of overwriting a trusted definition.
8. Keep anchors and canonical spellings stable where practical.
9. Record terminology drift in `Language Tensions`.
10. Do not blindly append duplicate entries.

A definition marked as human-confirmed must not be replaced by an agent inference without an explicit warning and review note.

## Safe Command Guidance

Prefer read-only commands such as:

```bash
git status --short
git ls-files
rg -n "<term>" .
rg -n "Given|When|Then|Scenario|Rule" tests features spec
rg -n "Created|Submitted|Approved|Rejected|Cancelled|Closed|Opened" .
```

Adapt searches to the repository language and structure.

Do not run dependency installation, application startup, Docker, deployment, migrations, or destructive commands merely to generate the glossary.

Running focused existing tests may strengthen evidence, but do so only when the user has allowed it or the command is clearly safe and inexpensive.

## Writing Process

Follow this process:

1. Determine the repository root.
2. Read an existing `docs/GLOSSARY.md`, if present.
3. Establish the requested scope.
4. Inspect high-level documentation and examples.
5. Identify the problem domain and business capabilities.
6. Inspect tests and scenarios for executable language.
7. Inspect domain-bearing source, user-facing text, schemas, and relevant persistence names.
8. Build a candidate term list.
9. Remove generic and technical vocabulary.
10. Trace each remaining term through behavior, relationships, rules, or lifecycle.
11. Identify candidate bounded contexts.
12. Separate same-spelling terms that have context-specific meanings.
13. Detect synonyms, abbreviations, legacy names, technical leakage, and other tensions.
14. Assign evidence and confidence.
15. Generate or update `docs/GLOSSARY.md`.
16. Remove unused template sections and placeholders.
17. Check that every definition explains domain meaning rather than code shape.
18. Report what was written and what requires domain-expert review.

## Quality Rules

The final glossary must be:

- specific to the repository
- focused on domain language
- understandable by non-developers familiar with the domain
- evidence-based
- explicit about uncertainty
- contextual where meanings differ
- compact enough to review
- free of unresolved template placeholders
- free of copied secret values
- useful for future code, test, documentation, and design discussions

The final glossary must not be:

- an inventory of classes
- an inventory of database tables
- a framework glossary
- a list of every noun in the repository
- a generic DDD tutorial
- a speculative business analysis
- a proposed redesign
- a hidden code-renaming plan
- a claim that repository vocabulary is already universally accepted

Prefer the strongest terms over exhaustive coverage.

For an ordinary repository, a smaller glossary with 10–30 meaningful terms is usually more useful than hundreds of weak candidates. Large repositories may require separate context sections or a stated sampling scope.

## Completion Criteria

The task is complete when:

1. `docs/GLOSSARY.md` exists or has been updated.
2. The document explains observed domain language rather than technical architecture.
3. Each included term has repository evidence.
4. Candidate bounded contexts are marked cautiously.
5. Ambiguous, overloaded, or competing terms are visible.
6. Technical vocabulary has been excluded unless it carries domain meaning.
7. Inferred definitions are clearly marked.
8. Domain-expert review questions are concrete.
9. No unresolved template placeholders remain.

## Completion Report

After writing the file, respond with a concise report:

```text
Created/updated:
- docs/GLOSSARY.md

Strongest domain terms found:
- [term]: [short meaning]
- [term]: [short meaning]
- [term]: [short meaning]

Language tensions:
- [synonym, collision, abbreviation, or technical leakage]
- [synonym, collision, abbreviation, or technical leakage]

Important gaps:
- [missing definition or context boundary]
- [missing definition or context boundary]

Suggested review:
- [one concrete question for a domain expert]
```

## Failure Handling

### Repository root cannot be determined

Report:

```text
I could not determine the repository root. Open the repository folder first or invoke /glossary from inside the repository.
```

### Repository has little or no business domain

Do not invent domain language.

Create a short `docs/GLOSSARY.md` that states:

- what was inspected
- that no strong domain-specific vocabulary was found
- whether the repository appears to be a generic library, infrastructure tool, or technical utility
- any small set of user-facing concepts that may still matter
- what evidence would be needed for a richer glossary

### Repository is too large

1. Inspect top-level documentation and business capability boundaries.
2. Prioritize tests, domain-oriented modules, and user-facing language.
3. Sample by candidate context.
4. State the inspection scope.
5. Recommend separate follow-up passes for unreviewed contexts.

### Definitions conflict

Do not choose silently.

Record:

- each observed meaning
- the context or layer using it
- the supporting evidence
- the likely impact
- a concrete review question

### Meaning cannot be recovered

Mark the term as `uncertain` or `missing`.

State which files or areas were checked.

Do not invent an expansion, business rule, or relationship.

### Template is missing

Continue using the document structure described in this skill.

Mention that the bundled template was unavailable.

### File cannot be written

Report the error and provide a concise summary of the content that would have been written.

## Non-Goals

This skill does not:

- redesign the domain model
- rename code automatically
- define bounded contexts solely from deployment boundaries
- generate architecture documentation
- document APIs exhaustively
- create a data dictionary
- list every identifier
- infer organizational ownership without evidence
- replace conversations with domain experts
- declare inferred vocabulary to be universally accepted

## Core Principle

Find the language that explains the business behavior encoded in the repository.

Then make clear:

```text
What does this term mean?
In which context does it mean that?
Which repository evidence supports the meaning?
Where is the language inconsistent or incomplete?
What must a domain expert confirm?
```
