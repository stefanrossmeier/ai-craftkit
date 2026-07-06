# Architecture Decision Records

> Generated with `ai-craftkit` skill: `adrgen`  
> Source: `https://github.com/jpadilla/pyjwt.git` at commit `7144e4534c34810f4525dc4578a32addd8212cff`  
> Prompt: `/adrgen discover Have a look into the pyjwt repo. Find all architecural decisions that are noteworthy and document them as ADR candidates.`

Last ADR Index Update: 2026-07-06T21:50:58Z
Updated By: agent

## Purpose

This directory records architectural decisions, decision candidates, and preparation documents for PyJWT.

## Status Legend

- PROPOSED
- ACCEPTED
- REJECTED
- SUPERSEDED
- DEPRECATED
- PREPARATION
- NEEDS REVIEW

## ADRs

No ADRs are recorded yet.

## Preparation Documents

No preparation documents are recorded yet.

## Candidate Documents

| File | Notes |
|---|---|
| [ADR_CANDIDATES.md](ADR_CANDIDATES.md) | Initial discovery pass covering API layering, crypto optionality, secure decode defaults, JWK and JWKS handling, and extension seams. |

## Agent Guidance

Before changing architecture-sensitive token logic:

1. Read [ADR_CANDIDATES.md](ADR_CANDIDATES.md).
2. Inspect the candidates that touch algorithm selection, claim validation, key handling, or remote JWKS lookup.
3. Preserve the documented security defaults unless the change is explicitly intended to revisit them.
4. Check whether a candidate should be promoted to a real ADR before broadening the implementation.