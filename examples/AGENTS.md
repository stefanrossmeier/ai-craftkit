# Agent instructions

This is a generic example. Adapt commands, paths, and rules to the repository instead of copying it unchanged.

## Repository context

Use architecture documentation selectively:

- Start with `docs/archdoc/REPO_MAP.md` when you need repository orientation.
- Read `docs/archdoc/ARCHITECTURE.md` for architecture-sensitive changes.
- Read relevant records under `docs/adr/` before changing an established architectural choice.
- Read `docs/archdoc/API_SURFACE.md` when changing public or integration-relevant interfaces.
- Read `docs/archdoc/OPERATIONS.md` when changing runtime behavior, configuration, deployment, observability, reliability, or recovery behavior.

Do not load all documentation by default. Read the smallest set relevant to the task.

## Knowledge boundaries

- Treat `docs/archdoc/` as descriptive repository knowledge.
- Treat accepted ADRs as explicit decision records unless a newer ADR supersedes them.
- Do not infer organization-wide engineering standards from recurring repository patterns.
- When repository behavior and documentation disagree, report the conflict and verify the implementation before changing either.

## Before changing code

1. Find the owning module and closest existing implementation of similar behavior.
2. Read the closest relevant tests.
3. Read the architecture/ADR/interface/operations docs required by the task.
4. Make the smallest coherent change.
5. Run the narrowest relevant verification first, then broader checks required by the repository.
6. Update architecture or decision documentation when the change makes it stale.

## Repository verification

Replace these placeholders with the repository's real commands:

```text
Build: <command>
Test: <command>
Lint/static checks: <command>
```

Never invent conventional commands when the repository defines its own workflow.
