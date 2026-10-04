# PyJWT Archdoc Example

This folder is an example output of the `/archdoc` skill for the PyJWT Python library. It is a documentation snapshot, not part of PyJWT's runtime or package source.

The documents were created by inspecting PyJWT's README, package and verification configuration, public `jwt` exports, implementation modules, tests, and CI/release workflows. Claims are marked by evidence status where useful, and the source repository and exact commit are recorded at the top of every document.

Read the files in this order:

1. [REPO_MAP.md](REPO_MAP.md) for repository navigation and commands.
2. [ARCHITECTURE.md](ARCHITECTURE.md) for boundaries, modules, state, and invariants.
3. [API_SURFACE.md](API_SURFACE.md) for the public Python and JWKS-client contracts.
4. [OPERATIONS.md](OPERATIONS.md) for verification, release, and runtime behavior.

To create a similar set for another repository, run `/archdoc` against that repository. The skill writes `REPO_MAP.md` and `ARCHITECTURE.md` always, and adds API and operations documents when supported by repository evidence.