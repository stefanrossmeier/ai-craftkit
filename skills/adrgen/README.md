# adrgen

`adrgen` is a repository skill for creating evidence-based Architecture Decision Records.

It helps humans and coding agents document architectural decisions, prepare upcoming decisions, and turn existing repository structure into reviewable ADR candidates.

The skill is designed to avoid generic ADR boilerplate. It uses repository evidence, explicit uncertainty labels, and practical agent guidance.

## Command

```text
/adrgen
```

## Modes

`adrgen` supports four modes.

### 1. Discover

```text
/adrgen discover
```

Scans the repository for architectural decisions that appear to exist in the codebase but are not documented yet.

Typical output:

```text
docs/adr/ADR_CANDIDATES.md
docs/adr/README.md
```

Use this when a repository has important architecture choices but few or no ADRs.

Discovery mode looks for decisions around frameworks, data storage, module boundaries, deployment, configuration, security, testing, integrations, runtime units, and similar architecture-relevant areas.

### 2. Generate

```text
/adrgen generate
```

Creates ADR drafts from reviewed candidates in:

```text
docs/adr/ADR_CANDIDATES.md
```

This supports a review-first workflow:

```text
/adrgen discover
review and adjust ADR_CANDIDATES.md
/adrgen generate
```

Generate mode only creates ADRs for candidates marked as ready, approved, selected, or explicitly requested.

Typical output:

```text
docs/adr/0001-decision-title.md
docs/adr/README.md
docs/adr/ADR_CANDIDATES.md
```

Use this when a human has reviewed the candidates and wants to turn selected ones into ADR files.

### 3. Capture

```text
/adrgen capture
```

Turns an ongoing or completed discussion into an ADR draft.

Use this with meeting notes, issue comments, pull request discussions, Slack threads, architecture review notes, or a human-provided decision summary.

Typical output:

```text
docs/adr/0001-decision-title.md
docs/adr/README.md
```

Capture mode records the decision, context, alternatives, trade-offs, consequences, evidence, and open questions.

### 4. Prepare

```text
/adrgen prepare "decision topic"
```

Prepares alternatives and decision criteria before an architecture discussion.

Typical output:

```text
docs/adr/ADR_PREP-decision-topic.md
docs/adr/README.md
```

Use this when no decision has been made yet and the team needs a structured discussion document.

Prepare mode should not claim that a decision exists. It helps clarify the problem, options, trade-offs, risks, missing information, and discussion questions.

## Evidence Labels

`adrgen` uses explicit evidence labels:

```text
verified
inferred
uncertain
missing
```

These labels help prevent agents from inventing rationale or overstating repository evidence.

## Recommended Workflow

For existing repositories:

```text
/adrgen discover
```

Review and edit:

```text
docs/adr/ADR_CANDIDATES.md
```

Then generate selected ADRs:

```text
/adrgen generate
```

For active discussions:

```text
/adrgen capture
```

For upcoming decisions:

```text
/adrgen prepare "Choose an authorization model"
```

## Output Location

All generated ADR documents are written under:

```text
docs/adr/
```

Typical files include:

```text
docs/adr/README.md
docs/adr/ADR_CANDIDATES.md
docs/adr/ADR_PREP-decision-topic.md
docs/adr/0001-decision-title.md
```

## Safety and Scope

`adrgen` inspects the repository when needed, but it should start with safe read-only inspection.

It should not:

* modify application source code
* expose secrets
* install dependencies by default
* run expensive or state-changing commands without reason
* turn every implementation detail into an ADR
* mark inferred rationale as verified history
* generate ADRs from rejected or unresolved candidates by default

## Goal

`adrgen` helps the next human or agent answer:

```text
What decision exists here?
Why was it made?
What alternatives were considered?
What are the consequences?
Which evidence supports it?
What is still uncertain?
What should I check before changing this area?
```
