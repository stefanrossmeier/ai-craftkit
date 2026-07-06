# mermaiddoc

`mermaiddoc` creates small Mermaid diagrams for repository documentation.

The skill focuses on diagrams that render cleanly in GitHub Markdown and are useful for code understanding. It avoids large, decorative, or overly complex diagrams.

## Main Idea

Mermaid diagrams are often easy to generate, but not always easy to read.

`mermaiddoc` follows a few simple rules:

* one diagram should explain one focused idea
* GitHub rendering should work without special settings
* labels should be short
* arrows should be clear
* diagrams should stay small
* complex systems should be split into several diagrams
* assumptions and gaps should be documented

## Command

```text
/mermaiddoc
```

## Main Diagram Types

The skill mainly uses two Mermaid diagram types.

### Flowcharts

```text
flowchart LR
```

Use flowcharts for structure and process:

* architecture overview
* module relationships
* request flow
* data flow
* build flow
* deployment flow
* agent workflow

### Sequence Diagrams

```text
sequenceDiagram
```

Use sequence diagrams for interactions over time:

* API calls
* request and response behavior
* service interactions
* user and system flows
* agent and tool calls
* retries or error paths

## Output

Generated diagrams are stored as Markdown files in:

```text
docs/diagrams/
```

Each file contains a Mermaid code block so GitHub can render it directly.

Example output file:

```text
docs/diagrams/authentication-flow.md
```

## Recommended Use

Use `mermaiddoc` when a codebase needs a visual explanation of one specific area.

Examples:

```text
/mermaiddoc "Show the request lifecycle"
/mermaiddoc "Create a sequence diagram for startup and data processing"
/mermaiddoc "Show the main components of the application"
```

The skill chooses `flowchart LR` or `sequenceDiagram` from the request and the repository evidence. It should prefer the smallest useful diagram over a broad diagram that is hard to read.

## Recommended Workflow

1. Start with safe read-only inspection when the diagram should reflect the repository.
2. Inspect existing docs and the relevant source area.
3. Choose one focused diagram purpose.
4. Write a Markdown file under `docs/diagrams/` with a GitHub-renderable Mermaid block.
5. Note important assumptions, omissions, or gaps.

## Safety and Evidence

`mermaiddoc` should:

* start with safe read-only inspection
* avoid secrets and never copy secret values
* avoid expensive or state-changing commands unless explicitly asked or clearly necessary
* keep diagrams grounded in repository evidence when the user asks for repository-based documentation

## Design Principle

The goal is not to draw everything.

The goal is to create the smallest useful diagram that helps a future human or agent understand the repository faster.
