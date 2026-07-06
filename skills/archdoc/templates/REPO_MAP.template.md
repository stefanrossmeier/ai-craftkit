# Repo Map

Last Reviewed Scope: [full review | delta update | targeted area]  
Doc Status: [MAINTAINED | DRAFT | NEEDS REVIEW]  
Last Repo Map Update: [YYYY-MM-DDTHH:MM:SSZ]  
Updated By: [human | agent | human+agent]  
Source Basis: [README scan | code scan | tests run | app run locally | git history | other]  

Related docs:
- `ARCHITECTURE.md` — static architecture, modules, boundaries, dependencies, data ownership.
- `OPERATIONS.md` — runtime behavior, local execution, deployment, debugging, failure modes.

## Purpose

This document is the repository orientation map. It answers:

- What is in this repository?
- Where should a human or agent start?
- Which files and folders matter?
- How do you run, test, and inspect the project?
- What vocabulary, conventions, and risks should an agent know before changing code?

## Evidence Legend

Use these labels when documenting repository claims:

- **verified**: directly confirmed from files, commands, tests, or local execution.
- **inferred**: likely true based on naming, imports, structure, or partial evidence.
- **uncertain**: plausible but not sufficiently supported.
- **missing**: expected information was not found.

## Overview

[Summarize what the repository contains, the main product or service it supports, and the dominant implementation style.]

- **Repository type**: [application | library | service | CLI | monorepo | docs | infrastructure | mixed]
- **Primary language/runtime**: [language/runtime]
- **Primary framework/tooling**: [framework/build tool/package manager]
- **Main user-facing surface**: [UI/API/CLI/bot/worker/library/etc.]
- **Main persistence or state**: [database/files/cache/object storage/none/unknown]
- **Deployment style**: [Docker/VPS/cloud/serverless/local-only/unknown]

## README Quick Start and Gaps

| Topic | README says | Repository shows | Status | Gap / note |
|---|---|---|---|---|
| Install | [command/instructions] | [actual files/scripts] | [verified/inferred/missing] | [gap] |
| Run | [command/instructions] | [actual files/scripts] | [verified/inferred/missing] | [gap] |
| Test | [command/instructions] | [actual files/scripts] | [verified/inferred/missing] | [gap] |
| Build | [command/instructions] | [actual files/scripts] | [verified/inferred/missing] | [gap] |
| Deploy | [command/instructions] | [actual files/scripts] | [verified/inferred/missing] | [gap] |

Notes:
- [Outdated README section]
- [Missing setup requirement]
- [First command a new agent should try]

## Root-Level Structure

```text
[repo-root]/
|- [key folder or file]    # [why it matters]
|- [key folder or file]    # [why it matters]
|- [key folder or file]    # [why it matters]
```

## Top-Level Directory Map

| Path | Purpose | Owned capability | Important notes | Status |
|---|---|---|---|---|
| `[path/]` | [what lives here] | [module/product area] | [notes] | [verified/inferred] |
| `[path/]` | [what lives here] | [module/product area] | [notes] | [verified/inferred] |

## Important File Index

| File | Category | Why it matters | Read when | Status |
|---|---|---|---|---|
| `[file]` | [entry/config/test/deploy/docs/source] | [importance] | [when to inspect] | [verified/inferred] |
| `[file]` | [entry/config/test/deploy/docs/source] | [importance] | [when to inspect] | [verified/inferred] |

## Main Entry Files

| Entry file / module | Type | How it is used | Starts / connects to | Evidence | Status |
|---|---|---|---|---|---|
| `[file or module]` | [server/CLI/worker/test/etc.] | [runtime or developer usage] | [downstream modules] | [`path`] | [verified/inferred] |
| `[file or module]` | [server/CLI/worker/test/etc.] | [runtime or developer usage] | [downstream modules] | [`path`] | [verified/inferred] |

Common entry point patterns to check:
- `main()`
- `index.*`
- `server.*`
- `app.*`
- `cli.*`
- framework boot files
- Docker entrypoints
- package scripts
- worker start files
- test setup files

## Commands and Runner Scripts

[Describe the naming convention, invocation pattern, or orchestration role of runnable scripts. If the repo has no such scripts, say so.]

Representative command:

```bash
[representative command or script invocation]
```

| Script / command | Purpose | Defined in | Calls into | Notes | Status |
|---|---|---|---|---|---|
| `[command]` | [install/run/test/build/deploy/etc.] | [`path`] | [`path/module`] | [notes] | [verified/inferred] |
| `[command]` | [install/run/test/build/deploy/etc.] | [`path`] | [`path/module`] | [notes] | [verified/inferred] |

## Test Suite Map

| Test type | Path / command | What it covers | What it does not cover | Status |
|---|---|---|---|---|
| Unit | [`path` / command] | [coverage] | [gap] | [verified/inferred/missing] |
| Integration | [`path` / command] | [coverage] | [gap] | [verified/inferred/missing] |
| E2E | [`path` / command] | [coverage] | [gap] | [verified/inferred/missing] |
| Smoke / manual | [`path` / command] | [coverage] | [gap] | [verified/inferred/missing] |

Known test notes:
- [failing test]
- [flaky test]
- [test requires external dependency]
- [no formal tests found]

## Module Overview

| Module / package / folder | Owns | Main files | Depends on | Tests | Notes | Status |
|---|---|---|---|---|---|---|
| `[module]` | [capability/data/behavior] | [`path`] | [deps] | [`path`] | [notes] | [verified/inferred] |
| `[module]` | [capability/data/behavior] | [`path`] | [deps] | [`path`] | [notes] | [verified/inferred] |

Suggested module categories:
- API / routes
- UI / frontend
- business logic
- domain model
- persistence
- background jobs
- external integrations
- configuration
- shared utilities
- tests
- deployment / infrastructure

## Data Provider and Persistence Modules

| Module | Data source / store | Responsibility | Used by | Notes | Status |
|---|---|---|---|---|---|
| `[module]` | [DB/API/file/cache/etc.] | [what data it provides] | [callers] | [notes] | [verified/inferred] |
| `[module]` | [DB/API/file/cache/etc.] | [what data it provides] | [callers] | [notes] | [verified/inferred] |

Call out shared utility modules that multiple features depend on:
- `[module]`: [why it matters]
- `[module]`: [why it matters]

## Integration Surface

| Surface | Type | Entry point | Auth / routing | Output format / protocol | Status |
|---|---|---|---|---|---|
| [external-facing interface] | [bot/API/CLI/UI/webhook/queue/etc.] | [`path`] | [credentials/routing] | [format] | [verified/inferred] |
| [external-facing interface] | [bot/API/CLI/UI/webhook/queue/etc.] | [`path`] | [credentials/routing] | [format] | [verified/inferred] |

Notes:
- [authentication or routing detail]
- [formatting / protocol detail]
- [external caller expectations]

## Config and Source Files

| File | What it configures or drives | Important values | Used by | Status |
|---|---|---|---|---|
| `[config file]` | [purpose] | [values] | [module/tool] | [verified/inferred] |
| `[data or source file]` | [purpose] | [values] | [module/tool] | [verified/inferred] |

Mention:
- secrets files
- `.env` files
- generated artifact directories
- sample config files
- package manifests
- lockfiles
- type/lint/test config
- framework config

## Runtime and Deployment Files

| File | Purpose | Defines | Used by | Status |
|---|---|---|---|---|
| `[deployment file]` | [what it does] | [services/env/volumes/etc.] | [platform] | [verified/inferred] |
| `[build file]` | [what it does] | [artifact/image/package] | [tool] | [verified/inferred] |
| `[schedule or ops file]` | [what it does] | [jobs/cadence] | [scheduler] | [verified/inferred] |

## Generated, Ignored, and Artifact Paths

| Path | Type | Safe to delete? | Produced by | Notes |
|---|---|---|---|---|
| `[path]` | [generated/cache/build/log/artifact] | [yes/no/unknown] | [command/tool] | [notes] |
| `[path]` | [generated/cache/build/log/artifact] | [yes/no/unknown] | [command/tool] | [notes] |

## Domain Language / Glossary

| Term | Meaning | Where used | Notes |
|---|---|---|---|
| [term] | [definition] | [`path`, module, UI, API] | [notes] |
| [term] | [definition] | [`path`, module, UI, API] | [notes] |

Look for recurring nouns such as:
- account
- user
- workspace
- project
- session
- job
- pipeline
- invoice
- message
- task
- run
- artifact

## Project Conventions

| Convention area | Pattern | Evidence | Notes |
|---|---|---|---|
| Naming | [pattern] | [`path`] | [notes] |
| Folder structure | [pattern] | [`path`] | [notes] |
| API design | [pattern] | [`path`] | [notes] |
| Error handling | [pattern] | [`path`] | [notes] |
| Logging | [pattern] | [`path`] | [notes] |
| Testing | [pattern] | [`path`] | [notes] |
| Database / migrations | [pattern] | [`path`] | [notes] |
| Configuration | [pattern] | [`path`] | [notes] |
| Formatting / linting | [pattern] | [`path`] | [notes] |

## Search Hints for Agents

Useful searches before changing code:

| Goal | Search terms / commands | Why |
|---|---|---|
| Find validation logic | `[search term]` | [why useful] |
| Find auth/session handling | `[search term]` | [why useful] |
| Find database access | `[search term]` | [why useful] |
| Find similar API route | `[search term]` | [why useful] |
| Find background jobs | `[search term]` | [why useful] |
| Find external API calls | `[search term]` | [why useful] |
| Find logging patterns | `[search term]` | [why useful] |
| Find feature flags | `[search term]` | [why useful] |

Example commands:

```bash
rg "[term]"
rg "TODO|FIXME|HACK"
rg "[function or class name]"
```

## Recommended Reading Order

1. **`[doc or file]`**: [why to start here]
2. **`[doc or file]`**: [what it explains next]
3. **`[doc or file]`**: [what it explains next]
4. **`[doc or file]`**: [what it explains next]
5. **`[doc or file]`**: [what it explains next]

For a new agent:
1. Read this file.
2. Read `ARCHITECTURE.md`.
3. Read `OPERATIONS.md`.
4. Inspect the main entry point.
5. Trace one real runtime flow.
6. Search for similar code before making changes.

## Agent Work Guide

Before changing code:

1. Identify the relevant module from the module overview.
2. Search for similar existing code.
3. Read the closest tests.
4. Trace the relevant runtime flow in `OPERATIONS.md`.
5. Make the smallest safe change.
6. Run the narrowest relevant test first.
7. Run broader tests or build.
8. Update docs if structure or behavior changed.

Rules:
- Do not invent a new pattern until existing patterns have been searched.
- Prefer small, reviewable diffs.
- Preserve project conventions.
- Mark uncertain findings instead of pretending they are verified.
- Add open questions when evidence is missing.

## High-Risk Areas

| Risk area | What can break | Why risky | Likely symptoms | Inspect first | Tests / checks |
|---|---|---|---|---|---|
| [auth/payments/migrations/jobs/etc.] | [failure] | [reason] | [symptoms] | [`path`] | [command] |
| [auth/payments/migrations/jobs/etc.] | [failure] | [reason] | [symptoms] | [`path`] | [command] |
| [auth/payments/migrations/jobs/etc.] | [failure] | [reason] | [symptoms] | [`path`] | [command] |

## Current Repository Health

| Check | Status | Evidence | Notes |
|---|---|---|---|
| README exists and is useful | [yes/no/partial/unknown] | [`path`] | [notes] |
| Install command identified | [yes/no/unknown] | [command/path] | [notes] |
| Run command identified | [yes/no/unknown] | [command/path] | [notes] |
| Tests identified | [yes/no/partial/unknown] | [command/path] | [notes] |
| Build identified | [yes/no/unknown] | [command/path] | [notes] |
| Main entry points identified | [yes/no/partial/unknown] | [`path`] | [notes] |
| Deployment files identified | [yes/no/partial/unknown] | [`path`] | [notes] |
| Config points identified | [yes/no/partial/unknown] | [`path`] | [notes] |

## Open Questions and Gaps

| Question / gap | Why it matters | Evidence checked | Suggested next step |
|---|---|---|---|
| [question] | [reason] | [`path` or command] | [next step] |
| [question] | [reason] | [`path` or command] | [next step] |

## Additional Notes

- **[Cross-cutting note]**: [timezone, environment mode, persistence rule, debug flag, or similar]
- **[Cross-cutting note]**: [timezone, environment mode, persistence rule, debug flag, or similar]
- **[Cross-cutting note]**: [timezone, environment mode, persistence rule, debug flag, or similar]