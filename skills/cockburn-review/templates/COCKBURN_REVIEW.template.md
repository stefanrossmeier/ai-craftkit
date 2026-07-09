# Cockburn Boundary Review

> Generated with `ai-craftkit` skill: `cockburn-review`  
> Source: `<repository-url>` at commit `<commit-hash>`  
> Prompt: `<exact-user-prompt>`

Last Reviewed Scope: `[full repository | named area | plain-language user scope]`  
Doc Status: `[MAINTAINED | DRAFT | NEEDS REVIEW]`  
Last Review Update: `[YYYY-MM-DDTHH:MM:SSZ]`  
Updated By: `[human | agent | human+agent]`  
Source Basis: `[README scan | code scan | dependency scan | tests scan | docs scan | git diff scan | commands run | other]`

## Purpose

This document reviews architectural weaknesses through the Cockburn-inspired questions:

- **Not my job**: Is a component doing work that appears to belong somewhere else?
- **No need to know**: Does a component know implementation details it should be insulated from?

The goal is to identify responsibility drift, knowledge leakage, boundary bypasses, and change-amplifying dependencies using concrete evidence from this repository.

## Evidence Legend

Use these labels for claims and findings:

- **verified**: directly confirmed from code, config, tests, local read-only command output, or explicit documentation.
- **inferred**: likely true based on naming, imports, structure, or partial evidence.
- **uncertain**: plausible but not sufficiently supported.
- **missing**: expected information was searched for but not found.

A reported finding must include repository evidence. Candidate findings without enough evidence belong in the "Insufficient Evidence" section or should be omitted.

## Executive Summary

[Summarize the most important architectural risk in 1-3 short paragraphs. Mention the dominant Cockburn theme: "not my job", "no need to know", or both. Do not make claims without evidence listed later in the report.]

## Review Scope and Source Basis

| Area | What was inspected | Evidence | Status |
|---|---|---|---|
| Repository structure | `[folders/files inspected]` | `[paths or commands]` | `[verified/inferred]` |
| Existing docs | `[docs inspected]` | `[paths]` | `[verified/inferred/missing]` |
| Source modules | `[modules inspected]` | `[paths]` | `[verified/inferred]` |
| Tests | `[tests inspected]` | `[paths]` | `[verified/inferred/missing]` |
| Runtime/config | `[runtime/config files inspected]` | `[paths]` | `[verified/inferred/missing]` |

Skipped or intentionally not inspected:

- `[path or command]`: `[reason]`

## Inferred Architectural Map

[Describe the architecture that the repository appears to suggest through docs, folder names, entry points, imports, and tests. Mark inferred structure clearly.]

| Architectural role | Apparent responsibility | Owns | Depends on | Used by | Evidence | Status |
|---|---|---|---|---|---|---|
| `[role/module]` | `[responsibility]` | `[data/behavior/interface]` | `[dependencies]` | `[callers]` | `[paths]` | `[verified/inferred]` |
| `[role/module]` | `[responsibility]` | `[data/behavior/interface]` | `[dependencies]` | `[callers]` | `[paths]` | `[verified/inferred]` |

## Responsibility and Knowledge Boundaries

| Boundary | Expected responsibility split | Observed evidence | Boundary health | Status |
|---|---|---|---|---|
| `[boundary]` | `[who should own what]` | `[paths/imports/tests/docs]` | `[healthy/stressed/unclear]` | `[verified/inferred/uncertain]` |
| `[boundary]` | `[who should own what]` | `[paths/imports/tests/docs]` | `[healthy/stressed/unclear]` | `[verified/inferred/uncertain]` |

Boundary notes:

- `[evidence-backed note]`
- `[evidence-backed note]`

## Finding Summary

| # | Finding | Type | Severity | Confidence | Affected area | Main evidence |
|---|---|---|---|---|---|---|
| 1 | `[short finding title]` | `[Not my job / No need to know / Both / other]` | `[High/Medium/Low]` | `[High/Medium/Low]` | `[module/path]` | `[paths]` |
| 2 | `[short finding title]` | `[Not my job / No need to know / Both / other]` | `[High/Medium/Low]` | `[High/Medium/Low]` | `[module/path]` | `[paths]` |

## Boundary Findings

### Finding 1: `[short title]`

**Type**: `[Not my job | No need to know | Both | Boundary bypass | Responsibility drift | Framework leakage | Semantic duplication | Change amplification | Abstraction leak | Utility sinkhole | Policy scattered across layers | Data ownership confusion | Test setup boundary smell]`  
**Severity**: `[High | Medium | Low]`  
**Confidence**: `[High | Medium | Low]`  
**Affected area**: `[module/path/capability]`

#### Evidence

| Evidence | What it shows | Status |
|---|---|---|
| `[path:symbol or path:line-range]` | `[concrete observation]` | `[verified/inferred]` |
| `[path:symbol or path:line-range]` | `[concrete observation]` | `[verified/inferred]` |

#### Observed Behavior

[Describe only what the repository evidence shows. Avoid broad interpretation here.]

#### Cockburn Framing

- **Not my job**: `[explain responsibility mismatch, or state not applicable]`
- **No need to know**: `[explain knowledge leakage, or state not applicable]`

#### Why This May Be an Architectural Weakness

[Explain the risk in terms of boundaries, responsibility, knowledge, coupling, or future change pressure. Tie the explanation to the evidence above.]

#### Future Change Likely to Become Harder

[Name a realistic future change and explain why this structure would make it harder.]

#### Suggested Architectural Move

[Suggest a small, evidence-connected move. Avoid generic rewrites.]

#### What Not to Over-Fix

[State what should not be changed yet, or what trade-off may be acceptable.]

### Finding 2: `[short title]`

**Type**: `[type]`  
**Severity**: `[High | Medium | Low]`  
**Confidence**: `[High | Medium | Low]`  
**Affected area**: `[module/path/capability]`

#### Evidence

| Evidence | What it shows | Status |
|---|---|---|
| `[path:symbol or path:line-range]` | `[concrete observation]` | `[verified/inferred]` |

#### Observed Behavior

[Concrete observation.]

#### Cockburn Framing

- **Not my job**: `[responsibility mismatch or not applicable]`
- **No need to know**: `[knowledge leakage or not applicable]`

#### Why This May Be an Architectural Weakness

[Evidence-connected interpretation.]

#### Future Change Likely to Become Harder

[Change scenario.]

#### Suggested Architectural Move

[Small move.]

#### What Not to Over-Fix

[Pragmatic limit.]

## Change-Stress Scenarios

[Use this section to show how current boundaries respond to likely future changes. Include only scenarios grounded in repository concepts.]

### Scenario: `[future change]`

| Step likely to change | Current evidence | Architectural concern | Status |
|---|---|---|---|
| `[module/file/behavior]` | `[paths]` | `[why change may spread]` | `[verified/inferred]` |
| `[module/file/behavior]` | `[paths]` | `[why change may spread]` | `[verified/inferred]` |

Assessment:

[Explain whether the change appears localized or change-amplifying.]

## Architectural Hotspots

| Hotspot | Why it matters | Evidence | Risk | Status |
|---|---|---|---|---|
| `[path/module]` | `[role in system]` | `[paths/imports/tests]` | `[boundary/change risk]` | `[verified/inferred]` |
| `[path/module]` | `[role in system]` | `[paths/imports/tests]` | `[boundary/change risk]` | `[verified/inferred]` |

## Evidence Register

| Claim | Evidence | Status |
|---|---|---|
| `[claim]` | `[path, command output, test, doc]` | `[verified/inferred/uncertain/missing]` |
| `[claim]` | `[path, command output, test, doc]` | `[verified/inferred/uncertain/missing]` |

## Insufficient Evidence / Not Reported as Findings

Use this section sparingly. Include only plausible concerns that were considered but not reported because evidence was insufficient.

| Candidate concern | Evidence checked | Why not reported | What would confirm it |
|---|---|---|---|
| `[candidate]` | `[paths/searches]` | `[insufficient evidence reason]` | `[needed evidence]` |

## Recommendations

### Fix Now

1. `[recommendation]`  
   Evidence: `[finding number and paths]`  
   Expected benefit: `[change localization / reduced knowledge leakage / clearer ownership]`

### Watch

1. `[watch item]`  
   Evidence: `[paths]`  
   Reason to watch instead of fix now: `[trade-off/context]`

### Accept as Trade-Off

1. `[accepted trade-off]`  
   Evidence: `[paths]`  
   Reason: `[why this may be acceptable for now]`

## Known Unknowns

- `[unknown]`: checked `[paths/searches]`, but could not verify `[fact]`.
- `[unknown]`: verification would require `[command/action]`, which was not run.

## Agent Work Guide

Before changing code near the findings above:

1. Read the evidence paths for the relevant finding.
2. Check whether existing docs state an intended boundary.
3. Search for duplicate policy, provider-specific terms, framework types, and deep imports.
4. Prefer a small boundary move over a broad rewrite.
5. Update this review if the change materially alters responsibility or knowledge boundaries.

Useful searches:

```bash
rg "TODO|FIXME|HACK|XXX"
rg "internal|private|impl|repository|service|controller|adapter|mapper|schema"
rg "from .*db|from .*infra|from .*infrastructure|import .*db|import .*infra|import .*infrastructure"
```
