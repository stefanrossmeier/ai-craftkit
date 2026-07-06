# API Surface

Last Reviewed Scope: [full review | delta update | targeted area]
Doc Status: [MAINTAINED | DRAFT | NEEDS REVIEW]
Last API Surface Update: [YYYY-MM-DDTHH:MM:SSZ]
Updated By: [human | agent | human+agent]
Source Basis: [README scan | route scan | schema scan | CLI scan | tests run | app run locally | generated docs | other]

Related docs:
- `REPO_MAP.md` — repository orientation, important files, commands, conventions, glossary.
- `ARCHITECTURE.md` — static architecture, modules, boundaries, dependencies, and data ownership.
- `OPERATIONS.md` — runtime behavior, local execution, deployment, debugging, failure modes.
- `docs/adr/` — architectural decisions that explain why public interfaces look this way.

## Purpose

This document describes the public and integration-relevant interface surface of the repository.

It answers:

- Which APIs, commands, events, webhooks, public modules, or integration points exist?
- Who or what calls them?
- Where are they implemented?
- What inputs and outputs matter?
- Which authentication, authorization, validation, and compatibility rules apply?
- Which contracts are verified, inferred, uncertain, or missing?
- What should future humans or agents check before changing an interface?

This document is not an exhaustive generated API reference unless the repository already contains one.

This document owns detailed interface and contract documentation. Keep `ARCHITECTURE.md` at the level of interface ownership and architectural implications, and keep `OPERATIONS.md` focused on runtime behavior, verification, and failure handling.

## Scope

This document covers externally visible and integration-relevant interfaces such as:

- HTTP endpoints
- GraphQL operations
- RPC, gRPC, protobuf, or message contracts
- CLI commands
- public package or library exports
- webhooks
- events
- queues and message payloads
- plugin or extension points
- important file import/export formats
- important environment-controlled interface behavior

Out of scope:

- Full static architecture. See `ARCHITECTURE.md`.
- Local setup, deployment, runtime recovery, and operational checks. See `OPERATIONS.md`.
- File-by-file repository orientation. See `REPO_MAP.md`.
- Full OpenAPI, GraphQL, protobuf, or generated reference duplication when a source spec already exists.
- Product documentation, unless it directly defines an interface contract.

If no meaningful public or integration-relevant interface surface exists, say that explicitly instead of inventing one.

## Evidence Legend

Use these labels when documenting interface claims:

- **verified**: directly confirmed from code, config, schemas, tests, commands, generated docs, or local execution.
- **inferred**: likely true based on naming, imports, route registration, handler structure, schemas, tests, or partial evidence.
- **uncertain**: plausible but not sufficiently supported.
- **missing**: expected information was searched for but not found.

## API Surface Summary

- **Primary interface type**: [HTTP API | CLI | library | events | webhook | GraphQL | RPC | mixed | unknown]
- **Primary consumers**: [frontend, users, other services, scripts, agents, external systems, unknown]
- **Main entry files**: [`path`, `path`]
- **Contract source**: [OpenAPI | GraphQL schema | protobuf | CLI parser | route definitions | tests | README | none found]
- **Authentication model**: [none | token | session | API key | OAuth | mTLS | unknown]
- **Authorization model**: [roles | permissions | policies | ownership checks | unknown]
- **Versioning model**: [URL version | header version | package version | none found | unknown]
- **Stability**: [stable | evolving | internal | deprecated | unknown]
- **Contract confidence**: [high | medium | low | unknown]
- **Most important compatibility risk**: [short statement]

## Interface Inventory

| Interface | Type | Consumer | Entry point | Contract source | Stability | Evidence | Status |
|---|---|---|---|---|---|---|---|
| [name] | [HTTP/CLI/event/library/etc.] | [consumer] | [`path`] | [`schema/spec/test/path`] | [stable/evolving/internal] | [`path`] | [verified/inferred] |
| [name] | [HTTP/CLI/event/library/etc.] | [consumer] | [`path`] | [`schema/spec/test/path`] | [stable/evolving/internal] | [`path`] | [verified/inferred] |

## HTTP API

Include this section only when HTTP endpoints exist or are likely.

### Endpoint Summary

| Method | Path | Handler | Purpose | Auth | Input | Output | Evidence | Status |
|---|---|---|---|---|---|---|---|---|
| [GET/POST/etc.] | `/path` | [`handler`] | [purpose] | [required/none/unknown] | [body/query/path params] | [response shape] | [`path`] | [verified/inferred] |
| [GET/POST/etc.] | `/path` | [`handler`] | [purpose] | [required/none/unknown] | [body/query/path params] | [response shape] | [`path`] | [verified/inferred] |

### Important Endpoints

#### `[METHOD] /path`

- **Purpose**: [what this endpoint does]
- **Consumer**: [frontend/service/user/external system/unknown]
- **Handler**: [`path:function`]
- **Main service path**: [`path:function`]
- **Authentication**: [required/none/unknown]
- **Authorization**: [rule or missing]
- **Input**:
  - Path params: [params]
  - Query params: [params]
  - Body: [schema or important fields]
- **Output**:
  - Success: [status and shape]
  - Failure: [important status codes and error shape]
- **Data touched**: [entities, tables, files, external systems]
- **Validation**: [`path` or missing]
- **Tests**: [`path` or missing]
- **Compatibility notes**: [breaking change concerns]
- **Evidence**:
  - [`path`]&#58; [what it confirms] [verified/inferred/uncertain]

## GraphQL API

Include this section only when GraphQL exists or is likely.

| Operation | Type | Resolver | Input | Output | Auth | Evidence | Status |
|---|---|---|---|---|---|---|---|
| [operation] | [query/mutation/subscription] | [`path`] | [input] | [output] | [rule] | [`path`] | [verified/inferred] |
| [operation] | [query/mutation/subscription] | [`path`] | [input] | [output] | [rule] | [`path`] | [verified/inferred] |

Schema source:
- [`schema.graphql`, generated schema, code-first schema, or missing]

Notes:
- [versioning, federation, resolver ownership, N+1 risk, auth caveat, or missing docs]

## RPC / gRPC / Protobuf

Include this section only when RPC, gRPC, protobuf, or similar contracts exist.

| Service | Method | Request | Response | Implementation | Consumer | Evidence | Status |
|---|---|---|---|---|---|---|---|
| [service] | [method] | [message/schema] | [message/schema] | [`path`] | [consumer] | [`path`] | [verified/inferred] |
| [service] | [method] | [message/schema] | [message/schema] | [`path`] | [consumer] | [`path`] | [verified/inferred] |

Contract files:
- [`path/to/proto-or-schema`]

Compatibility notes:
- [field numbering, backward compatibility, generated code, deprecated messages, unknowns]

## CLI Surface

Include this section only when CLI commands exist or are likely.

### Command Summary

| Command | Entry point | Purpose | Inputs | Output / side effect | Evidence | Status |
|---|---|---|---|---|---|---|
| `[command]` | [`path`] | [purpose] | [args/options/env] | [output/files/network/state] | [`path`] | [verified/inferred] |
| `[command]` | [`path`] | [purpose] | [args/options/env] | [output/files/network/state] | [`path`] | [verified/inferred] |

### Important Commands

#### `[command name]`

- **Purpose**: [what this command does]
- **Entry point**: [`path:function`]
- **Invocation**:
  ```bash
  [safe example command]
  ```
- **Arguments**:
  - `[arg]`: [meaning]
- **Options**:
  - `[option]`: [meaning]
- **Environment variables**:
  - `[ENV_VAR]`: [safe description, no secret value]
- **Output**: [stdout, files, database writes, network calls, artifacts]
- **Exit behavior**: [exit codes, errors, unknown]
- **Tests**: [`path` or missing]
- **Risks**: [file deletion, data mutation, network calls, credentials, unknowns]
- **Evidence**:
  - [`path`]&#58; [what it confirms] [verified/inferred/uncertain]

## Events, Queues, and Messages

Include this section only when events, queues, topics, or message payloads exist.

| Event / message | Producer | Consumer | Transport | Payload | Retry / idempotency | Evidence | Status |
|---|---|---|---|---|---|---|---|
| [event] | [producer] | [consumer] | [queue/topic/bus] | [schema/fields] | [behavior] | [`path`] | [verified/inferred] |
| [event] | [producer] | [consumer] | [queue/topic/bus] | [schema/fields] | [behavior] | [`path`] | [verified/inferred] |

Message contract notes:
- [ordering assumptions]
- [idempotency keys]
- [retry behavior]
- [dead-letter behavior]
- [compatibility concerns]
- [missing schema or test coverage]

## Webhooks and Inbound Integrations

Include this section only when inbound webhooks or external callbacks exist.

| Provider | Endpoint / handler | Purpose | Verification | Payload | Side effects | Evidence | Status |
|---|---|---|---|---|---|---|---|
| [provider] | [`path` or route] | [purpose] | [signature/token/none/unknown] | [payload] | [side effects] | [`path`] | [verified/inferred] |
| [provider] | [`path` or route] | [purpose] | [signature/token/none/unknown] | [payload] | [side effects] | [`path`] | [verified/inferred] |

Security notes:
- [signature verification]
- [replay protection]
- [rate limiting]
- [sensitive data handling]
- [missing verification]

## Public Library / Module Exports

Include this section only when the repository exposes package, SDK, plugin, or library APIs.

| Export | Type | Source | Purpose | Inputs | Output | Stability | Evidence | Status |
|---|---|---|---|---|---|---|---|---|
| `[export]` | [function/class/type/module] | [`path`] | [purpose] | [input] | [output] | [public/internal/unknown] | [`path`] | [verified/inferred] |
| `[export]` | [function/class/type/module] | [`path`] | [purpose] | [input] | [output] | [public/internal/unknown] | [`path`] | [verified/inferred] |

Public API notes:
- [package entry points]
- [types exported]
- [backward compatibility concerns]
- [deprecations]
- [documentation gaps]

## File Import / Export Formats

Include this section only when the system reads or writes important user-visible files.

| Format | Direction | Used by | Schema / structure | Compatibility risk | Evidence | Status |
|---|---|---|---|---|---|---|
| [CSV/JSON/YAML/etc.] | [import/export/both] | [module/command] | [fields] | [risk] | [`path`] | [verified/inferred] |
| [CSV/JSON/YAML/etc.] | [import/export/both] | [module/command] | [fields] | [risk] | [`path`] | [verified/inferred] |

Notes:
- [required fields]
- [optional fields]
- [encoding]
- [migration or versioning concerns]
- [sample files]

## Input and Output Schemas

| Schema / DTO / model | Used by | Direction | Required fields | Optional fields | Validation | Evidence | Status |
|---|---|---|---|---|---|---|---|
| [schema] | [endpoint/command/event] | [input/output/both] | [fields] | [fields] | [`path`] | [`path`] | [verified/inferred] |
| [schema] | [endpoint/command/event] | [input/output/both] | [fields] | [fields] | [`path`] | [`path`] | [verified/inferred] |

Schema notes:
- [shared schema source]
- [generated types]
- [runtime validation]
- [compile-time only validation]
- [missing validation]

## Authentication and Authorization

| Surface | Authentication | Authorization | Enforced where | Failure behavior | Evidence | Status |
|---|---|---|---|---|---|---|
| [endpoint/command/event/export] | [mechanism] | [rule] | [`path`] | [401/403/error/etc.] | [`path`] | [verified/inferred] |
| [endpoint/command/event/export] | [mechanism] | [rule] | [`path`] | [401/403/error/etc.] | [`path`] | [verified/inferred] |

Security notes:
- [where untrusted input enters]
- [where identity is established]
- [where permissions are checked]
- [where validation happens]
- [known missing or uncertain controls]

## Error and Response Conventions

| Surface | Success shape | Error shape | Error source | Status / exit behavior | Evidence | Status |
|---|---|---|---|---|---|---|
| [HTTP/CLI/event/library] | [shape] | [shape] | [where created] | [status code/exit code/retry] | [`path`] | [verified/inferred] |
| [HTTP/CLI/event/library] | [shape] | [shape] | [where created] | [status code/exit code/retry] | [`path`] | [verified/inferred] |

Conventions:
- [status code pattern]
- [error object format]
- [validation error behavior]
- [logging or correlation ID behavior]
- [missing consistency]

## Versioning, Compatibility, and Deprecation

| Surface | Versioning model | Compatibility concern | Deprecated items | Migration path | Evidence | Status |
|---|---|---|---|---|---|---|
| [surface] | [model] | [concern] | [items] | [path] | [`path`] | [verified/inferred] |
| [surface] | [model] | [concern] | [items] | [path] | [`path`] | [verified/inferred] |

Compatibility rules:
- [what counts as a breaking change]
- [what should remain stable]
- [what requires an ADR or release note]
- [what requires consumer coordination]

## Examples and Smoke Checks

Use safe examples only. Do not include real credentials or secret values.

### Example: [Name]

```bash
[safe curl, CLI, or local invocation example]
```

Expected result:
- [status code, output, file, log line, or behavior]

Evidence:
- [`path` or command] [verified/inferred/uncertain]

## Tests and Contract Confidence

| Surface | Test coverage found | Test type | Confidence | Evidence | Gaps |
|---|---|---|---|---|---|
| [endpoint/command/event/export] | [coverage] | [unit/integration/e2e/contract/manual/none] | [high/medium/low] | [`path` or command] | [gap] |
| [endpoint/command/event/export] | [coverage] | [unit/integration/e2e/contract/manual/none] | [high/medium/low] | [`path` or command] | [gap] |

Confidence notes:
- [which contracts are well covered]
- [which contracts are inferred from implementation only]
- [which public surfaces lack tests]
- [which examples should be added]

## API Surface Diagrams

Recommended diagrams to keep current:

- **Interface overview**: [present/missing]
- **Important request sequence**: [present/missing]
- **CLI execution flow**: [present/missing]
- **Event or queue flow**: [present/missing]
- **Webhook verification flow**: [present/missing]

Suggested diagram files:
- `docs/diagrams/api-surface-overview.md`
- `docs/diagrams/request-lifecycle.md`
- `docs/diagrams/cli-command-flow.md`
- `docs/diagrams/event-processing-flow.md`

## High-Risk Interface Changes

| Surface | Why risky | What to inspect first | Required checks | Docs to update | Notes |
|---|---|---|---|---|---|
| [surface] | [risk] | [`path`] | [tests/build/manual] | [docs] | [notes] |
| [surface] | [risk] | [`path`] | [tests/build/manual] | [docs] | [notes] |

Common high-risk changes:
- changing request or response fields
- changing auth behavior
- changing status codes or error format
- changing CLI flags or exit codes
- changing event payloads
- changing webhook verification
- changing exported package APIs
- changing file import/export format
- changing compatibility behavior without tests

## Change Impact Notes

| Change type | Likely affected surfaces | Required checks | Compatibility concern | Docs to update |
|---|---|---|---|---|
| [change type] | [surfaces] | [tests/build/manual] | [concern] | [docs] |
| [change type] | [surfaces] | [tests/build/manual] | [concern] | [docs] |

## Verified / Inferred Claim Register

| Claim | Evidence | Status | Notes |
|---|---|---|---|
| [interface claim] | [`path`, command, spec, or observation] | [verified/inferred/uncertain] | [notes] |
| [interface claim] | [`path`, command, spec, or observation] | [verified/inferred/uncertain] | [notes] |

## Known Unknowns

- [Unknown or missing API/interface information]
- [Unknown or missing schema information]
- [Unknown or missing auth or compatibility information]
- [Unknown or missing tests or examples]

## Agent Work Guide

Before changing public or integration-relevant interfaces:

1. Read this document.
2. Check the implementation entry point listed for the affected surface.
3. Check schemas, validators, tests, and examples.
4. Check `ARCHITECTURE.md` for the owning module and boundaries.
5. Check `OPERATIONS.md` if the change affects runtime behavior, config, deployment, or failure handling.
6. Search ADRs for decisions that explain interface constraints.
7. Preserve compatibility unless the user explicitly asks for a breaking change.
8. Update this document when routes, commands, events, schemas, exports, auth rules, or compatibility behavior change.
9. Mark uncertain behavior clearly instead of inventing a contract.

Rules:
- Do not document private helper functions as public APIs.
- Do not copy secret values.
- Do not duplicate large generated specs.
- Link to generated specs when they exist.
- Prefer verified contracts over inferred behavior.
- Treat undocumented but externally used behavior as a compatibility risk.

## Additional Notes

[Capture assumptions, conventions, near-term evolution, consumer expectations, generated documentation links, or important reader guidance that does not fit cleanly above.]