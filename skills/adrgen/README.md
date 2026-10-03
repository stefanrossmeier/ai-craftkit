# adrgen

`adrgen` supports evidence-based Architecture Decision Records while keeping implementation evidence separate from human decision evidence.

## Commands

```text
/adrgen discover
/adrgen generate
/adrgen capture
/adrgen prepare
```

### Discover

Find architecture-significant choices visible in the repository and write reviewable candidates to:

```text
docs/adr/ADR_CANDIDATES.md
```

Discovery proves that a choice appears to be implemented; it does **not** prove that humans formally accepted it or why they chose it.

### Generate

Create ADR drafts from candidates a human has selected or explicitly requested. Code-discovered candidates default to `Decision Status: PROPOSED`, even when `Implementation Status: IMPLEMENTED`.

### Capture

Turn explicit human decision evidence—meeting notes, an issue/PR discussion, an existing decision document, or direct human input—into an ADR. `ACCEPTED` is appropriate only when that source establishes acceptance.

### Prepare

Create a structured pre-decision document with the problem, drivers, constraints, options, trade-offs, and open questions. A preparation document must state that no decision has been made yet.

## Output

All decision artifacts live under:

```text
docs/adr/
```

Templates are in [`templates/`](templates/). See [`SKILL.md`](SKILL.md) for status rules, evidence rules, and workflow details.

## Relationship to archdoc

`adrgen` may use `docs/archdoc/` as current-system evidence. It should not copy architecture documentation into ADRs, and it must not treat generated architecture descriptions as proof of historical rationale.

## Core rule

**Implementation tells you what exists. Explicit decision evidence tells you what humans decided and why.**
