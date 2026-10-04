# PyJWT Repository Map

**Review Scope:** targeted static repository inspection
**Doc Status:** MAINTAINED
**Last Updated:** 2026-10-04T07:40:52Z
**Updated By:** agent
**Source Revision:** `7144e4534c34810f4525dc4578a32addd8212cff`
**Source Basis:** `README.rst`, `pyproject.toml`, `tox.ini`, `.github/workflows/`, `jwt/`, `tests/`, and `docs/`

## Purpose

**Verified:** PyJWT is a Python implementation of RFC 7519 JSON Web Tokens. It is distributed as the `PyJWT` package and targets Python 3.9 or newer. The public import namespace is `jwt`.

## Layout

| Path | Responsibility |
| --- | --- |
| [`jwt/`](../../jwt/) | Installable library package. [`__init__.py`](../../jwt/__init__.py) defines the public exports and package version. |
| [`jwt/api_jwt.py`](../../jwt/api_jwt.py) | High-level JWT encoding, decoding, and registered-claim validation. |
| [`jwt/api_jws.py`](../../jwt/api_jws.py) | JWS compact serialization, header parsing, signature verification, and algorithm registry. |
| [`jwt/algorithms.py`](../../jwt/algorithms.py) | Algorithm implementations and optional `cryptography` integration. |
| [`jwt/api_jwk.py`](../../jwt/api_jwk.py), [`jwt/jwks_client.py`](../../jwt/jwks_client.py), [`jwt/jwk_set_cache.py`](../../jwt/jwk_set_cache.py) | JWK parsing, JWKS retrieval, and caching. |
| [`jwt/exceptions.py`](../../jwt/exceptions.py), [`jwt/types.py`](../../jwt/types.py), [`jwt/utils.py`](../../jwt/utils.py), [`jwt/warnings.py`](../../jwt/warnings.py) | Shared errors, public type definitions, helpers, and warnings. |
| [`tests/`](../../tests/) | Pytest coverage grouped by API area, algorithms, JWKS client, utility functions, and security advisories. |
| [`docs/`](../) | Sphinx source for user documentation and API reference. |
| [`.github/workflows/`](../../.github/workflows/) | CI, package publication, changelog enforcement, and repository automation. |
| [`pyproject.toml`](../../pyproject.toml) | Packaging metadata, dependencies, pytest, coverage, mypy, and setuptools configuration. |
| [`tox.ini`](../../tox.ini) | Supported interpreter/extra matrix and local verification environments. |

## Entry Points And Reading Order

1. Start with [`README.rst`](../../README.rst) for installation and a minimal encode/decode example.
2. Read [`jwt/__init__.py`](../../jwt/__init__.py) for the supported top-level Python API.
3. Follow [`jwt/api_jwt.py`](../../jwt/api_jwt.py) into [`jwt/api_jws.py`](../../jwt/api_jws.py) for the JWT-to-JWS processing path.
4. Read [`jwt/algorithms.py`](../../jwt/algorithms.py) and [`jwt/api_jwk.py`](../../jwt/api_jwk.py) when changing key or algorithm behavior.
5. Read [`jwt/jwks_client.py`](../../jwt/jwks_client.py) and [`tests/test_jwks_client.py`](../../tests/test_jwks_client.py) for remote-key behavior.

## Verified Commands

Run from the repository root. These commands are defined by [`tox.ini`](../../tox.ini) or CI workflow configuration.

```console
python -m tox
python -m tox -e lint
python -m tox -e py311-mypy
python -m tox -e docs
python -m build
```

`python -m tox` selects environments based on the current interpreter through `tox-gh-actions` in CI; use an explicit environment for a narrow local check. The documentation environment runs Sphinx with warnings treated as errors and doctests for `README.rst` and `docs/usage.rst`.

## Generated And Artifact Paths

- `docs/_build/html/` is the Sphinx HTML output directory configured by [`tox.ini`](../../tox.ini).
- `dist/` is the package artifact directory used by package-build CI workflows.
- `.coverage*` is produced by coverage-enabled test environments before the `coverage-report` environment combines results.

## Observed Conventions And Gaps

- **Verified:** Public typing is shipped via the [`jwt/py.typed`](../../jwt/py.typed) marker; mypy is configured in strict mode for library and test code.
- **Verified:** `cryptography` is an optional package extra; algorithms that need it report a missing-dependency error when unavailable.
- **Missing:** No repository `AGENTS.md`, contributor guide, architecture document, or ADR directory was present at review time.

For module responsibilities, see [ARCHITECTURE.md](ARCHITECTURE.md). For externally consumed Python contracts, see [API_SURFACE.md](API_SURFACE.md). For package and CI procedures, see [OPERATIONS.md](OPERATIONS.md).