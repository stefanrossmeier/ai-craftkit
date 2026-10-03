# mermaiddoc

`mermaiddoc` is a small helper for creating a specific Mermaid diagram when prose or tables are not enough.

## Command

```text
/mermaiddoc
```

It prefers standard GitHub-renderable Mermaid, especially:

```text
flowchart LR
sequenceDiagram
```

Unlike the earlier version, the skill does not own a default `docs/diagrams/` directory. Prefer inserting a diagram into the document that needs it—for example an `archdoc` file. Create a standalone diagram file only when the user asks for one.

## Use it for

- one component/dependency view
- one request or data flow
- one interaction sequence
- one retry/failure sequence
- one small process or decision flow

Keep labels short, use simple stable IDs, avoid decorative styling, and inspect only the repository area needed for the requested diagram.

See [`SKILL.md`](SKILL.md) for the rules and [`examples/mermaiddoc-examples.md`](examples/mermaiddoc-examples.md) for compact patterns.
