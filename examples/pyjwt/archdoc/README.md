# PyJWT Architecture Documentation Example

This folder shows the output of applying the `archdoc` skill to the PyJWT repository. It demonstrates a concise, evidence-based architecture documentation set for a Python library rather than a deployed service.

Read the documents in this order:

1. [REPO_MAP.md](REPO_MAP.md) orients readers to the repository layout, key modules, and verification commands.
2. [ARCHITECTURE.md](ARCHITECTURE.md) explains component responsibilities, dependencies, state ownership, and key processing paths.
3. [API_SURFACE.md](API_SURFACE.md) describes the public `jwt` Python-library contract, validation behavior, and compatibility signals.
4. [OPERATIONS.md](OPERATIONS.md) records installation, local verification, CI, documentation builds, and package-release behavior.

Each document includes a provenance block and marks material statements as **verified** or **missing** where repository evidence is incomplete. The documents are a snapshot of the reviewed PyJWT revision, not a substitute for its source code, public API reference, or live operational state.
