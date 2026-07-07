# Architecture Model

> Generated with `ai-craftkit` skill: `c4doc`  
> Source: `<repository-url>` at commit `<commit-hash>`  
> Prompt: `<exact-user-prompt>`

## Purpose

This file is the structured source of truth for the architecture documentation in this folder.

The diagrams are derived from these elements and relationships. When updating diagrams, update this model as well.

## Repository Summary

| Field | Value |
|---|---|
| Repository | `<repository-name>` |
| Main system | `<system-name>` |
| Repository type | `<library / CLI / web app / API service / multi-service / infrastructure / mixed>` |
| Primary language(s) | `<languages>` |
| Build tool(s) | `<build-tools>` |
| Runtime(s) | `<runtimes>` |
| Deployment evidence | `<none / Docker / Kubernetes / Helm / Terraform / cloud / unknown>` |
| Last updated | `<yyyy-mm-dd>` |

## Evidence Sources

| Evidence path | What it indicates | Confidence |
|---|---|---|
| `<README.md>` | `<summary>` | `<Confirmed / Inferred / Needs review>` |
| `<build-file>` | `<summary>` | `<Confirmed / Inferred / Needs review>` |
| `<source-path>` | `<summary>` | `<Confirmed / Inferred / Needs review>` |
| `<deployment-file>` | `<summary>` | `<Confirmed / Inferred / Needs review>` |

## People

| ID | Name | Description | Evidence | Confidence |
|---|---|---|---|---|
| `person-user` | `<User role>` | `<How this person uses the system>` | `<path or unknown>` | `<Confirmed / Inferred / Unknown / Needs review>` |

## Software Systems

| ID | Name | Boundary | Description | Evidence | Confidence |
|---|---|---|---|---|---|
| `system-this` | `<System name>` | In scope | `<Main system in this repository>` | `<path>` | `<Confirmed / Inferred>` |
| `system-external-example` | `<External system>` | External | `<External dependency or integration>` | `<path>` | `<Confirmed / Inferred / Needs review>` |

## Containers

In C4, a container is a runnable/deployable application or data store, not necessarily a Docker container.

| ID | Name | Type | Technology | Responsibility | Runs where | Evidence | Confidence |
|---|---|---|---|---|---|---|---|
| `container-main` | `<Main application>` | `<API / CLI / web app / worker / database / queue / library runtime>` | `<technology>` | `<responsibility>` | `<local / container / Kubernetes / unknown>` | `<path>` | `<Confirmed / Inferred / Needs review>` |

## Components

Only include meaningful responsibility boundaries inside selected containers. Do not mirror every package, folder, class, or dependency.

| ID | Container | Name | Responsibility | Source paths | Interfaces | Confidence |
|---|---|---|---|---|---|---|
| `component-example` | `container-main` | `<Component name>` | `<responsibility>` | `<paths>` | `<API / function / interface / event / command>` | `<Confirmed / Inferred / Needs review>` |

## Code Elements

Only include selected code elements when a permanent C4 code view adds value.

| ID | Component | Name | Type | Responsibility | Source path | Confidence |
|---|---|---|---|---|---|---|
| `code-example` | `component-example` | `<Class/function/module>` | `<class / interface / function / module>` | `<responsibility>` | `<path>` | `<Confirmed / Inferred / Needs review>` |

## Relationships

Every relationship should have a meaningful label.

| From | To | Description | Technology / Protocol | Direction | Evidence | Confidence |
|---|---|---|---|---|---|---|
| `person-user` | `system-this` | `<Uses>` | `<HTTPS / CLI / API / unknown>` | `outbound` | `<path>` | `<Confirmed / Inferred / Needs review>` |
| `container-main` | `<target>` | `<Reads/writes/calls/publishes/subscribes>` | `<technology>` | `outbound` | `<path>` | `<Confirmed / Inferred / Needs review>` |

## Deployment Model

| ID | Name | Type | Contains / Hosts | Environment | Evidence | Confidence |
|---|---|---|---|---|---|---|
| `deployment-node-example` | `<Node name>` | `<Kubernetes cluster / namespace / pod / VM / container runtime / managed service>` | `<container IDs>` | `<local / staging / production / unknown>` | `<path>` | `<Confirmed / Inferred / Needs review>` |

## Dynamic Flows

| ID | Name | Trigger | Main participants | Evidence | Confidence |
|---|---|---|---|---|---|
| `flow-example` | `<Use case>` | `<HTTP request / CLI command / event / scheduled job>` | `<participants>` | `<path>` | `<Confirmed / Inferred / Needs review>` |

## Important Omissions

| Omitted item | Reason |
|---|---|
| `<C4 level or element>` | `<Too small / no runtime boundary / no evidence / better handled by generated docs>` |

## Open Questions

| Question | Why it matters | Suggested owner |
|---|---|---|
| `<question>` | `<impact>` | `<maintainer / team / unknown>` |
