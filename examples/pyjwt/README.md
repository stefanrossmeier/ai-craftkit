# PyJWT examples

This folder contains generated documentation examples for the public PyJWT repository using `ai-craftkit` skills.

The goal of this example is to show how reusable AI agent skills can produce reviewable documentation artifacts from an existing codebase with short prompts. The generated files are examples, not official PyJWT documentation.

## Source repository

This example is based on the public PyJWT repository:

```text
https://github.com/jpadilla/pyjwt
```

PyJWT is a Python library for working with JSON Web Tokens. It is a useful example target because the repository is small enough to inspect, but still contains meaningful structure around JWT decoding, JWS handling, claim validation, algorithms, exceptions, tests, documentation, and packaging.

## Included examples

| Skill        | Folder        | Purpose                                                           |
| ------------ | ------------- | ----------------------------------------------------------------- |
| `archdoc`    | `archdoc/`    | Generated architecture documentation for the PyJWT repository.    |
| `adrgen`     | `adrgen/`     | Discovered architectural decision candidates from the repository. |
| `c4doc`      | `c4doc/`      | Generated selective C4 architecture documentation for PyJWT.      |
| `mermaiddoc` | `mermaiddoc/` | Generated Mermaid-based explanations for selected PyJWT flows.    |

## Prompts used

The prompts used for these examples were intentionally short. The purpose is to show that the skill definitions carry most of the workflow guidance.

### Architecture documentation

```text
/archdoc generate the documentation docs for the pyjwt repository here in this workspace
```

Generated output:

```text
archdoc/
```

### ADR discovery

```text
/adrgen discover the repo pyjwt
```

Generated output:

```text
adrgen/ADR_CANDIDATES.md
```

### C4 documentation

```text
/c4doc Create the c4 documentation for the pyjwt repo here in this workspace.
```

Generated output:

```text
c4doc/
```

### Mermaid documentation

```text
/mermaiddoc on the pyjwt repository, create me a md file and explanation for decode. And another md file for explanation of validation.
```

Generated output:

```text
mermaiddoc/
```

## Folder structure

```text
examples/pyjwt/
├── README.md
├── LICENSE-PyJWT
├── archdoc/
│   └── README.md
├── adrgen/
│   ├── README.md
│   └── ADR_CANDIDATES.md
├── c4doc/
│   ├── README.md
│   └── c4-documentation/
└── mermaiddoc/
    └── README.md
```

The exact generated documentation files may evolve over time, but the folder structure is intended to keep each skill run separate and easy to review.

## Why this example exists

This example demonstrates a practical documentation workflow:

1. Select a real public repository.
2. Run a focused skill with a short prompt.
3. Store the generated documentation separately from the source repository.
4. Make the prompt and context visible.
5. Review the output before treating it as reliable documentation.

This is especially important for AI-generated engineering documentation. The value is not only in generating Markdown. The value is in producing artifacts that are scoped, attributable, and reviewable.

## How to review the output

The generated files should be reviewed with these questions:

* Is the output specific to PyJWT?
* Are claims grounded in repository evidence?
* Are assumptions or inferred conclusions visible?
* Does the documentation avoid pretending to be official project documentation?
* Are diagrams small enough to understand and maintain?
* Do Mermaid diagrams render correctly in GitHub?
* Would the output help a developer understand the repository faster?
* Is anything overstated or too generic?

The examples are intended to show useful first drafts, not fully verified architectural truth.

## Limitations

The generated documentation in this folder was created from repository inspection and AI-assisted analysis.

It may contain inferred conclusions, incomplete coverage, or simplifications. It should not be treated as a replacement for maintainer-authored documentation or a full manual review of the PyJWT codebase.

The examples are included to demonstrate the behavior of `ai-craftkit` skills and to make their output easier to inspect.

## License and attribution

This example is based on the public PyJWT repository:

```text
https://github.com/jpadilla/pyjwt
```

PyJWT is licensed under the MIT License. A copy of the PyJWT license is included in this folder as `LICENSE-PyJWT`.

The documentation in this folder is an external documentation example generated for `ai-craftkit`. It is not official PyJWT documentation and is not endorsed by the PyJWT maintainers.
