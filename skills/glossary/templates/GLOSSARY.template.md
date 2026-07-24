# Domain Glossary

> Generated with `ai-craftkit` skill: `glossary`
> Source: `<repository-url>` at commit `<commit-hash>`
> Prompt: `<exact-user-prompt>`

Last Reviewed Scope: [full review | delta update | targeted area]  
Doc Status: [MAINTAINED | DRAFT | NEEDS REVIEW]  
Last Glossary Update: [YYYY-MM-DDTHH:MM:SSZ]  
Updated By: [human | agent | human+agent]  
Source Basis: [docs scan | code scan | tests scan | UI text | schemas | other]  
Domain Expert Review: [NOT REVIEWED | PARTIAL | CONFIRMED]

## Purpose and Scope

[State what repository or area was inspected, why this glossary exists, whether the review was full or targeted, and any important scope limitations.]

This document describes language observed in the repository. Terms and definitions remain candidate ubiquitous language until reviewed by knowledgeable domain experts.

## Domain Overview

[Summarize the problem domain and main business capabilities in a few evidence-based sentences. Do not describe technical architecture here.]

## Candidate Bounded Contexts

[Keep this section only when the repository supports meaningful language boundaries. Do not equate folders, services, or databases with bounded contexts without further evidence.]

| Candidate Context | Business Capability | Distinctive Language | Evidence | Confidence |
|---|---|---|---|---|
| [context] | [capability] | [terms] | `[path]` | [verified/inferred/uncertain] |

## Ubiquitous Language

### [Repository-wide or Context Name]

| Term | Meaning | Category | Related Terms | Evidence | Confidence |
|---|---|---|---|---|---|
| **[Canonical Term]** | [Plain-language domain definition.] | [Actor or Role / Business Object / Domain Event / Policy or Rule / State or Status / Process or Activity / Measure or Metric / Other] | [related terms] | `[path]`, `[path]` | [verified/inferred/uncertain] |

### Detailed Notes for Central or Ambiguous Terms

#### [Term]

**Meaning:** [Plain-language domain meaning.]

**Context:** [Context in which this meaning applies.]

**Observed forms:** `[Term]`, `[Alias]`, `[LegacyName]`

**Behavior or rules:**

- [Rule, lifecycle role, decision, or relationship.]
- [Rule, lifecycle role, decision, or relationship.]

**Evidence:**

- `[path:line or symbol]`: [What the evidence demonstrates.]
- `[path:line or symbol]`: [What the evidence demonstrates.]

**Confidence:** [verified/inferred/uncertain]

**Review note:** [Concrete issue or question, if any.]

## Domain Rules Encoded in Language

[Keep this section when important terms are inseparable from business rules.]

| Concept | Rule Expressed by the Repository | Evidence | Confidence |
|---|---|---|---|
| [concept] | [rule] | `[path]` | [verified/inferred/uncertain] |

## Lifecycle and State Language

[Keep this section when important objects have lifecycle states or domain events.]

| Subject | State or Event | Meaning | Allowed or Observed Transition | Evidence |
|---|---|---|---|---|
| [subject] | [state/event] | [meaning] | [transition] | `[path]` |

## Language Tensions

### Competing Terms or Synonyms

| Terms or Forms | Tension | Evidence | Impact | Review Question |
|---|---|---|---|---|
| `[term A]` / `[term B]` | [same concept may use competing names] | `[path]`, `[path]` | [ambiguity or change risk] | [specific question] |

### Same Term, Different Meanings

| Term | Meaning A and Context | Meaning B and Context | Evidence | Review Question |
|---|---|---|---|---|
| [term] | [meaning/context] | [meaning/context] | `[path]`, `[path]` | [specific question] |

### Technical Leakage

| Technical Form | Domain Concept It May Obscure | Evidence | Why It Matters | Review Question |
|---|---|---|---|---|
| [technical term] | [domain concept] | `[path]` | [impact] | [specific question] |

### Unresolved Abbreviations or Legacy Names

| Form | Observed Usage | Evidence | Status | Review Question |
|---|---|---|---|---|
| [abbreviation/name] | [usage] | `[path]` | [uncertain/legacy/inferred] | [specific question] |

## Missing Definitions

- **[Term or concept]:** Meaning could not be recovered. Checked `[path]`, `[path]`, and [area searched].
- **[Term or concept]:** Repository behavior implies the concept exists, but no stable name or definition was found.

## Domain Expert Review Questions

1. [Concrete question about whether two terms represent the same concept.]
2. [Concrete question about a context-specific meaning.]
3. [Concrete question about a business rule or lifecycle transition.]
4. [Concrete question about the preferred canonical term.]

## Evidence Register

[Keep only when a separate compact evidence index helps review.]

| Area Inspected | Relevant Files | Contribution to Glossary |
|---|---|---|
| [docs/tests/source/UI/schemas] | `[path]`, `[path]` | [terms, rules, or context evidence found] |

## Maintenance Notes

- Update this glossary when business terminology, lifecycle states, rules, or context boundaries change.
- Preserve domain-expert-confirmed definitions unless a human explicitly revises them.
- Add terminology drift to `Language Tensions` instead of silently normalizing it.
- Keep technical implementation details in architecture or API documentation rather than this glossary.
