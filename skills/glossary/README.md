# Glossary

`glossary` is the domain-language discovery skill in `ai-craftkit`.

## Command

```text
/glossary
```

It inspects a repository and creates or refreshes:

```text
docs/GLOSSARY.md
```

The skill looks for the repository's candidate ubiquitous language from a Domain-Driven Design perspective.

It focuses on:

- business concepts, actors, rules, events, states, processes, measures, and artifacts
- context-specific meanings
- terminology used consistently across documentation, tests, code, schemas, and user-facing text
- competing synonyms, overloaded terms, unexplained abbreviations, legacy names, and technical leakage
- definitions and context boundaries that require domain-expert review

It deliberately excludes ordinary framework, infrastructure, persistence, and implementation vocabulary unless those words carry a specific domain meaning.

## Recommended Workflow

1. Start with safe, read-only repository inspection.
2. Read existing domain documentation and any current glossary.
3. Inspect tests, scenarios, domain-bearing source, user-facing text, and relevant schemas.
4. Build a candidate term list.
5. remove generic and technical terms.
6. Trace each retained term through behavior, rules, lifecycle, and relationships.
7. Group terms by candidate bounded context only when evidence supports it.
8. Write `docs/GLOSSARY.md`.
9. Surface ambiguity and concrete domain-expert review questions.

## Important Limitation

A repository can show language encoded in software, but it cannot prove that the language is accepted by domain experts or used consistently in real conversations.

Generated definitions should therefore remain `DRAFT` or `NEEDS REVIEW` until knowledgeable humans confirm them.

## Copilot CLI

Install the `glossary` directory in a supported skills location, for example:

```text
~/.copilot/skills/glossary/
```

Then reload and verify it:

```text
/skills reload
/skills info glossary
```

Invoke it with:

```text
/glossary
```
