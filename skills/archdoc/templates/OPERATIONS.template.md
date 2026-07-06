# Operations

Last Reviewed Scope: [full review | delta update | targeted area]  
Doc Status: [MAINTAINED | DRAFT | NEEDS REVIEW]  
Last Operations Update: [YYYY-MM-DDTHH:MM:SSZ]  
Updated By: [human | agent | human+agent]  
Source Basis: [README scan | code scan | tests run | app run locally | deployment files | logs | other]  

Related docs:
- `REPO_MAP.md` — repository orientation, important files, commands, conventions, glossary.
- `ARCHITECTURE.md` — static architecture, modules, boundaries, dependencies, data ownership.

## Purpose

This document explains how the system runs, how to operate it, how to debug it, and how to make safe changes.

It covers dynamic behavior:
- local execution
- runtime modes
- deployment
- scheduling
- configuration and secrets
- observability
- failure modes
- recovery
- safe operational workflows

## Evidence Legend

Use these labels when documenting operational claims:

- **verified**: directly confirmed from code, config, tests, logs, or executed commands.
- **inferred**: likely true based on naming, imports, structure, or partial evidence.
- **uncertain**: plausible but not sufficiently supported.
- **missing**: expected information was not found.

## Runtime Overview

[Summarize the deployed runtime shape: services, workers, scheduled jobs, containers, processes, serverless functions, CLIs, or local-only scripts.]

| Runtime unit | Type | Started by | Runs where | Purpose | Evidence | Status |
|---|---|---|---|---|---|---|
| [service/process/job] | [API/worker/CLI/etc.] | [command/orchestrator] | [local/container/cloud] | [what it does] | [`path`] | [verified/inferred] |
| [service/process/job] | [API/worker/CLI/etc.] | [command/orchestrator] | [local/container/cloud] | [what it does] | [`path`] | [verified/inferred] |

## Local Development Quick Start

### Prerequisites

- [runtime / language version]
- [package manager]
- [database / service dependency]
- [Docker or other platform dependency]
- [required credentials or local `.env` values]

### Install

```bash
[install command]
```

Notes:
- [Important install caveat]
- [Known setup gap]

### Configure

```bash
[copy or create env/config command]
```

Required local configuration:
- `[ENV_VAR]`: [safe example or placeholder]
- `[ENV_VAR]`: [safe example or placeholder]

### Run Locally

```bash
[local run command]
```

Expected result:
- [port, URL, CLI output, log line, or other signal]
- [how to stop the process]

### Test

```bash
[test command]
```

Expected result:
- [what passing looks like]
- [known failing tests, flaky tests, or missing tests]

### Build

```bash
[build command]
```

Expected result:
- [artifact, output folder, image, binary, or package]

## Command Map

| Task | Command | Purpose | Evidence | Status |
|---|---|---|---|---|
| Install | `[command]` | [what it does] | [`README`, package file, etc.] | [verified/inferred] |
| Run dev | `[command]` | [what it starts] | [`path`] | [verified/inferred] |
| Test | `[command]` | [what it checks] | [`path`] | [verified/inferred] |
| Build | `[command]` | [what it produces] | [`path`] | [verified/inferred] |
| Deploy | `[command]` | [what it changes] | [`path`] | [verified/inferred/unknown] |

## Execution Model

**[Primary service or control plane]**:  
[How it is started, what triggers work, and how it delegates or executes tasks.]

**[Worker or batch path]**:  
[How one-shot jobs run, what they do, and how they complete.]

**[CLI or script path]**:  
[How manual or scripted operations are invoked.]

Stateful runtime exceptions:
- [persisted sessions]
- [mounted volumes]
- [caches]
- [shared profiles]
- [temporary artifacts]
- [locks or concurrency controls]

## Runtime Modes

| Mode | Command / trigger | Config source | Purpose | Differences / caveats |
|---|---|---|---|---|
| development | `[command]` | [env/config] | [purpose] | [notes] |
| test | `[command]` | [env/config] | [purpose] | [notes] |
| production | `[command]` | [env/config] | [purpose] | [notes] |
| worker | `[command]` | [env/config] | [purpose] | [notes] |

## Environment and Secrets

[State where secrets live, how configuration is loaded, and any runtime caveats. Never include real secret values.]

| Variable / secret | Required | Used by | Purpose | Safe example | Source / file | Restart needed? | Status |
|---|---|---|---|---|---|---|---|
| `[ENV_VAR]` | [yes/no] | [module/service] | [purpose] | `[example]` | [`path` or platform] | [yes/no] | [verified/inferred] |
| `[ENV_VAR]` | [yes/no] | [module/service] | [purpose] | `[example]` | [`path` or platform] | [yes/no] | [verified/inferred] |

Precedence rules:
1. [highest priority config source]
2. [next priority config source]
3. [default config source]

Host-vs-container differences:
- [difference]
- [difference]

Secrets rotation:
- [how rotated values are picked up]
- [what needs restart or redeploy]
- [how to verify rotation worked]

## Configuration Points

| Config file / flag | Purpose | Affects | Default / example | Evidence | Status |
|---|---|---|---|---|---|
| `[config file or flag]` | [what it configures] | [service/module] | [value] | [`path`] | [verified/inferred] |
| `[config file or flag]` | [what it configures] | [service/module] | [value] | [`path`] | [verified/inferred] |

Important configuration caveats:
- [feature flags]
- [runtime options]
- [environment-specific behavior]
- [generated config]
- [missing sample config]

## Docker and Container Notes

- **Base image / runtime**: [image, runtime version, or execution environment]
- **Timezone / locale**: [relevant setting]
- **Working directory**: [path or package root]
- **Dependency installation**: [how dependencies are installed or supplied]
- **Source code mounting / packaging**: [copy, bind mount, artifact, image build]
- **Networking**: [exposed ports, internal-only services, service names]
- **Restart policy**: [which services restart automatically and which do not]
- **Persistent state**: [volumes, mounted profiles, caches, artifacts]
- **Resource limits**: [CPU/memory/storage if configured]
- **User / permissions**: [root/non-root, mounted file permissions]
- **Health check**: [configured or missing]

Docker commands:

```bash
[build/run/compose command]
```

## Deployment

Deployment target:
- [host, VPS, Kubernetes, serverless, PaaS, static host, local-only, unknown]

Deployment inputs:
- [source branch/tag]
- [build artifact]
- [container image]
- [environment variables]
- [migration step]
- [external services]

Deployment procedure:

```bash
[deployment command sequence]
```

Start command:

```bash
[start command]
```

Health check:
- [URL, command, log line, smoke test, or missing]

Rollback:
- [rollback command or manual procedure]
- [data migration rollback caveat]
- [known limitation]

Deployment evidence:
- [`path/to/deployment/file`]
- [`path/to/ci/file`]
- [`README section`]

Status: [verified/inferred/uncertain/missing]

## Deployment Boundaries

| Boundary | What runs there | Reachability | State stored there | Notes |
|---|---|---|---|---|
| [host/platform] | [service] | [public/internal/local] | [state] | [notes] |
| [network boundary] | [service] | [public/internal/local] | [state] | [notes] |
| [scheduler/orchestrator] | [job/service] | [n/a] | [state] | [notes] |

Call out anything intentionally single-host, internal-only, local-only, or otherwise constrained.

## Cron, Scheduling, and Triggers

[Describe where scheduling lives and how jobs are triggered. If there are no schedules, state the alternative trigger model.]

| Job / workflow | Trigger | Cadence | Timezone | Overlap behavior | Failure behavior | Evidence | Status |
|---|---|---|---|---|---|---|---|
| [job] | [cron/event/manual/API] | [cadence] | [timezone] | [allowed/prevented/unknown] | [retry/log/fail] | [`path`] | [verified/inferred] |
| [job] | [cron/event/manual/API] | [cadence] | [timezone] | [allowed/prevented/unknown] | [retry/log/fail] | [`path`] | [verified/inferred] |

Concurrency notes:
- [whether jobs can overlap]
- [locks or deduplication]
- [shared state risks]

## External Runtime Dependencies

| Dependency | Required for local? | Required for production? | Health check | Failure symptom | Evidence | Status |
|---|---|---|---|---|---|---|
| [database/API/queue/storage/etc.] | [yes/no] | [yes/no] | [how to check] | [symptom] | [`path`] | [verified/inferred] |
| [database/API/queue/storage/etc.] | [yes/no] | [yes/no] | [how to check] | [symptom] | [`path`] | [verified/inferred] |

## One Real User Action Trace

Pick one meaningful user action and trace it end to end. This is the fastest operational path for agents to understand how the system behaves.

Flow: [example: login / create project / upload file / send message / process payment / run job]

```text
user action
-> route / command / event
-> handler
-> service
-> model / repository
-> database or external dependency
-> response / side effect
```

| Step | File / function | What happens | How to verify | Status |
|---|---|---|---|---|
| 1 | [`path:function`] | [what happens] | [log/test/manual check] | [verified/inferred] |
| 2 | [`path:function`] | [what happens] | [log/test/manual check] | [verified/inferred] |
| 3 | [`path:function`] | [what happens] | [log/test/manual check] | [verified/inferred] |

Notes:
- [Important branching behavior]
- [Validation point]
- [Persistence point]
- [External side effect]
- [Error path]

## Main Runtime Flows

| Flow | Starts at | Goes through | Ends at | Data touched | Tests / checks | Status |
|---|---|---|---|---|---|---|
| [flow name] | [`path`] | [modules] | [result] | [entities] | [tests] | [verified/inferred] |
| [flow name] | [`path`] | [modules] | [result] | [entities] | [tests] | [verified/inferred] |

## Data Flow and Persistence

Important data path:

```text
input -> validate -> transform -> store -> return
```

| Data item | Source | Validation | Transformation | Storage | Returned / emitted to | Evidence | Status |
|---|---|---|---|---|---|---|---|
| [data] | [source] | [where validated] | [where changed] | [where stored] | [destination] | [`path`] | [verified/inferred] |
| [data] | [source] | [where validated] | [where changed] | [where stored] | [destination] | [`path`] | [verified/inferred] |

Persistence notes:
- [database/file/object storage/cache]
- [migrations]
- [retention]
- [backup relevance]
- [manual cleanup risks]

## Background Jobs and Queues

| Job / worker | Trigger | Queue / scheduler | Retry behavior | Idempotency concern | Failure handling | Evidence | Status |
|---|---|---|---|---|---|---|---|
| [job] | [trigger] | [queue] | [retry] | [concern] | [behavior] | [`path`] | [verified/inferred] |
| [job] | [trigger] | [queue] | [retry] | [concern] | [behavior] | [`path`] | [verified/inferred] |

## Logging and Observability

- **Application logs**: [where to find them]
- **Worker or batch logs**: [where to find them]
- **Access logs**: [where to find them]
- **Error logs**: [where to find them]
- **Debug mode or verbose flags**: [how to enable and what they show]
- **Metrics**: [system, app, business, none, unknown]
- **Tracing**: [available/missing/unknown]
- **Health signals**: [health endpoint, readiness check, heartbeat, none]
- **Alerting**: [configured/missing/unknown]

Useful log searches:

```bash
[representative grep/journalctl/docker logs command]
```

If observability is limited, state what operators should inspect first:
1. [first place]
2. [second place]
3. [third place]

## Debugging Guide

Common debugging paths:

| Problem | Inspect first | Useful command / file | Notes |
|---|---|---|---|
| App does not start | [logs/config] | `[command]` | [notes] |
| Request fails | [route/service/logs] | `[command]` | [notes] |
| Job fails | [worker logs/queue] | `[command]` | [notes] |
| External API fails | [credentials/network/response] | `[command]` | [notes] |
| Database issue | [connection/migrations/data] | `[command]` | [notes] |

Debugger notes:
- [breakpoint support]
- [interactive shell]
- [test debugging]
- [local reproduction path]

## Failure Modes

| Failure | Symptom | Likely cause | Where to look | Current behavior | Recovery | Status |
|---|---|---|---|---|---|---|
| [failure class] | [symptom] | [cause] | [logs/files/service] | [retry/crash/fallback] | [fix] | [verified/inferred] |
| [failure class] | [symptom] | [cause] | [logs/files/service] | [retry/crash/fallback] | [fix] | [verified/inferred] |
| [failure class] | [symptom] | [cause] | [logs/files/service] | [retry/crash/fallback] | [fix] | [verified/inferred] |

## Manual Recovery Notes

### [Recovery Scenario]

```bash
[representative command sequence]
```

Expected result:
- [what success looks like]

Risks:
- [data loss, duplicate side effects, downtime, etc.]

### [Recovery Scenario]

```bash
[representative command sequence]
```

Expected result:
- [what success looks like]

Risks:
- [data loss, duplicate side effects, downtime, etc.]

Include any artifact paths, diagnostics files, dry-run options, or backup files operators should inspect during recovery.

## Backups and Persistent State

| State | Location | Backup mechanism | Restore mechanism | Risk | Status |
|---|---|---|---|---|---|
| [database/files/cache/etc.] | [location] | [backup] | [restore] | [risk] | [verified/inferred/unknown] |
| [database/files/cache/etc.] | [location] | [backup] | [restore] | [risk] | [verified/inferred/unknown] |

State notes:
- [what is safe to delete]
- [what must not be deleted]
- [temporary vs durable state]
- [migration concerns]

## Security Operations

- **Secrets storage**: [where/how]
- **Access control**: [who can deploy or operate]
- **Sensitive logs**: [whether secrets/user data could appear in logs]
- **Credential rotation**: [procedure]
- **Production data handling**: [rules]
- **Local development data**: [safe sample data or anonymized data]

Known gaps:
- [gap]
- [gap]

## Current Operational Health

| Check | Status | Evidence | Notes |
|---|---|---|---|
| App runs locally | [yes/no/unknown] | [command/log] | [notes] |
| Tests pass | [yes/no/partial/unknown] | [command/output] | [notes] |
| Build passes | [yes/no/unknown] | [command/output] | [notes] |
| Deployment documented | [yes/no/partial/unknown] | [`path`] | [notes] |
| Health check exists | [yes/no/unknown] | [`path`] | [notes] |
| Logs are accessible | [yes/no/unknown] | [location] | [notes] |
| Recovery path documented | [yes/no/partial/unknown] | [section/path] | [notes] |

## Safe Change Workflow

Recommended workflow for agents and maintainers:

1. Read `REPO_MAP.md` for orientation.
2. Identify the relevant module in `ARCHITECTURE.md`.
3. Search for similar existing code before inventing a new pattern.
4. Trace the relevant runtime flow in this document.
5. Make one tiny safe change.
6. Run the narrowest relevant test first.
7. Run broader tests or build.
8. Run the app locally if the change affects runtime behavior.
9. Review the diff.
10. Update `REPO_MAP.md`, `ARCHITECTURE.md`, or `OPERATIONS.md` if behavior or structure changed.

Useful commands:

```bash
[format/lint/test/build commands]
```

## Extending Operations

To add a new operational workflow, service, or job:

1. [Add code or config]
2. [Add environment/config]
3. [Add tests or smoke check]
4. [Add logs/metrics/health signal]
5. [Document command or deployment change]
6. [Update failure and recovery notes]

## Operational Gaps and Known Unknowns

- [Could not determine production deployment target]
- [Could not verify whether tests pass]
- [Could not find health check]
- [Could not determine backup strategy]
- [Could not determine secret rotation behavior]

## Additional Notes

**Time handling**: [timezone assumptions, conversion rules, display conventions]

**Concurrency**: [whether jobs can overlap, block, or share state]

**Testing**: [how to rehearse or dry-run operations safely]

**Extensibility**: [high-level steps to add a new operational workflow, service, or job]

**Operator guidance**: [anything else operators should know]