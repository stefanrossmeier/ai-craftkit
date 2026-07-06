# Archdoc

`archdoc` is the repository documentation skill in `ai-craftkit`.

## Command

```text
/archdoc
```

It inspects a repository and produces four primary architecture documentation outputs in `docs/`:

- `REPO_MAP.md`
- `ARCHITECTURE.md`
- `API_SURFACE.md`
- `OPERATIONS.md`

Responsibility split:

- `REPO_MAP.md`: repository orientation, important files, commands, conventions, glossary, and agent navigation.
- `ARCHITECTURE.md`: static architecture, modules, boundaries, dependencies, data ownership, and high-level interface ownership.
- `API_SURFACE.md`: detailed public and integration-relevant interfaces, including endpoints, commands, events, exports, schemas, auth rules, and compatibility notes.
- `OPERATIONS.md`: runtime behavior, local execution, deployment, configuration, debugging, failure modes, health checks, recovery, and operational verification.

The skill is evidence-based and should keep these document boundaries clear. Detailed interface contracts belong in `API_SURFACE.md`, not in `ARCHITECTURE.md` or `OPERATIONS.md`.

## Recommended Workflow

1. Start with safe read-only inspection.
2. Inspect the existing docs, manifests, source tree, tests, and runtime files.
3. Generate or update the four documentation files.
4. Remove irrelevant template sections and unresolved placeholders.
5. Mark uncertainty clearly and report the most important gaps.

If the user names a specific area, focus the write-up there but keep enough repository context to stay accurate.

## Safety and Evidence

`archdoc` should prefer repository evidence over assumptions.

It should:

* start with safe read-only inspection
* avoid secrets and never copy secret values
* avoid destructive commands
* avoid installs, servers, Docker, or deployment commands unless explicitly asked or clearly necessary
* mark claims as verified, inferred, uncertain, or missing when needed
