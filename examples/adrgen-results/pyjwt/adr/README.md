# Architecture Decision Records

Last ADR Index Update: 2026-07-06T14:52:12Z
Updated By: agent

## Purpose

This directory records architectural decisions, decision candidates, and preparation documents for PyJWT.

## Status Legend

- `PROPOSED`
- `ACCEPTED`
- `REJECTED`
- `SUPERSEDED`
- `DEPRECATED`
- `PREPARATION`
- `NEEDS REVIEW`

## ADRs

No ADR files are present yet.

## Candidate Documents

| File | Notes |
|---|---|
| `ADR_CANDIDATES.md` | Discovery output created from direct repository inspection on 2026-07-06. Contains four candidate decisions with review markers still set to `new` and `undecided`. |

## Agent Guidance

Before changing architecture-sensitive code in PyJWT:

1. Check whether `ADR_CANDIDATES.md` already describes the boundary you are touching.
2. Verify the relevant source module, tests, and workflow files before assuming the candidate is still current.
3. Preserve documented trade-offs and missing rationale instead of replacing them with speculation.
4. Generate ADR drafts only after a human marks a candidate ready or explicitly requests it.