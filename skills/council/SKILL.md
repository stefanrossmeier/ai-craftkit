---
name: council
description: Deliberate a decision through five advisers and a chair. Use when the user calls /council with a decision to analyze, or wants role-separated reasoning with built-in dissent and one committed recommendation instead of a hedged answer.
license: Apache-2.0
---

# Council Skill

Command: `/council`

Run a pending decision through a structured council: five advisers argue one after another, a chair closes with one clear recommendation. English adaptation of "Rat der 5 Berater" (Niklas Volland, niklas.how/268).

## Invocation Model

```text
/council <decision and its context>
```

Text after `/council` is the decision plus everything that matters: numbers, deadlines, options, constraints, what the user cares about. If the context is thin, ask once for the missing facts rather than inventing them — the council argues better with more context.

## The Six Roles

The council consists of five advisers and one chair:

1. **The Critic** — hunts for every reason the decision could go wrong.
2. **The First-Principles Thinker** — breaks the problem down into its basic building blocks.
3. **The Visionary** — shows what is possible in the best case.
4. **The Outsider** — says what someone without the user's prior knowledge would see.
5. **The Doer** — states what must concretely be done next, starting tomorrow.
6. **The Chair** — consolidates all input into one clear, committed recommendation.

The first-principles thinker and the outsider exist to take the question apart and strip the user's assumptions — the two things a single agreeable answer never does. The chair must not hedge: one recommendation, stated plainly.

## Procedure

Render the council as a dialogue. Each adviser answers in order, in character, referencing (and disagreeing with) what earlier advisers said where warranted:

1. Announce the decision under deliberation.
2. Let each of the five advisers speak in sequence (2–5 sentences each; dissent is expected, not smoothed over).
3. Close with the chair: a short synthesis and **one clear recommendation** the user can act on.

Present the result in chat. The chair's recommendation is a decision to test, not a verdict — for money, legal, or health decisions, real checks still apply.

## Adaptation

For technical decisions, the adviser seats may be swapped for domain roles (security reviewer, cost owner, on-call engineer), but the structure stays: named roles, fixed order, one forced conclusion.
