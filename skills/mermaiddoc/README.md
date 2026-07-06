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
/mermaiddoc flow "Show the main modules"
/mermaiddoc sequence "Show how the CLI command calls the skill"
/mermaiddoc --focus src/auth
```

## Design Principle

The goal is not to draw everything.

The goal is to create the smallest useful diagram that helps a future human or agent understand the repository faster.
