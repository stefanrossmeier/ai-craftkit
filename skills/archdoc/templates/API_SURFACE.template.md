# API Surface

Review Scope: [full | targeted area | delta]
Doc Status: [MAINTAINED | DRAFT | NEEDS REVIEW]
Last Updated: [YYYY-MM-DDTHH:MM:SSZ]
Updated By: [human | agent | human+agent]
Source Repository: [canonical repository URL | unavailable]
Source Revision: [git SHA | unavailable]
Source Basis: [route scan, schema scan, public exports, tests, generated docs, other]

Related docs:
- `REPO_MAP.md` — repository orientation.
- `ARCHITECTURE.md` — owners and boundaries.
- `OPERATIONS.md` — runtime behavior and verification, when present.
- `../adr/` — decisions affecting public contracts, when present.

## Purpose

Document public and integration-relevant contracts without duplicating canonical generated specifications.

## Summary

- **Primary interface types**: [HTTP | CLI | library | event | webhook | RPC | mixed]
- **Primary consumers**: [users/services/scripts/etc.]
- **Canonical contract sources**: [`path`, generated spec, none found]
- **Authentication model**: [summary / not applicable / unknown]
- **Versioning model**: [summary / none found / unknown]

## Interface Inventory

| Interface | Type | Consumer | Owner / entry point | Contract source | Stability | Status |
|---|---|---|---|---|---|---|
| [name] | [HTTP/CLI/event/library/etc.] | [consumer] | [`path` / symbol] | [`path`] | [stable/evolving/internal/unknown] | [verified/inferred] |

Keep this inventory bounded. Link to an existing exhaustive API specification when one exists.

## Important Contracts

### [Interface / endpoint / command / event]

- **Purpose**: [purpose]
- **Consumer**: [consumer]
- **Owner / implementation**: [`path` / symbol]
- **Input / payload**: [important shape or canonical schema link]
- **Output / result**: [important shape]
- **Authentication / authorization**: [rule / not applicable / unknown]
- **Validation**: [rule / source]
- **Failure behavior**: [important errors / exit codes / retry semantics]
- **Compatibility / versioning**: [constraint / unknown]
- **Verification**: [`test`, generated spec, command]
- **Evidence**:
  - [`path` / source] — [claim] [verified/inferred/uncertain]

Repeat this section only for interfaces important enough to deserve prose. Do not expand every trivial handler when a canonical spec already exists.

## Events / Async Contracts

Include only when relevant.

| Event / message | Producer | Consumer | Contract source | Delivery / retry notes | Status |
|---|---|---|---|---|---|
| [name] | [producer] | [consumer] | [`path`] | [ordering/idempotency/retry] | [verified/inferred] |

## Public Library / Extension Surface

Include only when relevant.

| Export / extension point | Source | Purpose | Stability | Verification | Status |
|---|---|---|---|---|---|
| [name] | [`path`] | [purpose] | [public/internal/unknown] | [`test` / docs] | [verified/inferred] |

## Contract Rules and Compatibility

- [versioning/deprecation rule] — [`evidence`] [verified/inferred]
- [compatibility requirement] — [`evidence`] [verified/inferred]

Do not invent a policy when only current implementation behavior is visible.

## Security-Relevant Interface Notes

- [auth boundary, signature verification, trust boundary, sensitive input handling]
- [missing or uncertain control]

Never include secret values, tokens, credentials, or private keys.

## Open Questions and Gaps

| Question / gap | Why it matters | Evidence checked | Suggested next step |
|---|---|---|---|
| [question] | [reason] | [`path` / spec / test] | [next step] |
