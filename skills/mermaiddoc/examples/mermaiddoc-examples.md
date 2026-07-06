# Mermaiddoc Examples

This file shows example diagrams that follow the `mermaiddoc` skill recommendations.

The examples use only GitHub-renderable Mermaid code blocks and focus on the two preferred diagram types:

- `flowchart LR` for structure and process
- `sequenceDiagram` for interactions over time

The diagrams are intentionally small enough to read in GitHub, but large enough to show typical developer documentation use cases.

## Example 1: Main Components of a Larger Application

Purpose: Show the main components of a larger application without turning the diagram into a full system map.

Source basis:
- Example application architecture
- Typical web application with API, workers, storage, and integrations

Diagram type: flowchart LR

```mermaid
flowchart LR
    User[User] --> WebApp[Web App]
    WebApp --> API[API Gateway]

    subgraph Backend[Backend]
        API --> Auth[Auth Service]
        API --> AppService[Application Service]
        AppService --> Policy[Policy Engine]
        AppService --> Repository[Repository]
    end

    Repository --> Database[(Database)]
    AppService -. async job .-> Queue[Queue]
    Queue -. processing .-> Worker[Worker]
    Worker --> Provider[External Provider]
```

Notes:
- The main synchronous path is shown with solid arrows.
- The asynchronous worker path is shown with dotted arrows.
- Internal implementation details are intentionally omitted.

## Example 2: Startup Until Data Processing

Purpose: Show how a service starts, validates configuration, connects dependencies, and begins processing data.

Source basis:
- Example backend startup flow
- Typical service runtime lifecycle

Diagram type: sequenceDiagram

```mermaid
sequenceDiagram
    participant Runtime
    participant Config
    participant API
    participant Queue
    participant Worker
    participant DB as Database

    Runtime->>Config: Load environment
    Config-->>Runtime: Runtime settings
    Runtime->>DB: Open connection
    DB-->>Runtime: Connection ready
    Runtime->>API: Start HTTP server
    Runtime->>Queue: Subscribe to jobs
    Queue-->>Worker: Deliver job
    Worker->>DB: Load input data
    DB-->>Worker: Input data
    Worker->>Worker: Transform data
    Worker->>DB: Save result
    DB-->>Worker: Result saved
```

Notes:
- Startup and processing are shown in one sequence because the focus is the runtime handoff.
- Deployment, migrations, and monitoring are intentionally omitted.

## Example 3: Request Lifecycle Through a Backend

Purpose: Show how an HTTP request moves through common backend layers.

Source basis:
- Typical layered backend architecture

Diagram type: flowchart LR

```mermaid
flowchart LR
    Client[Client] -->|HTTP request| Router[Router]
    Router --> Middleware[Middleware]
    Middleware --> Handler[Handler]
    Handler --> Service[Service]
    Service --> Validator[Validator]
    Service --> Repository[Repository]
    Repository --> DB[(Database)]
    Service -->|domain event| EventBus[Event Bus]
    Handler -->|HTTP response| Client
```

Notes:
- Edge labels are used only where they add meaning.
- The diagram shows one focused request path and one event side effect.
- Error handling is better documented as a separate sequence diagram.

## Example 4: Authentication Success and Failure Path

Purpose: Show an authentication check with the most important success and failure branches.

Source basis:
- Typical API authentication behavior

Diagram type: sequenceDiagram

```mermaid
sequenceDiagram
    actor User
    participant Client
    participant API
    participant Auth
    participant Service
    participant DB as Database

    User->>Client: Open protected page
    Client->>API: Request protected resource
    API->>Auth: Validate token
    alt Token valid
        Auth-->>API: User context
        API->>Service: Load resource
        Service->>DB: Query resource
        DB-->>Service: Resource data
        Service-->>API: Resource
        API-->>Client: 200 OK
    else Token invalid
        Auth-->>API: Reject request
        API-->>Client: 401 Unauthorized
    end
```

Notes:
- The diagram uses one `alt` block for the important branch.
- Token refresh and permission checks are intentionally omitted.

## Example 5: Background Job Processing

Purpose: Show how an API request creates work that is processed asynchronously by a worker.

Source basis:
- Typical queue-based background job architecture

Diagram type: sequenceDiagram

```mermaid
sequenceDiagram
    participant API
    participant DB as Database
    participant Queue
    participant Worker
    participant Provider as External Provider

    API->>DB: Create job record
    DB-->>API: Job ID
    API->>Queue: Enqueue job
    Queue-->>API: Job accepted
    Worker->>Queue: Fetch job
    Worker->>DB: Load job state
    Worker->>Provider: Send request
    Provider-->>Worker: Provider result
    Worker->>DB: Store result
    Worker-->>Queue: Acknowledge job
```

Notes:
- Database state and queue state are shown separately.
- Retry and dead-letter handling would be separate diagrams if needed.

## Example 6: Build and Release Flow

Purpose: Show the main path from source change to deployed service.

Source basis:
- Typical CI/CD pipeline

Diagram type: flowchart LR

```mermaid
flowchart LR
    Dev[Developer] --> PR[Pull Request]
    PR --> CI[CI Pipeline]
    CI --> Tests[Tests]
    CI --> Build[Build Artifact]
    Tests --> Gate{Checks pass?}
    Build --> Gate
    Gate -->|yes| Registry[Artifact Registry]
    Gate -->|no| Fix[Fix Changes]
    Registry --> Deploy[Deploy]
    Deploy --> Runtime[Runtime Environment]
```

Notes:
- The decision diamond is used only for the real pipeline branch.
- Rollback and manual approval are omitted to keep this diagram focused.

## Example 7: Data Import Pipeline

Purpose: Show how external data moves through validation, transformation, storage, and reporting.

Source basis:
- Typical data import workflow

Diagram type: flowchart LR

```mermaid
flowchart LR
    Source[External Source] --> Importer[Importer]
    Importer --> Validate[Validate]
    Validate --> Clean[Clean Data]
    Clean --> Transform[Transform]
    Transform --> Store[(Data Store)]
    Store --> Index[Index]
    Store --> Report[Report]
    Validate -->|invalid rows| Rejects[Reject Log]
```

Notes:
- The main path moves left to right.
- Invalid rows are shown as a labeled branch.
- Scheduling and authentication are intentionally omitted.

## Example 8: Agent Skill Documentation Workflow

Purpose: Show how an agent turns a user request into a Markdown diagram file.

Source basis:
- Example `mermaiddoc` workflow

Diagram type: sequenceDiagram

```mermaid
sequenceDiagram
    actor User
    participant Agent
    participant Skill as Mermaiddoc Skill
    participant Repo as Repository
    participant Docs as docs/diagrams

    User->>Agent: Request diagram
    Agent->>Skill: Select diagram focus
    Skill->>Repo: Inspect relevant files
    Repo-->>Skill: Evidence
    Skill->>Skill: Choose diagram type
    Skill->>Docs: Write Markdown file
    Docs-->>Skill: File saved
    Skill-->>Agent: Completion report
    Agent-->>User: Summarize result
```

Notes:
- Repository inspection is shown as a verified evidence step.
- The generated output is a Markdown file, not an image.

## Example 9: Module Boundary in a Larger Codebase

Purpose: Show the boundaries between interface, domain, and infrastructure layers.

Source basis:
- Typical modular application structure

Diagram type: flowchart LR

```mermaid
flowchart LR
    subgraph Interface[Interface Layer]
        Web[Web Controller]
        CLI[CLI Command]
    end

    subgraph Domain[Domain Layer]
        UseCase[Use Case]
        Policy[Policy]
        Model[Domain Model]
    end

    subgraph Infrastructure[Infrastructure Layer]
        Repo[Repository]
        Mailer[Mailer Adapter]
        DB[(Database)]
    end

    Web --> UseCase
    CLI --> UseCase
    UseCase --> Policy
    UseCase --> Model
    UseCase --> Repo
    UseCase --> Mailer
    Repo --> DB
```

Notes:
- Subgraphs are used only to clarify ownership and boundaries.
- Dependency direction is shown from interface toward domain and infrastructure.
- Individual helper classes are intentionally omitted.

## Example 10: Retry With Fallback

Purpose: Show a retry path without overloading the main architecture diagram.

Source basis:
- Typical external provider call with retry and fallback behavior

Diagram type: sequenceDiagram

```mermaid
sequenceDiagram
    participant Service
    participant Provider as Primary Provider
    participant Fallback as Fallback Provider
    participant DB as Database

    Service->>Provider: Send request
    Provider-->>Service: Temporary failure
    loop Retry up to 3 times
        Service->>Provider: Retry request
        Provider-->>Service: Failure
    end
    Service->>Fallback: Send fallback request
    Fallback-->>Service: Result
    Service->>DB: Store result and provider used
    DB-->>Service: Saved
```

Notes:
- The retry loop is shown because retry behavior is the focus.
- Timeout values and alerting are intentionally omitted.
