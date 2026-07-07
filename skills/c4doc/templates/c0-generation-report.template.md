# C4 Documentation Generation Report

> Generated with `ai-craftkit` skill: `c4doc`  
> Source: `<repository-url>` at commit `<commit-hash>`  
> Prompt: `<exact-user-prompt>`

## Summary

| Field | Value |
|---|---|
| Repository | `<repository-name>` |
| Main system | `<system-name>` |
| Generated/updated | `<yyyy-mm-dd>` |
| Generator | `c4doc` |
| Repository type | `<library / CLI / service / web app / multi-service / mixed>` |
| Recommended documentation depth | `<context only / context + container / context + container + component / full useful set>` |

## Files Inspected

| Path | Purpose | Result |
|---|---|---|
| `<README.md>` | Repository overview | `<found / not found / relevant notes>` |
| `<build file>` | Language/build/dependencies | `<found / not found / relevant notes>` |
| `<source path>` | Runtime/component structure | `<found / not found / relevant notes>` |
| `<deployment file>` | Deployment topology | `<found / not found / relevant notes>` |
| `<workflow file>` | CI/CD hints | `<found / not found / relevant notes>` |

## Detected Technologies

| Category | Detected technology | Evidence | Confidence |
|---|---|---|---|
| Language | `<language>` | `<path>` | `<Confirmed / Inferred>` |
| Runtime | `<runtime>` | `<path>` | `<Confirmed / Inferred / Unknown>` |
| Framework | `<framework>` | `<path>` | `<Confirmed / Inferred / Needs review>` |
| Data store | `<database/cache/object store>` | `<path>` | `<Confirmed / Inferred / Unknown / Needs review>` |
| Messaging | `<queue/topic/event system>` | `<path>` | `<Confirmed / Inferred / Unknown / Needs review>` |
| Deployment | `<Docker/Kubernetes/Helm/cloud/local>` | `<path>` | `<Confirmed / Inferred / Unknown / Needs review>` |

## Generated Files

| File | Template | Reason |
|---|---|---|
| `docs/c4-documentation/index.md` | `c0-index.template.md` | Entry point for architecture docs |
| `docs/c4-documentation/architecture-model.md` | `c0-architecture-model.template.md` | Shared model behind diagrams |
| `docs/c4-documentation/system-context.md` | `c1-system-context.template.md` | `<reason>` |
| `docs/c4-documentation/container.md` | `c2-container.template.md` | `<reason>` |
| `docs/c4-documentation/components/<container-name>.md` | `c3-component.template.md` | `<reason>` |
| `docs/c4-documentation/code/<component-name>.md` | `c4-code.template.md` | `<reason>` |
| `docs/c4-documentation/deployment/<environment-or-platform>.md` | `deployment.template.md` | `<reason>` |
| `docs/c4-documentation/dynamic/<use-case>.md` | `dynamic-flow.template.md` | `<reason>` |

## Skipped Views

| View | Status | Reason |
|---|---|---|
| C1 System Context | `<Generated / Skipped>` | `<reason>` |
| C2 Container | `<Generated / Skipped>` | `<reason>` |
| C3 Component | `<Generated / Skipped>` | `<reason>` |
| C4 Code | `<Generated / Skipped>` | `<reason>` |
| Deployment | `<Generated / Skipped>` | `<reason>` |
| Dynamic Flow | `<Generated / Skipped>` | `<reason>` |

## Confirmed Architecture Facts

| Fact | Evidence |
|---|---|
| `<fact>` | `<path>` |

## Inferred Architecture Facts

| Inference | Evidence | Review need |
|---|---|---|
| `<inference>` | `<path or convention>` | `<why maintainers should review>` |

## Unknowns

| Unknown | Why it matters | Suggested next step |
|---|---|---|
| `<unknown>` | `<impact>` | `<review source / ask maintainer / inspect environment>` |

## Human Review Checklist

- [ ] Confirm the system name and boundary.
- [ ] Confirm people/user roles.
- [ ] Confirm external systems.
- [ ] Confirm container names and responsibilities.
- [ ] Confirm technology labels.
- [ ] Confirm deployment topology.
- [ ] Confirm component boundaries.
- [ ] Remove any artificial or unsupported diagram elements.
- [ ] Check Mermaid rendering in GitHub.
- [ ] Decide whether additional dynamic flows are needed.

## Change Notes

| Date | Change | Notes |
|---|---|---|
| `<yyyy-mm-dd>` | `<created / refreshed / revised>` | `<notes>` |
