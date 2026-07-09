# Cockburn Review Skill

Command: `/cockburn-review`

Generate an evidence-based architectural boundary review for the currently opened repository.

The skill inspects the repository, applies the "not my job" and "no need to know" architectural lens, fills the bundled review template, removes unused template sections, and writes the final report to the repository's `docs/` folder.

## Invocation Model

Use this skill when the user calls:

```text
/cockburn-review
```

This is a skill invocation, not a shell command. It has no command-line parameters, flags, modes, or options.

If the user adds text around or after the invocation, treat that text as plain-language review guidance. Do not parse it as command syntax.

Examples of plain-language guidance:

- focus on one module or product area
- review the current change set if repository diff information is available
- stress-test the architecture against a named future change
- pay special attention to framework leakage, persistence coupling, or duplicated policy

Do not document or advertise flag-based usage for this skill.

## Purpose

`/cockburn-review` discovers architectural weaknesses by inspecting how responsibilities and knowledge move across repository boundaries.

It asks two core questions:

1. **Not my job**: Is this code doing work that appears to belong to another architectural role?
2. **No need to know**: Does this code know implementation details that should be hidden behind a boundary?

The goal is not to create generic architecture documentation. The goal is to produce a concrete, evidence-based review that helps humans and agents make safer architectural changes.

## Required Output File

Generate or update exactly this primary report:

```text
docs/COCKBURN_REVIEW.md
```

Create `docs/` if it does not exist.

Do not place the generated report outside `docs/`.

Do not modify application source code.

Do not modify unrelated documentation unless the user explicitly asks.

## Template Location

Use the bundled template as the conceptual source:

```text
templates/COCKBURN_REVIEW.template.md
```

The template lives inside this skill package. When generating the final repository report, adapt the template to the repository under review.

The final generated `docs/COCKBURN_REVIEW.md` must not look like an unfilled template.

Before writing the final report:

1. Fill sections with concrete repository-specific information.
2. Delete placeholder-only sections.
3. Delete irrelevant sections.
4. Delete empty tables.
5. Delete unused example rows.
6. Delete unresolved bracket placeholders such as `[path]`, `[module]`, `[status]`, or `[finding]`.
7. Keep useful unknowns only when the missing information matters.
8. Prefer concise, evidence-rich findings over generic architectural advice.

## Lightweight Provenance Block

Every generated report must include a small provenance block near the top, directly after the title and before the document status fields.

Include only information that is directly available. Do not guess, infer, reconstruct, or invent missing metadata.

Use this format:

```markdown
> Generated with `ai-craftkit` skill: `cockburn-review`  
> Source: `<repository-url>` at commit `<commit-hash>`  
> Prompt: `<exact-user-prompt>`
```

If repository URL or commit hash cannot be determined, write `unknown` for that field.

## Evidence Policy

This skill has a strict no-evidence rule.

A report finding must not be included unless it is supported by concrete repository evidence.

Acceptable evidence includes:

- file paths
- line ranges, symbols, functions, classes, exports, or modules when available
- imports and dependency direction
- call chains
- route, CLI, event, or worker registration
- tests and test setup
- duplicated constants, schemas, policies, or conditions
- manifests, config files, and package scripts
- existing documentation
- safe read-only command output
- observed file and folder structure

Every finding must include an **Evidence** subsection or evidence table with enough detail for a reader to locate and verify the claim.

Prefer this style:

```md
Evidence:
- `src/domain/orders/OrderPolicy.ts`: imports `DatabaseOrderStatus`, tying a domain policy to persistence representation. Status: verified.
- `tests/domain/orders/OrderPolicy.test.ts`: requires database status fixtures to test order lifecycle rules. Status: verified.
```

Do not use this style:

```md
The domain layer seems coupled to the database.
```

unless the report immediately provides repository evidence for that claim.

## Claim Status Labels

Use these labels when needed:

- **verified**: directly confirmed from code, config, tests, command output, or explicit documentation.
- **inferred**: likely true based on naming, imports, structure, or partial evidence.
- **uncertain**: plausible but not sufficiently supported.
- **missing**: expected information was searched for but not found.

A finding may include inferred interpretation, but the underlying observation must be verified or supported by explicitly cited repository evidence.

For high-severity findings, prefer at least two independent evidence points unless a single code path is explicit and decisive.

## Required Finding Structure

Each reported finding should include:

- short title
- type
- severity
- confidence
- affected area
- evidence
- observed behavior
- Cockburn framing
- why it may be an architectural weakness
- future change likely to become harder
- suggested architectural move
- what not to over-fix

Finding type should use one or more of these labels:

- Not my job
- No need to know
- Both
- Boundary bypass
- Responsibility drift
- Framework leakage
- Semantic duplication
- Change amplification
- Abstraction leak
- Utility sinkhole
- Policy scattered across layers
- Data ownership confusion
- Test setup boundary smell

Severity values:

- **High**: likely to amplify future change, weaken data ownership, or make a core business capability harder to evolve.
- **Medium**: a localized weakness or emerging pattern that could grow expensive.
- **Low**: a small smell, isolated trade-off, or watch item.

Confidence values:

- **High**: direct repository evidence strongly supports both the observation and interpretation.
- **Medium**: observation is supported, interpretation is plausible but may have context-dependent exceptions.
- **Low**: weak signal; usually place in watchlist or insufficient evidence rather than top findings.

## Repository Inspection Process

When `/cockburn-review` is called, inspect the repository from the current working directory.

Start with safe read-only inspection.

Recommended first pass:

```bash
pwd
git rev-parse --show-toplevel
git status --short
git ls-files
find . -maxdepth 2 -type f | sort
find . -maxdepth 2 -type d | sort
```

If `tree` is available, a compact tree may help:

```bash
tree -a -L 3
```

If `tree` is not available, use `find`.

Prefer `git ls-files` when available so ignored dependencies and build artifacts are not scanned unnecessarily.

Skip or summarize these paths unless directly relevant:

```text
.git/
node_modules/
vendor/
dist/
build/
.next/
.nuxt/
target/
coverage/
.cache/
.venv/
venv/
__pycache__/
.pytest_cache/
.idea/
.vscode/
.DS_Store
```

Do not read secrets in full.

Sensitive files to avoid reading in full:

```text
.env
.env.*
*.pem
*.key
*.crt
id_rsa
id_ed25519
secrets.*
credentials.*
```

It is acceptable to record that an env or secret file exists, but never copy secret values into the report.

## Files to Inspect

Inspect repository files in this rough order.

### 1. Existing Documentation

Look for:

```text
README.md
docs/
docs/ARCHITECTURE.md
docs/API_SURFACE.md
docs/OPERATIONS.md
docs/REPO_MAP.md
docs/adr/
CONTRIBUTING.md
DEVELOPMENT.md
DEPLOYMENT.md
SECURITY.md
```

Extract:

- stated architecture style
- documented module boundaries
- ownership rules
- intended layering
- public interface ownership
- known caveats or TODOs
- existing architectural decisions

Treat documentation as evidence of intent, not proof that code follows that intent.

### 2. Manifests and Tooling

Look for:

```text
package.json
pnpm-lock.yaml
yarn.lock
package-lock.json
pyproject.toml
requirements.txt
Pipfile
poetry.lock
Cargo.toml
go.mod
pom.xml
build.gradle
composer.json
Gemfile
Makefile
justfile
Taskfile.yml
```

Extract:

- language and runtime
- framework dependencies
- test tools
- build tools
- scripts and entry points
- package exports
- generated-code tools
- architecture-affecting libraries such as ORMs, routers, queues, state managers, dependency injection, or validation frameworks

### 3. Source Tree

Look for common architectural areas:

```text
src/
app/
lib/
packages/
services/
domain/
application/
infra/
infrastructure/
adapters/
ports/
routes/
api/
controllers/
handlers/
models/
repositories/
db/
persistence/
jobs/
workers/
queues/
shared/
common/
utils/
```

Extract:

- apparent roles and responsibilities
- dependency direction
- ownership of domain concepts
- public exports and internal modules
- adapters and integration boundaries
- framework-specific entry points
- persistence boundaries
- shared utilities and common modules
- duplicated policy or duplicated domain language

### 4. Tests

Look for:

```text
test/
tests/
spec/
__tests__/
e2e/
features/
*.test.*
*.spec.*
pytest.ini
vitest.config.*
jest.config.*
playwright.config.*
cypress.config.*
```

Extract:

- what modules are easy or hard to test
- tests that require unrelated infrastructure
- test fixtures that reveal hidden coupling
- duplicated rule expectations
- architecture tests or dependency checks
- missing tests around high-risk boundaries

### 5. Runtime, Config, and Deployment Files

Look for:

```text
Dockerfile
docker-compose.yml
compose.yml
.dockerignore
Procfile
systemd/
deploy/
infra/
k8s/
helm/
terraform/
.github/workflows/
.gitlab-ci.yml
fly.toml
render.yaml
vercel.json
netlify.toml
.env.example
.env.template
config/
settings.*
*.config.*
```

Extract architecture-relevant information only:

- runtime boundaries
- process boundaries
- external services
- queues and schedulers
- configuration that changes dependency direction or enabled modules
- trust boundaries
- deployment-specific coupling

Keep operational details concise. This review is not an operations manual.

## Boundary Analysis Process

After the first inspection pass:

1. Build an inferred responsibility map.
2. Identify expected boundaries from docs, folder names, imports, and runtime entry points.
3. Compare expected responsibilities with observed dependencies and code behavior.
4. Look for code doing work outside its apparent role.
5. Look for code knowing details outside its apparent boundary.
6. Look for change amplification: one future change requiring edits across too many unrelated areas.
7. Look for tests that expose hidden coupling.
8. Record candidate findings with evidence.
9. Reject candidates that do not have enough evidence.
10. Prioritize the strongest findings.
11. Generate the final report from `templates/COCKBURN_REVIEW.template.md`.

## Review Heuristics

Use these heuristics as prompts, not as automatic findings.

### Not My Job Signals

- domain model formats UI, HTTP, CLI, or persistence output
- controller or route handler owns business policy
- persistence layer owns business decisions
- UI owns lifecycle or authorization rules
- integration adapter owns domain state transitions
- shared utility module owns business concepts
- one service orchestrates unrelated capabilities
- tests for one role require unrelated services or infrastructure

### No Need to Know Signals

- domain code imports framework, ORM, HTTP, queue, or UI types
- UI knows persistence schema, domain transition rules, or integration payload details
- application services know provider-specific fields that could be hidden behind an adapter
- modules import another module's internal files rather than a public boundary
- tests must construct deeply unrelated implementation details
- feature code depends on generated infrastructure types rather than stable domain concepts

### Boundary Bypass Signals

- imports from `internal`, `private`, `impl`, `db`, or deep implementation paths across module boundaries
- direct database access from modules that should use an owning component
- direct external API calls scattered outside adapters
- duplicated client construction or credentials handling
- cross-package imports that ignore package exports

### Change Amplification Signals

- adding a domain state requires changes in many unrelated files
- provider-specific logic appears in multiple layers
- the same policy appears in UI, API, service, and database code
- a schema representation leaks into tests and domain code
- a concept has several inconsistent names across modules

### Utility Sinkhole Signals

- `utils`, `common`, `shared`, or `helpers` contains business rules
- shared constants encode policy or lifecycle states
- many unrelated modules depend on a shared helper
- helper modules import high-level domain or infrastructure dependencies

## Optional Command Execution

The skill may run safe read-only commands to inspect the repository.

Safe commands usually include:

```bash
git status --short
git ls-files
git rev-parse --show-toplevel
git rev-parse HEAD
git remote get-url origin
rg "TODO|FIXME|HACK|XXX"
rg "from .*internal|import .*internal|private|impl|repository|service|controller|adapter|mapper|schema"
```

Commands that install dependencies, start services, run tests, build images, or modify files may be expensive or have side effects.

Do not run heavier commands automatically unless the user explicitly asks or the command is clearly safe and necessary.

Examples of heavier commands:

```bash
npm install
pnpm install
poetry install
docker compose up
npm run dev
npm test
pytest
make test
docker build
```

If verification would require a heavy command, document the command as a possible follow-up and mark the verification status as unknown or missing.

## Report Writing Rules

The final report must be:

- specific to the repository
- evidence-based
- concise but useful
- clear about uncertainty
- readable by humans and coding agents
- free of unresolved template placeholders
- free of copied secret values
- focused on architecture, not style nitpicks
- pragmatic about trade-offs

Prefer 3 to 7 strong findings over a long list of weak smells.

Do not report a smell merely because a file is large, a function is long, or a pattern differs from a preferred architecture style. Explain the architectural risk in terms of responsibility, knowledge, boundaries, or future change pressure.

## Candidate Findings Without Enough Evidence

If a candidate weakness is plausible but not sufficiently supported, do not present it as a finding.

Options:

1. Omit it entirely.
2. Place it in a short "Insufficient Evidence" section with searched evidence and what would be needed to confirm it.

Use this section sparingly. It should not become a dumping ground for speculation.

## Recommendations

Recommendations must connect directly to findings and evidence.

Good recommendation style:

```md
Move Stripe-specific payment state translation behind the payment adapter boundary. This follows from Finding 2, where `src/domain/payments/Payment.ts` imports provider-specific status constants and `src/services/billing/BillingService.ts` branches on Stripe event names.
```

Bad recommendation style:

```md
Adopt hexagonal architecture.
```

unless the repository already provides evidence that this is the intended architecture and the recommendation is scoped to a specific observed boundary problem.

Each recommendation should state one of:

- fix now
- watch
- accept as trade-off

## Completion Report

After writing `docs/COCKBURN_REVIEW.md`, report:

- the file created or updated
- the number of findings
- the highest severity finding
- any areas skipped because evidence was missing
- any heavy verification commands not run
- whether the report contains unresolved unknowns

Do not paste the full report into the chat unless the user asks.
