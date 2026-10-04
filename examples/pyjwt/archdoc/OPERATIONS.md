# PyJWT Operations

> Review Scope: packaging, CI, documentation, and local verification configuration
> Doc Status: MAINTAINED
> Last Updated: 2026-10-04T08:21:17Z
> Updated By: agent
> Source Revision: 7144e4534c34810f4525dc4578a32addd8212cff
> Source Basis: `pyproject.toml`, `tox.ini`, `.readthedocs.yaml`, `.github/workflows/`, `docs/conf.py`, and `README.rst`

PyJWT is a distributable library, not a deployed service. Its meaningful operational behavior is installation, verification, documentation publishing, package publication, and the outbound HTTP(S) requests made only when an application uses `PyJWKClient`.

## Local Verification

| Activity | Verified command/configuration |
| --- | --- |
| Normal test entry point | `tox` ([README.rst](../../README.rst)) |
| Test environment | Pytest under Coverage; the tox matrix includes crypto and no-crypto environments ([tox.ini](../../tox.ini)) |
| Lint | `tox -e lint`, running `pre-commit run --all-files` ([tox.ini](../../tox.ini)) |
| Static typing | `tox -e py311-crypto-mypy`, with strict mypy configuration in [pyproject.toml](../../pyproject.toml) |
| Documentation | `tox -e docs`, running warning-as-error HTML and doctest Sphinx builds plus doctests for the README and usage guide ([tox.ini](../../tox.ini)) |
| Distribution | CI runs `python -m build` and `python -m twine check dist/*` ([.github/workflows/main.yml](../../.github/workflows/main.yml)) |

The declared baseline is Python 3.9. The tox and CI configurations test supported CPython versions, selected PyPy versions, crypto/no-crypto variants, and supported typing environments ([tox.ini](../../tox.ini), [.github/workflows/main.yml](../../.github/workflows/main.yml)).

## Installation And Dependencies

`pip install PyJWT` installs the base package. `PyJWT[crypto]` adds `cryptography>=3.4.0` for asymmetric algorithms; the only base runtime compatibility dependency is `typing_extensions` for Python versions below 3.11 ([pyproject.toml](../../pyproject.toml)).

Dependency groups `tests`, `docs`, and `dev` are declared in [pyproject.toml](../../pyproject.toml). The Read the Docs configuration installs `.[crypto]` with the `docs` group under Python 3.11 and treats warnings as build failures ([.readthedocs.yaml](../../.readthedocs.yaml)).

## Build And Release

- **verified:** CI runs on pushes and pull requests targeting `master`, executes tox across an operating-system and interpreter matrix, combines/uploads coverage from Ubuntu Python 3.9, builds distributions, checks their long description, and verifies normal, crypto-extra, and editable development installs ([.github/workflows/main.yml](../../.github/workflows/main.yml)).
- **verified:** the package workflow builds and inspects artifacts. Pushes to `master` in the upstream owner repository may publish to TestPyPI; published GitHub Releases may publish to PyPI using GitHub trusted publishing (`id-token: write`) ([.github/workflows/pypi-package.yml](../../.github/workflows/pypi-package.yml)).
- **verified:** the package version is read from `jwt.__version__` through setuptools dynamic versioning ([pyproject.toml](../../pyproject.toml)).

## Runtime Network Behavior

Most library paths are local computation. `PyJWKClient` is the network exception: it uses `urllib.request` to fetch a configured JWKS URI, permits only HTTP(S), and exposes caller-selected headers, timeout (default 30 seconds), and SSL context. A successful response can populate an in-memory JWKS cache with default lifespan 300 seconds; network failures become `PyJWKClientConnectionError` ([jwt/jwks_client.py](../../jwt/jwks_client.py)).

For a missing `kid`, the client refreshes the JWKS once before failing. A failed fetch does not overwrite a previously cached JWKS; this regression behavior is covered in [tests/test_jwks_client.py](../../tests/test_jwks_client.py).

## Configuration And Observability

- **verified:** `SPHINX_BUILD` is set by [docs/conf.py](../conf.py) to make type aliases available to Sphinx during documentation builds.
- **verified:** CI references the `CODECOV_TOKEN` secret only for coverage upload ([.github/workflows/main.yml](../../.github/workflows/main.yml)); this document intentionally does not contain its value.
- **missing:** no application runtime environment-variable configuration, logging, metrics, tracing, health endpoint, deployment topology, or recovery runbook was found. Those concerns belong to applications that embed the library.