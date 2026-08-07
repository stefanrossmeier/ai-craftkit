# Overengineering Review Skill

Command: `/overengineering-review`

Generate an evidence-based review of accidental and unjustified implementation complexity in the currently opened repository.

The skill inspects the complete repository, reconstructs the problem the software actually has to solve, identifies implementation complexity that appears disproportionate to that problem, challenges each candidate against legitimate constraints, and writes a pragmatic report to the repository's `docs/` folder.

## Invocation Model

Use this skill when the user calls:

```text
/overengineering-review
```

This is a skill invocation, not a shell command. It has no command-line parameters, flags, modes, or options.

If the user adds text around or after the invocation, treat that text as plain-language review guidance. Do not parse it as command syntax.

Examples of guidance:

- focus on one subsystem or product area
- pay special attention to abstractions, configuration, infrastructure, or extensibility
- review whether the architecture is justified by the current scale
- distinguish deliberate security boundaries from unnecessary indirection
- challenge complexity introduced for hypothetical future requirements

Do not document or advertise flag-based usage for this skill.

## Purpose

`/overengineering-review` identifies places where the cost of a solution appears greater than the problem, requirement, risk, or demonstrated scale justifies.

The primary question is:

> What complexity exists because the problem requires it, and what complexity exists because the chosen solution introduced it?

Use Fred Brooks' distinction as the conceptual baseline:

- **Essential complexity**: complexity inherent in the problem, domain, constraints, or required qualities.
- **Accidental complexity**: complexity introduced by implementation choices, architecture, tools, abstractions, processes, or infrastructure.

Accidental complexity is not automatically overengineering. A finding requires evidence that the additional complexity is not sufficiently justified by current or clearly evidenced requirements, constraints, risks, or near-term needs.

The goal is not "use fewer classes", "avoid architecture", or "make everything simple". The goal is to find **disproportionate complexity**.

## Required Output File

Generate or update exactly this primary report:

```text
docs/OVERENGINEERING_REVIEW.md
```

Create `docs/` if it does not exist.

Do not place the generated report outside `docs/`.

Do not modify application source code.

Do not modify unrelated documentation unless the user explicitly asks.

## Template Location

Use the bundled template as the conceptual source:

```text
templates/OVERENGINEERING_REVIEW.template.md
```

The final generated report must not look like an unfilled template.

Before writing the final report:

1. Fill sections with repository-specific information.
2. Delete placeholder-only sections.
3. Delete irrelevant sections.
4. Delete empty tables.
5. Delete unused example rows.
6. Delete unresolved bracket placeholders.
7. Keep useful unknowns only when the missing information matters.
8. Prefer a few strong findings over a catalog of weak smells.

## Lightweight Provenance Block

Every generated report must include a small provenance block near the top, directly after the title.

Include only information directly available. Do not guess missing metadata.

Use:

```text
> Generated with `ai-craftkit` skill: `overengineering-review`
> Source: `<repository-url>` at commit `<commit-hash>`
> Prompt: `<exact-user-prompt>`
```

If repository URL or commit hash cannot be determined, write `unknown`.

## Core Review Principle: Complexity Needs a Justification

Do not classify a construct as overengineering merely because it is sophisticated.

For every candidate, ask:

1. **What problem does this complexity solve?**
2. **Where is that problem evidenced?**
3. **Is the problem current, contractually required, risk-driven, or only hypothetical?**
4. **What concrete cost does the complexity add?**
5. **Could a materially simpler solution satisfy the same evidenced requirements?**
6. **What would be lost by simplifying it?**
7. **Would simplification remove important safety, security, reliability, compliance, compatibility, or operability guarantees?**

A candidate becomes a finding only when the evidence supports both sides:

```text
added complexity + insufficient justification
```

Do not report only the first half.

## Evidence Policy

This skill has a strict no-evidence rule.

A finding must not be included unless it is supported by concrete repository evidence.

Acceptable evidence includes:

- source files
- file paths and line ranges
- symbols, functions, classes, interfaces, modules, or exports
- imports and dependency direction
- call chains
- runtime registration and process boundaries
- tests and fixtures
- manifests and dependency declarations
- configuration files and configuration options
- Docker, CI/CD, deployment, orchestration, and infrastructure definitions
- schemas and migrations
- generated-code systems
- extension/plugin mechanisms
- compatibility layers
- feature flags
- retry, queue, caching, concurrency, and resilience mechanisms
- documentation, ADRs, issue references, comments, TODOs, and stated requirements
- safe read-only command output
- observed repository structure

Evidence of **justification** matters as much as evidence of complexity.

Search actively for justification in:

- README and product documentation
- architecture docs
- ADRs
- security documentation
- operations documentation
- comments explaining non-obvious constraints
- tests expressing required behavior
- compatibility commitments
- supported deployment modes
- documented scale or performance targets
- external integration requirements
- threat models
- regulatory or safety requirements

If a complex mechanism has strong justification, do not call it overengineering.

## Claim Status Labels

Use these labels when useful:

- **verified**: directly confirmed by code, config, tests, command output, or explicit documentation
- **inferred**: likely based on structure or partial evidence
- **uncertain**: plausible but not sufficiently supported
- **missing**: relevant information was searched for but not found

The observation behind a finding must be verified or strongly supported.

If justification is missing, state **"no justification found in inspected repository evidence"**, not **"there is no justification."**

## Required Finding Structure

Each finding should include:

- short title
- overengineering class
- related smell or anti-pattern, if useful
- severity
- confidence
- affected area
- problem being solved
- evidence of added complexity
- evidence of requirement or justification
- why the complexity appears disproportionate
- simpler credible alternative
- trade-offs of simplifying
- recommendation
- simplification horizon

### Severity

Use severity as **cost/risk of unnecessary complexity**, not as code-style importance.

- **High**: significant system-wide cognitive, operational, delivery, dependency, or change cost with weak justification; simplification could materially reduce ongoing risk or effort.
- **Medium**: meaningful localized complexity or a pattern that repeatedly slows change, testing, operation, or understanding.
- **Low**: small or isolated unnecessary indirection, flexibility, machinery, or configuration with limited current cost.

### Confidence

- **High**: repository evidence strongly establishes both the complexity and weak justification.
- **Medium**: complexity is clear, but requirements or future needs may exist outside the repository.
- **Low**: weak signal; usually keep it out of the main findings.

### Simplification Horizon

Each recommendation must say one of:

- **simplify now**: evidence is strong and removal is low-risk or clearly beneficial
- **simplify when touched**: real smell, but immediate refactoring would not justify its own disruption
- **watch**: suspicious complexity, but evidence is insufficient for removal
- **accept as trade-off**: complexity is justified despite its cost

## Overengineering Classes

Use these classes to organize findings. They are review lenses, not automatic violations.

### 1. Speculative Generality

Complexity built for hypothetical future requirements rather than demonstrated needs.

Signals:

- interface or abstract base with one implementation
- plugin/extension point with no real plugin or extension
- parameters or configuration that never vary
- generic framework around one concrete use case
- unused hooks or lifecycle callbacks
- multiple strategies/providers where only one is supported
- compatibility machinery for versions never released or supported
- generalized data models built for imagined variants
- tests are the only consumers of an abstraction

Related smell: **Speculative Generality**.

Challenge before reporting:

- Is a second implementation explicitly planned?
- Is the abstraction a test seam, security boundary, or public API contract?
- Is variability required by supported deployments?
- Would removing it create expensive compatibility breakage?

### 2. Abstraction Inflation

Too many layers, wrappers, indirections, mappings, factories, adapters, mediators, or pass-through components for the amount of behavior they encapsulate.

Signals:

- classes/modules whose main behavior is forwarding calls
- one-to-one wrapper chains
- interface → implementation → adapter → facade with little transformation
- DTO-to-model-to-entity mappings where representations are effectively identical
- factories that always construct one concrete type
- dependency injection used where dependencies are static and local
- "clean" layers that add ceremony without enforcing a meaningful boundary

Related smells:

- Middle Man
- Lazy Element
- needless indirection

Do not flag a layer that provides a meaningful trust boundary, compatibility boundary, transaction boundary, observability boundary, test seam, or independently evolving contract.

### 3. Architectural Overreach

System-level architecture whose coordination and operational costs exceed current demonstrated needs.

Signals:

- microservices without independent deployment, ownership, scaling, or isolation needs
- queues/events for flows that are naturally synchronous and local
- distributed workflows for a single-process problem
- multiple deployable services maintained by one small cohesive codebase without evidenced need
- service discovery, orchestration, or distributed consistency machinery for trivial scale
- CQRS/event sourcing where ordinary state mutation would meet the requirements
- elaborate hexagonal/clean layering without meaningful replaceable boundaries

Do not equate monolith with simple or microservices with overengineered. Judge the actual requirements.

### 4. Infrastructure Disproportion

Operational machinery that appears excessive relative to actual runtime, availability, scale, recovery, or deployment needs.

Signals:

- Kubernetes/Helm/service mesh for a trivially deployed workload without supporting requirements
- multiple caches with no measured performance need
- elaborate retry/backoff/circuit-breaker stacks around low-risk local calls
- high-availability topology without documented availability objective
- complex CI matrices for unsupported environments
- elaborate observability pipelines with no operational consumer
- bespoke deployment abstraction over a single target

Protect deliberate defense-in-depth and operational safeguards when risks justify them.

### 5. Premature Optimization

Complexity introduced to improve speed, memory, throughput, latency, or scale without evidence that the optimized path matters.

Signals:

- caching without demonstrated expensive work or invalidation need
- custom pooling or memory management without measurement
- concurrency for tiny workloads
- custom indexing or batching without scale evidence
- algorithmic complexity that improves theoretical limits but worsens ordinary readability for tiny inputs
- denormalization without measured bottleneck
- precomputation with substantial invalidation complexity

Look for benchmarks, profiling, SLOs, production data, or explicit scale requirements before concluding the optimization is premature.

### 6. Configuration Explosion

Making ordinary program behavior excessively configurable, generic, or data-driven.

Signals:

- many config options with one observed value
- configuration combinations that multiply test states
- nested feature flags with no rollout/removal lifecycle
- declarative mini-languages for simple fixed behavior
- behavior encoded in YAML/JSON that would be clearer as ordinary code
- generic rules engines for a small stable rule set
- indirection through environment variables for values that are not deployment-specific

Related anti-pattern: **Inner-Platform Effect** when the system starts recreating a programming platform or language inside itself.

### 7. Reinvented Platform or Framework

Custom infrastructure duplicates capabilities already adequately supplied by the language, runtime, database, framework, or a well-established dependency.

Signals:

- home-grown dependency injection container
- custom ORM-like layer over an ORM that recreates queries and mapping
- bespoke scheduler, router, serializer, validator, migration engine, template engine, or plugin system without special requirements
- generic framework developed primarily to host one application
- application-level constructs imitating OS/database/runtime features

Related anti-patterns:

- Inner-Platform Effect
- Not Invented Here, when evidenced
- Golden Hammer, when a favored internal mechanism is forced onto unrelated problems

Do not recommend adding a large dependency merely to replace small transparent local code.

### 8. Pattern and Technology Enthusiasm

A design pattern, paradigm, framework, or technology appears to have been selected because it is fashionable, familiar, or architecturally "pure", rather than because repository requirements benefit from it.

Signals:

- pattern terminology is prominent but concrete benefit is unclear
- multiple enterprise patterns around trivial CRUD
- a framework used for only a tiny fraction of its capability while imposing broad structure
- heterogeneous problems forced through one favored pattern
- substantial adapters necessary mainly to satisfy a chosen technology

Related anti-pattern: **Golden Hammer**.

Avoid mind-reading. Do not claim motivation such as résumé-driven development unless explicit evidence exists. Report only the observed mismatch.

### 9. Defensive Complexity Without a Threat or Failure Model

Validation, retries, fallbacks, state machines, permissions, synchronization, or error machinery that handles situations the system cannot actually encounter or whose risk does not justify the burden.

Signals:

- repeated validation of invariants already guaranteed at a trusted boundary
- recovery paths for impossible states
- multiple fallback providers when only one exists
- elaborate concurrency control in single-threaded or serialized execution
- defensive copying or deep cloning without mutation risk
- transaction choreography for operations that are already atomic

Be conservative here. Security, safety, money movement, external input, distributed systems, and destructive operations legitimately require defensive complexity.

### 10. Legacy or Lava-Flow Complexity

Obsolete, abandoned, experimental, compatibility, or transitional structures remain and continue to impose cognitive or maintenance cost.

Signals:

- old and new implementations coexist after migration
- unreachable or unused modules
- stale feature flags
- abandoned experimental frameworks
- compatibility paths for unsupported versions
- duplicated migration-era adapters
- "temporary" code that became permanent
- tests preserving behavior no longer exposed

Related anti-pattern: **Lava Flow**.

Do not recommend deletion merely because code appears unused from a simple textual search; consider reflection, plugins, dynamic loading, public APIs, scripts, and external consumers.

### 11. Test Architecture Overengineering

The test system itself adds more machinery than required to establish confidence.

Signals:

- elaborate fixture/object-builder/factory hierarchies for simple data
- mocks of internal implementation details across many layers
- bespoke test DSLs that obscure behavior
- integration harnesses for logic that could be tested directly
- dependency injection or interfaces created primarily to satisfy mocking tools
- snapshot/golden-file machinery for tiny deterministic values
- parallel test infrastructure with little suite cost

Do not optimize tests only for line count. Readability, determinism, isolation, and safety can justify additional structure.

### 12. Dependency and Tooling Excess

Libraries, build tools, generators, preprocessors, services, or languages add maintenance surface without sufficient benefit.

Signals:

- dependency used for trivial functionality
- multiple libraries solving the same category of problem
- code generation for tiny stable structures
- separate language/runtime for a small non-specialized task
- build pipeline stages with no meaningful transformation
- tooling that requires large configuration to enforce a minor preference

Consider security, ecosystem maturity, consistency, and maintenance burden before recommending replacement with custom code.

## Anti-Patterns: How to Use Them

Anti-pattern names are supporting vocabulary, not verdicts.

A repository can exhibit the shape of an anti-pattern and still have a justified design.

Use an anti-pattern label only when:

1. the structural characteristics are evidenced;
2. the negative consequences are visible or credible in this repository; and
3. the repository does not show a stronger justification for the design.

Useful labels for this review include:

- Speculative Generality
- Middle Man
- Inner-Platform Effect
- Golden Hammer
- Lava Flow
- Not Invented Here — only if explicit evidence supports unnecessary reinvention
- needless indirection
- premature optimization

Do not expand the report into an encyclopedic anti-pattern checklist.

## Repository Inspection Process

Inspect the repository from the current working directory.

Start with safe read-only inspection.

Recommended first pass:

```bash
pwd
git rev-parse --show-toplevel
git status --short
git rev-parse HEAD
git remote get-url origin
git ls-files
find . -maxdepth 2 -type d | sort
```

If `tree` is available:

```bash
tree -a -L 3
```

Prefer `git ls-files` when available so ignored dependencies and generated build artifacts are not scanned unnecessarily.

Skip or summarize unless directly relevant:

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
.DS_Store
```

Do not read secret values.

Sensitive files to avoid reading in full include:

```text
.env
.env.*
*.pem
*.key
id_rsa
id_ed25519
secrets.*
credentials.*
```

It is acceptable to record that configuration or secret material exists, but never copy values into the report.

## Complete-Repository Review Process

This is not only a source-code smell review. Inspect the complete tracked repository.

### 1. Reconstruct the Problem and Constraints

Before searching for overengineering, establish what the repository is trying to achieve.

Inspect:

```text
README.md
docs/
ADRs
BACKLOG or roadmap documents
SECURITY.md
CONTRIBUTING.md
operations/deployment docs
issues/spec references stored in the repository
examples
user-facing CLI/API docs
```

Extract:

- product purpose
- primary use cases
- supported users or integrations
- supported environments
- explicit non-functional requirements
- security/trust requirements
- compatibility commitments
- availability and recovery expectations
- performance or scale targets
- expected deployment topology
- planned near-term capabilities when explicitly documented

Write a short **problem/constraint baseline** before judging implementation complexity.

If the repository does not reveal enough product context, lower confidence accordingly.

### 2. Inventory the Complexity Budget

Map the main complexity-bearing mechanisms:

- number of deployable processes/services
- architectural layers
- packages/modules
- major abstractions and interfaces
- adapters/providers/strategies/plugins
- queues/event buses
- state machines/workflow engines
- caches
- concurrency mechanisms
- data stores
- configuration systems and feature flags
- generators and DSLs
- infrastructure/orchestration
- external dependencies
- test harnesses
- compatibility layers

Do not treat counts as findings. The inventory exists to direct investigation.

### 3. Trace Representative End-to-End Flows

Select representative user or system flows and trace them end-to-end.

Examples:

- CLI command to business action
- HTTP request to persistence
- event input to side effect
- scheduled job to output
- config change to runtime behavior

Count conceptual hops only as a diagnostic clue.

Ask at each hop:

- what responsibility is added here?
- what risk or variability is isolated?
- what transformation occurs?
- could this hop disappear without violating an evidenced requirement?

Pass-through hops are high-value candidates for deeper inspection.

### 4. Inspect Abstractions and Variability

Search for:

```bash
rg "interface|abstract|Protocol|ABC|trait|Factory|Strategy|Adapter|Provider|Plugin|Registry|Mediator|Command|Query"
rg "feature.?flag|toggle|experimental|legacy|deprecated|compat"
rg "TODO|FIXME|HACK|XXX|temporary|future|eventually|maybe|generic|extensible|flexible"
```

Adapt searches to the repository language.

For each abstraction, determine:

- number of real implementations
- number of production consumers
- actual dimensions of variability
- whether variation is current or hypothetical
- whether the abstraction protects a meaningful boundary

Single-implementation abstractions are candidates, not findings.

### 5. Inspect Configuration and State Space

Identify:

- configuration files
- environment variables
- feature flags
- runtime modes
- strategy/provider selections
- optional plugins
- build variants

Ask:

- which combinations are actually supported?
- which values appear in docs/tests/deployments?
- how many branches exist only because configuration exists?
- does configurability reduce deployment coupling, or merely move code into data?

### 6. Inspect Infrastructure and Distribution

Inspect:

```text
Dockerfile*
compose*
k8s/
helm/
terraform/
deploy/
.github/workflows/
.gitlab-ci.yml
queues
brokers
service clients
RPC
event schemas
```

Compare operational structure with evidenced requirements for:

- independent deployment
- independent scaling
- failure isolation
- ownership boundaries
- geographic distribution
- availability
- throughput
- compliance
- trust isolation

### 7. Inspect Optimization and Resilience Mechanisms

Look for:

- caches
- pooling
- batching
- retries
- circuit breakers
- concurrency
- worker pools
- custom indexes
- denormalization
- memoization
- precomputation
- sharding
- rate limiting

Search for the measurement or risk evidence that justifies them.

### 8. Inspect Tests as Architectural Evidence

Tests can reveal both justification and unnecessary machinery.

Look for:

- tests that prove multiple implementations/modes are supported
- tests that preserve compatibility commitments
- fixtures that exercise complex constraints
- interfaces used only by mocks
- deep mocking caused by excessive layering
- repeated setup caused by abstraction chains
- test-only consumers of generic facilities

### 9. Inspect History Clues Without Inventing History

If Git history is available, safe read-only history inspection may help:

```bash
git log --oneline --decorate -n 50
git log --all --grep="refactor\|migration\|legacy\|temporary\|scale\|performance" --oneline
git blame <relevant-file>
```

Use history only when useful.

Do not infer motives from commit messages.

### 10. Build Candidate Findings

For every candidate, write an internal comparison:

```text
Current problem:
Current solution:
Extra mechanisms:
Evidence those mechanisms are needed:
Ongoing costs:
Simpler credible solution:
Important guarantees lost by simplifying:
Candidate verdict:
```

Reject candidates where the simpler alternative would sacrifice evidenced requirements.

### 11. Perform the Counterargument Pass

Before accepting every Medium or High finding, argue the opposite case.

Ask:

- What legitimate requirement could explain this?
- Did I inspect security and operations docs?
- Is this a public API compatibility decision?
- Does the repository support multiple environments/providers?
- Does the abstraction isolate secrets or trust?
- Is the apparent duplication deliberate independence?
- Is the "simple" alternative actually pushing complexity onto users or operators?
- Would simplification create a migration or blast-radius risk larger than the benefit?

Record relevant counterevidence in the finding.

This pass is mandatory.

### 12. Prioritize

Prefer 3–8 strong findings over dozens of minor observations.

Rank by:

- ongoing cognitive cost
- change amplification
- operational burden
- dependency/tooling burden
- testing burden
- state-space growth
- frequency with which developers encounter the complexity
- confidence that simpler design would preserve requirements

## Heuristics

Use these as investigation prompts, not automatic findings.

### High-Signal Questions

- How many abstractions exist with only one production implementation?
- How many extension points have no extension?
- How many configuration values never vary in tracked deployments/tests/examples?
- How many layers simply rename, forward, or remap equivalent data?
- How many processes or services could be ordinary modules without losing an evidenced property?
- How much infrastructure exists to meet scale that is not documented or measured?
- Which "temporary", "legacy", or compatibility paths have no remaining consumer?
- Which dependencies are large relative to the small capability used?
- Which custom frameworks recreate facilities already present in the platform?
- Which tests are complicated mainly because production design is heavily indirect?
- Where does adding one ordinary feature require touching architecture machinery rather than business logic?
- Which complexity is justified only by "future flexibility" with no concrete future requirement?

### Weak Signals That Need Context

Do not report these alone:

- long files
- many files
- many classes
- design patterns
- dependency injection
- interfaces
- microservices
- Docker or Kubernetes
- event-driven design
- CQRS
- event sourcing
- functional programming
- metaprogramming
- code generation
- high test coverage
- strong typing
- defensive validation
- duplicated code

Any of these can be appropriate.

## The Simpler-Alternative Test

A finding is stronger when the report can describe a credible simpler alternative.

The alternative should:

- meet the same observed functional requirements
- preserve necessary security and safety properties
- preserve compatibility commitments
- preserve required deployment characteristics
- preserve documented reliability requirements
- be realistic for the repository's language and ecosystem
- reduce at least one meaningful complexity cost

Do not recommend a rewrite merely because a greenfield design could be smaller.

Prefer reversible simplifications such as:

- inline a pass-through wrapper
- collapse an unused interface
- remove one stale strategy
- make a fixed choice explicit
- delete a stale feature flag
- consolidate equivalent mappings
- use the platform facility directly
- merge processes that have no independent runtime requirement
- remove one configuration dimension
- postpone an extension mechanism until the second real use case

## Complexity Cost Model

Describe costs concretely. Relevant costs include:

- **cognitive**: more concepts, hops, indirection, naming, or hidden control flow
- **change**: more files/components must change for one requirement
- **test**: more fixtures, mocks, modes, or integration setup
- **operational**: more services, deployments, alerts, failure modes, credentials, or runbooks
- **state-space**: more configuration or feature combinations
- **dependency**: more libraries, runtimes, build tools, or upgrade obligations
- **performance**: indirection, serialization, network, startup, or coordination overhead
- **reliability**: more distributed failure modes or synchronization
- **security**: larger attack or secrets-management surface
- **delivery**: additional steps to implement and ship ordinary changes

Avoid vague statements such as "this is harder to maintain." Name the mechanism.

## What Not to Misclassify

Do not recommend simplification that removes complexity required for:

- authentication or authorization
- secrets isolation
- sandboxing
- privilege separation
- path traversal prevention
- input validation at trust boundaries
- auditability
- idempotency for externally retried operations
- money or inventory correctness
- distributed consistency requirements
- failure recovery
- data durability
- legal or regulatory requirements
- public API compatibility
- plugin contracts with real external consumers
- supported multiple deployment environments
- actual measured performance constraints
- accessibility or internationalization requirements
- explicit product requirements

Security and reliability code often looks "extra" precisely because it handles failure and adversarial cases.

## Anti-Dogma Rules

The skill must not:

- optimize for minimum line count
- assume fewer files means simpler architecture
- enforce KISS or YAGNI mechanically
- reject abstractions only because there is one implementation
- reject patterns because they are "enterprise"
- prescribe a monolith by default
- prescribe microservices by default
- treat duplication as automatically worse than abstraction
- assume a dependency is worse than custom code
- assume custom code is worse than a dependency
- treat current low traffic as proof scale will never matter
- mistake security boundaries for unnecessary layers
- call deliberate domain complexity overengineering
- invent business requirements
- invent developer motivations
- recommend removing tests or safeguards merely to reduce complexity

## Relationship to YAGNI, KISS, DRY, and Anti-Patterns

Use these principles carefully:

- **YAGNI** is strongest against speculative capabilities whose future requirement is unsupported.
- **KISS** favors the simplest design that satisfies the actual constraints, not simplistic design.
- **DRY** does not require abstracting every duplication. A small amount of duplication can be cheaper than a premature shared abstraction.
- **Anti-patterns** provide names for recurring failure shapes; they do not substitute for repository-specific evidence.

When principles conflict, prefer the design with the lower total cost for the evidenced requirements.

## Optional Command Execution

The skill may run safe read-only commands.

Examples:

```bash
git status --short
git ls-files
git rev-parse --show-toplevel
git rev-parse HEAD
git remote get-url origin
rg "TODO|FIXME|HACK|XXX|temporary|legacy|deprecated"
rg "interface|abstract|Factory|Strategy|Adapter|Provider|Plugin|Registry"
```

Do not automatically run commands that install dependencies, start services, mutate data, build images, deploy systems, or require secrets.

Tests and static analysis may be run when they are already available, clearly safe, and useful, but a repository-wide overengineering review should not require installing the project merely to produce findings.

If a potentially important claim can only be verified with a heavier command, document that verification as not performed.

## Report Writing Rules

The final report must be:

- specific to the repository
- evidence-based
- explicit about the problem the code is solving
- explicit about both complexity and justification
- pragmatic and non-dogmatic
- concise enough to review
- clear about uncertainty
- free of unresolved placeholders
- free of secret values
- oriented toward simplification, not aesthetic preference

Every main finding must answer:

> Why is this more complex than the evidenced problem requires?

Do not report a smell merely because a known anti-pattern name can be attached to it.

## Positive Findings

Include a short section for **complexity that initially looked suspicious but is justified** when this is useful.

Examples:

- an adapter boundary justified by credential isolation
- a queue justified by external retry behavior
- a state machine justified by documented lifecycle rules
- multiple implementations justified by supported providers
- Kubernetes justified by deployment policy
- duplicated code deliberately avoiding coupling between independent domains

This makes the review more trustworthy and helps prevent future "simplification" from removing important guarantees.

## Candidate Findings Without Enough Evidence

If a candidate appears suspicious but cannot be sufficiently supported, do not present it as a finding.

Either omit it or add a short **Insufficient Evidence / Watchlist** section containing:

- the suspected complexity
- what was inspected
- what justification could not be established
- what information would resolve the question

Use this section sparingly.

## Recommendations

Recommendations must connect directly to evidence.

Good:

```text
Simplify when touched: collapse `PaymentProvider` into the only production implementation while retaining the external API boundary. Repository-wide search shows one implementation and one production construction path; the other variation is test-only. Reintroduce the interface if a second provider becomes a committed requirement.
```

Bad:

```text
Follow YAGNI and remove unnecessary abstractions.
```

For each recommendation, state what must remain true after simplification.

## Completion Report

After writing `docs/OVERENGINEERING_REVIEW.md`, report:

- the file created or updated
- number of findings
- number of "justified complexity" items, if any
- highest severity finding
- areas skipped because evidence was missing
- any heavy verification commands not run
- whether unresolved questions remain

Do not paste the full generated repository report into chat unless the user asks.
