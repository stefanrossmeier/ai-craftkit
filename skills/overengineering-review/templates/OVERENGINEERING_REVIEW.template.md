# Overengineering Review

> Generated with `ai-craftkit` skill: `overengineering-review`
> Source: `<repository-url>` at commit `<commit-hash>`
> Prompt: `<exact-user-prompt>`

**Review scope:** [whole repository / named area]  
**Document status:** [current snapshot / partial]  
**Source basis:** [code, tests, docs, config, infrastructure, history]  
**Review date:** [date if directly available]

## Executive Summary

[Briefly state whether the repository appears proportionate to its problem, where the largest accidental-complexity costs are, and what should not be simplified.]

### Overall Assessment

| Area | Assessment | Confidence |
|---|---|---|
| Architecture | [proportionate / some excess / materially overengineered / insufficient evidence] | [High/Medium/Low] |
| Abstractions | [...] | [...] |
| Infrastructure | [...] | [...] |
| Configuration | [...] | [...] |
| Testing/tooling | [...] | [...] |

## Problem and Constraint Baseline

### What the Repository Appears to Solve

[Describe the actual product/system problem from repository evidence.]

### Evidenced Constraints

| Constraint | Evidence | Status |
|---|---|---|
| [security/reliability/scale/compatibility/etc.] | `[path or artifact]` | [verified/inferred] |

### Important Unknowns

[Only include unknowns that materially affect the review.]

## Complexity Inventory

Summarize the mechanisms that carry meaningful complexity. Counts are context, not findings.

| Mechanism | Observed Shape | Apparent Purpose |
|---|---|---|
| Deployable processes/services | [...] | [...] |
| Architectural layers | [...] | [...] |
| Major abstractions/extensions | [...] | [...] |
| Configuration/feature variability | [...] | [...] |
| Queues/events/concurrency | [...] | [...] |
| Infrastructure/deployment | [...] | [...] |
| Test harnesses/tooling | [...] | [...] |

## Findings

### OE-1 — [Short Title]

**Class:** [Speculative Generality / Abstraction Inflation / Architectural Overreach / Infrastructure Disproportion / Premature Optimization / Configuration Explosion / Reinvented Platform or Framework / Pattern and Technology Enthusiasm / Defensive Complexity Without a Threat or Failure Model / Legacy or Lava-Flow Complexity / Test Architecture Overengineering / Dependency and Tooling Excess]  
**Related smell or anti-pattern:** [optional]  
**Severity:** [High / Medium / Low]  
**Confidence:** [High / Medium / Low]  
**Affected area:** `[path/module/component]`  
**Recommendation:** [simplify now / simplify when touched / watch / accept as trade-off]

#### Problem Being Solved

[What requirement or concern this machinery appears intended to address.]

#### Evidence of Added Complexity

- `[path:line or symbol]` — [specific observed mechanism]. Status: verified.
- `[path:line or symbol]` — [specific observed cost, indirection, variability, infrastructure, etc.]. Status: verified.

#### Evidence of Requirement or Justification

- `[path]` — [documented requirement/supporting evidence], or
- No repository evidence was found that requires [specific capability] after inspecting [locations]. This means justification is **missing from inspected evidence**, not necessarily nonexistent.

#### Why It Appears Disproportionate

[Compare the evidenced requirement to the implementation cost. Name the concrete cognitive/change/test/operational/state-space/dependency cost.]

#### Simpler Credible Alternative

[Describe a realistic simpler shape that satisfies the same evidenced requirements.]

#### What Must Be Preserved

- [security/safety/compatibility/runtime property]
- [behavior or contract]

#### Trade-offs of Simplifying

[What flexibility or capability would be lost, and why that loss appears acceptable—or why it may not be.]

#### Counterargument Considered

[State the strongest reason the current complexity may be justified and the evidence for/against it.]

---

## Justified Complexity

Use this section for mechanisms that looked suspicious during inspection but have sufficient evidence behind them.

### JC-1 — [Short Title]

**Mechanism:** [e.g. adapter, queue, state machine, sandbox, deployment split]  
**Why it looked potentially excessive:** [...]  
**Justification evidence:**

- `[path]` — [...]
- `[test/config/docs]` — [...]

**Verdict:** Accept as trade-off. Simplifying this would risk [specific guarantee].

## Watchlist / Insufficient Evidence

Use sparingly. These are not findings.

| Candidate | Why It Is Suspicious | What Was Inspected | Evidence Needed |
|---|---|---|---|
| [candidate] | [...] | [...] | [...] |

## Simplification Priorities

| Priority | Finding | Suggested Move | Expected Complexity Reduction | Risk |
|---|---|---|---|---|
| 1 | OE-[n] | [...] | [cognitive/change/ops/etc.] | [Low/Medium/High] |

## Cross-Cutting Observations

### Complexity Costs

[Summarize repeated cost mechanisms: excessive hops, configuration state space, distributed operations, test indirection, dependency burden, etc.]

### Dominant Overengineering Classes

[Only list classes supported by findings.]

### Anti-Pattern Mapping

| Finding | Anti-Pattern / Smell | Why the Label Helps |
|---|---|---|
| OE-[n] | [Speculative Generality / Middle Man / Inner-Platform Effect / Golden Hammer / Lava Flow / other] | [short evidence-based explanation] |

Do not add anti-pattern labels solely to fill this table.

## What Not to Simplify

[List important complexity that is justified and should be protected, especially security, reliability, compatibility, trust boundaries, or domain rules.]

## Recommended Next Steps

1. [Concrete action tied to finding]
2. [Concrete action tied to finding]
3. [Measurement or missing evidence to collect before changing something]

## Review Limits

[State files/areas not inspected, unavailable requirements, commands not run, external context not visible, or other limitations.]
