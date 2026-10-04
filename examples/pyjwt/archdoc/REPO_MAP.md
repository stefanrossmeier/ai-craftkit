# Repository Map

Review Scope: full repository snapshot
Doc Status: MAINTAINED
Last Updated: 2026-10-04T09:21:37Z
Updated By: agent
Source Repository: [jpadilla/pyjwt](https://github.com/jpadilla/pyjwt/tree/7144e4534c34810f4525dc4578a32addd8212cff)
Source Revision: [7144e4534c34810f4525dc4578a32addd8212cff](https://github.com/jpadilla/pyjwt/commit/7144e4534c34810f4525dc4578a32addd8212cff)
Source Basis: `README.rst`, `pyproject.toml`, `tox.ini`, GitHub workflows, `jwt/`, `tests/`, `docs/`

Related docs: [ARCHITECTURE.md](ARCHITECTURE.md), [API_SURFACE.md](API_SURFACE.md), and [OPERATIONS.md](OPERATIONS.md).

## Repository Summary

- **Purpose**: Python implementation of JSON Web Tokens (JWTs).
- **Repository type**: published Python library; import package is `jwt`.
- **Runtime**: Python 3.9+; `cryptography` is optional, and enables asymmetric algorithms.
- **Entry points**: public exports in [`jwt/__init__.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/__init__.py); no application server or CLI is evidenced.
- **Build/package system**: setuptools via [`pyproject.toml`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/pyproject.toml).
- **Main verification**: `tox` is the documented project-root command; target definitions are in [`tox.ini`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/tox.ini).

## Root Structure

```text
pyjwt/
├── jwt/                 # Library implementation and public package façade
├── tests/               # pytest contract and regression tests
├── docs/                # Sphinx documentation and generated architecture docs
├── .github/workflows/   # CI, release, and repository automation
├── pyproject.toml       # Package metadata, dependencies, and tool configuration
└── tox.ini              # Test, lint, type-check, docs, and package-check targets
```

## Important Areas

| Path | Responsibility | Important files / symbols | Status |
|---|---|---|---|
| [`jwt/`](https://github.com/jpadilla/pyjwt/tree/7144e4534c34810f4525dc4578a32addd8212cff/jwt) | Token encoding/decoding, JWS operations, JWK handling, algorithms, errors | `api_jwt.PyJWT`, `api_jws.PyJWS`, `jwks_client.PyJWKClient` | verified |
| [`tests/`](https://github.com/jpadilla/pyjwt/tree/7144e4534c34810f4525dc4578a32addd8212cff/tests) | Unit and regression contracts for public behavior | `test_api_jwt.py`, `test_api_jws.py`, `test_jwks_client.py` | verified |
| [`docs/`](https://github.com/jpadilla/pyjwt/tree/7144e4534c34810f4525dc4578a32addd8212cff/docs) | Sphinx source and API/usage reference | `usage.rst`, `api.rst`, `conf.py` | verified |
| [`.github/workflows/`](https://github.com/jpadilla/pyjwt/tree/7144e4534c34810f4525dc4578a32addd8212cff/.github/workflows) | CI and trusted publishing workflows | `main.yml`, `pypi-package.yml` | verified |

## Build, Test, and Verification Commands

| Command | Purpose | Defined by | Status |
|---|---|---|---|
| `tox` | Execute tox's configured environments for the active interpreter | [`tox.ini`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/tox.ini) and [`README.rst`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/README.rst) | verified |
| `tox -e lint` | Run `pre-commit run --all-files` | [`tox.ini`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/tox.ini) | verified |
| `tox -e docs` | Build Sphinx HTML and doctests with warnings as errors | [`tox.ini`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/tox.ini) | verified |
| `python -m build` | Produce distribution artifacts | [CI workflow](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/.github/workflows/main.yml) | verified |

## Configuration and Generated Paths

| Path / name | Type | Purpose | Status |
|---|---|---|---|
| `pyproject.toml` | package/tool config | Python floor, optional dependencies, pytest, mypy, coverage, setuptools | verified |
| `tox.ini` | verification config | interpreter matrix and commands | verified |
| `.readthedocs.yaml` | documentation-build config | Python 3.11, `.[crypto]`, and docs dependency group | verified |
| `docs/_build/` | generated documentation output | Sphinx target used by tox; excluded by Sphinx config | verified |
| `dist/` | generated package artifacts | built and checked by CI | verified |

## Observed Repository Conventions

| Area | Observed pattern | Evidence | Confidence |
|---|---|---|---|
| Public error behavior | Public failures use domain-specific exceptions from `jwt.exceptions`; tests assert both class and messages for representative cases | [`jwt/exceptions.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/exceptions.py), [`tests/test_api_jwt.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/tests/test_api_jwt.py) | verified |
| Backward-compatibility transition | Deprecated call shapes emit warnings that identify planned PyJWT 3 removal | [`jwt/api_jwt.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/api_jwt.py), [`jwt/api_jws.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/api_jws.py) | verified |

## Recommended Reading Order

1. [`README.rst`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/README.rst) and [`docs/usage.rst`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/docs/usage.rst) for consumer-facing use and security warnings.
2. [ARCHITECTURE.md](ARCHITECTURE.md) for boundaries, trust model, and state.
3. [API_SURFACE.md](API_SURFACE.md) for public library and JWKS-client contracts.
4. [`jwt/api_jwt.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/api_jwt.py) and [`jwt/api_jws.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/api_jws.py) before changing token processing.
5. [OPERATIONS.md](OPERATIONS.md) before changing release, documentation, or verification behavior.

## Open Questions and Gaps

- No `docs/adr/` directory or other explicit architecture-decision records were found in this revision; historical rationale for major design choices is missing.
- No repository-owned compatibility policy beyond supported Python versions and in-code deprecation warnings was found.