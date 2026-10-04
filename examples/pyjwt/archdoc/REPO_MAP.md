# PyJWT Repository Map

> Review Scope: full static repository review
> Doc Status: MAINTAINED
> Last Updated: 2026-10-04T08:21:17Z
> Updated By: agent
> Source Revision: 7144e4534c34810f4525dc4578a32addd8212cff
> Source Basis: `README.rst`, `pyproject.toml`, `tox.ini`, `.github/workflows/`, `jwt/`, `tests/`, and `docs/`

PyJWT is a Python implementation of RFC 7519 JSON Web Tokens. It is distributed as the `PyJWT` package and imports as `jwt`; the public facade is [jwt/__init__.py](../../jwt/__init__.py).

## Top-Level Guide

| Path | Purpose |
| --- | --- |
| [jwt/](../../jwt/) | Library implementation, public facade, token/JWS/JWK handling, algorithms, and JWKS retrieval. |
| [tests/](../../tests/) | Pytest suite organized by library module; `keys/` contains test fixtures. |
| [docs/](../) | Sphinx documentation and this architecture documentation. |
| [pyproject.toml](../../pyproject.toml) | Package metadata, dependency groups, Python support declaration, pytest, coverage, mypy, and setuptools configuration. |
| [tox.ini](../../tox.ini) | Test, typing, lint, documentation, package-description, and coverage-report environments. |
| [.github/workflows/](../../.github/workflows/) | CI, package publication, changelog enforcement, and stale-issue automation. |
| [README.rst](../../README.rst) | Installation, basic use, and the documented `tox` test entry point. |

## Implementation Paths

| Path | Responsibility |
| --- | --- |
| [jwt/api_jwt.py](../../jwt/api_jwt.py) | `PyJWT`: JSON payload serialization/parsing, standard claim validation, and high-level `encode`/`decode`. |
| [jwt/api_jws.py](../../jwt/api_jws.py) | `PyJWS`: compact JWS parsing, protected-header checks, signing, algorithm allow-list enforcement, and signature verification. |
| [jwt/algorithms.py](../../jwt/algorithms.py) | Built-in HMAC algorithms and optional `cryptography`-backed asymmetric algorithms. |
| [jwt/api_jwk.py](../../jwt/api_jwk.py) | JWK and JWK Set parsing and algorithm/key binding. |
| [jwt/jwks_client.py](../../jwt/jwks_client.py) | HTTP(S) JWKS fetch, signing-key selection, retries on key miss, and caching integration. |
| [jwt/jwk_set_cache.py](../../jwt/jwk_set_cache.py) | In-memory, monotonic-time JWKS set cache. |
| [jwt/exceptions.py](../../jwt/exceptions.py) | Public exception hierarchy. |
| [jwt/types.py](../../jwt/types.py) | Typed configuration and JWK aliases. |

## Verified Commands

Run from the repository root after installing the appropriate dependencies:

| Purpose | Command | Evidence |
| --- | --- | --- |
| Full configured verification | `tox` | [README.rst](../../README.rst), [tox.ini](../../tox.ini) |
| Focused test arguments | `tox -- <pytest arguments>` | `{posargs}` in [tox.ini](../../tox.ini) |
| Documentation build and doctests | `tox -e docs` | [tox.ini](../../tox.ini) |
| Lint | `tox -e lint` | [tox.ini](../../tox.ini) |
| Type checks | `tox -e py311-crypto-mypy` | [tox.ini](../../tox.ini); other supported environments are declared there |
| Package build/check | `python -m build && python -m twine check dist/*` | [.github/workflows/main.yml](../../.github/workflows/main.yml) |

## Observed Conventions

- **verified:** tests mirror source responsibilities (`tests/test_api_jwt.py`, `tests/test_api_jws.py`, `tests/test_api_jwk.py`, `tests/test_jwks_client.py`, and `tests/test_algorithms.py`).
- **verified:** `cryptography` is an optional `crypto` extra; test and typing environments exercise both crypto and no-crypto configurations ([pyproject.toml](../../pyproject.toml), [tox.ini](../../tox.ini)).
- **verified:** Sphinx documentation is treated as a warning-free build and includes doctests ([tox.ini](../../tox.ini), [.readthedocs.yaml](../../.readthedocs.yaml)).

## Recommended Reading Order

1. [README.rst](../../README.rst) and [docs/usage.rst](../usage.rst) for intended library use.
2. [API_SURFACE.md](API_SURFACE.md) for the supported import-level contract.
3. [ARCHITECTURE.md](ARCHITECTURE.md) for decomposition and security boundaries.
4. [OPERATIONS.md](OPERATIONS.md) for local verification and publishing behavior.
5. The matching source module and test module for a proposed change.

## Known Gaps

- **missing:** no repository-local `AGENTS.md`, `CONTRIBUTING*`, or `docs/adr/` directory was found during this review.
- **missing:** no generated API compatibility policy or explicit supported-version policy beyond package metadata, CI, and change history was found.