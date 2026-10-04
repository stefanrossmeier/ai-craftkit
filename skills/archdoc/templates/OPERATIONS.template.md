# Operations

Review Scope: [full | targeted area | delta]
Doc Status: [MAINTAINED | DRAFT | NEEDS REVIEW]
Last Updated: [YYYY-MM-DDTHH:MM:SSZ]
Updated By: [human | agent | human+agent]
Source Repository: [canonical repository URL | unavailable]
Source Revision: [git SHA | unavailable]
Source Basis: [runtime config, scripts, workflows, deployment files, tests, other]

Related docs:
- `REPO_MAP.md` — repository orientation and commands.
- `ARCHITECTURE.md` — static components and boundaries.
- `API_SURFACE.md` — contracts, when present.
- `../adr/` — operationally relevant decisions, when present.

## Purpose

Describe how the repository is built, executed, verified, deployed or released, observed, and recovered based on repository evidence.

This document does not claim to describe live production state unless live evidence was explicitly supplied.

## Execution Modes

| Mode | Entry point / command | Purpose | Dependencies | Status |
|---|---|---|---|---|
| [service/CLI/worker/library build/etc.] | [`path` / command] | [purpose] | [dependencies] | [verified/inferred] |

## Local Development and Verification

```bash
[install/bootstrap command if evidenced and safe]
[build command]
[test command]
[run command if applicable]
```

Notes:
- [required tool/runtime version]
- [external dependency]
- [known limitation]

Do not invent conventional commands. Do not include secret values.

## Configuration

| Name / file | Purpose | Required | Source / default | Status |
|---|---|---|---|---|
| [`ENV_NAME` / path] | [purpose] | [yes/no/unknown] | [`path` / safe default] | [verified/inferred] |

Document names and behavior, never credentials or secret contents.

## Runtime Dependencies

| Dependency | Used by | Purpose | Failure effect | Evidence | Status |
|---|---|---|---|---|---|
| [DB/API/queue/filesystem/etc.] | [module] | [purpose] | [effect] | [`path`] | [verified/inferred] |

## Important Runtime Flows

### [Flow name]

1. [trigger/request]
2. [component/action]
3. [dependency/state change]
4. [response/result]

Verification points:
- [log/metric/trace/test/observable output]

Failure path:
- [important failure behavior]

Evidence:
- [`path` / symbol] — [what it confirms] [verified/inferred]

Use a Mermaid sequence diagram only when it materially improves clarity.

## Observability

| Signal | Where produced/configured | What it indicates | Status |
|---|---|---|---|
| [log/metric/trace/health check] | [`path`] | [meaning] | [verified/inferred/missing] |

Call out missing observability only when it matters to an evidenced runtime path.

## Deployment / Release

Include only what exists for this repository.

| Artifact / target | Build source | Delivery mechanism | Config / environment | Evidence | Status |
|---|---|---|---|---|---|
| [artifact/service/package] | [`path` / command] | [container/package/workflow/etc.] | [summary] | [`path`] | [verified/inferred] |

## Failure Modes and Recovery

| Failure | Expected symptom | Detection | Recovery / mitigation | Evidence | Status |
|---|---|---|---|---|---|
| [failure] | [symptom] | [signal] | [action] | [`path` / test / runbook] | [verified/inferred/uncertain] |

Do not invent a recovery procedure when the repository does not provide one; mark it missing.

## Operational Checks

| Check | Command / signal | Expected result | Status |
|---|---|---|---|
| [build/test/health/smoke/etc.] | [command or signal] | [result] | [verified/inferred] |

## Open Questions and Gaps

| Question / gap | Why it matters | Evidence checked | Suggested next step |
|---|---|---|---|
| [question] | [reason] | [`path` / command] | [next step] |
