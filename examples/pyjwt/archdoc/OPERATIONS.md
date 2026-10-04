# PyJWT Operations

**Review Scope:** targeted static repository inspection
**Doc Status:** MAINTAINED
**Last Updated:** 2026-10-04T07:40:52Z
**Updated By:** agent
**Source Revision:** `7144e4534c34810f4525dc4578a32addd8212cff`
**Source Basis:** `pyproject.toml`, `tox.ini`, `.readthedocs.yaml`, `.github/workflows/main.yml`, `.github/workflows/pypi-package.yml`, and package source

## Execution Model

**Verified:** PyJWT runs inside a consuming Python process; it has no repository-owned service startup command, deployment manifest, database migration, or long-lived daemon. The meaningful operational surfaces are installation, verification, documentation builds, and package publication.

Install the runtime library with:

```console
python -m pip install PyJWT
python -m pip install 'PyJWT[crypto]'
```

The `crypto` extra installs `cryptography>=3.4.0`, needed for algorithms such as RSA, EC, and EdDSA. Without it, compatible HMAC-only use remains available.

## Local Verification

**Verified:** [`tox.ini`](../../tox.ini) defines the supported verification workflow. Run commands from the repository root after dependencies for the chosen environment are available.

| Goal | Command | Evidence |
| --- | --- | --- |
| Run the configured suite | `python -m tox` | [`README.rst`](../../README.rst), [`tox.ini`](../../tox.ini) |
| Run a focused interpreter suite | `python -m tox -e py311` | [`tox.ini`](../../tox.ini) |
| Lint all files | `python -m tox -e lint` | [`tox.ini`](../../tox.ini) |
| Type-check | `python -m tox -e py311-mypy` | [`tox.ini`](../../tox.ini) |
| Build HTML docs and doctests | `python -m tox -e docs` | [`tox.ini`](../../tox.ini) |
| Build package artifacts | `python -m build` | [CI package job](../../.github/workflows/main.yml) |

The test environments run `coverage run -m pytest`; the declared matrix covers CPython 3.9 through 3.14, PyPy 3.9 through 3.11, and with/without the `crypto` extra where configured. The docs environment uses Python 3.11 and treats Sphinx warnings as errors.

## Configuration And Runtime Dependencies

- **Verified:** Build backend: `setuptools.build_meta`; package metadata and dependency groups are in [`pyproject.toml`](../../pyproject.toml).
- **Verified:** Runtime dependency: `typing_extensions >= 4.0` only below Python 3.11. Development, test, and documentation dependency groups are also declared there.
- **Verified:** The JWKS client accepts configuration through Python constructor arguments: `headers`, `timeout` (default 30 seconds), and `ssl_context`; it only requests HTTP(S) URLs.
- **Verified:** `SPHINX_BUILD` changes type-import behavior while Sphinx generates API documentation.
- **Verified:** `CODECOV_TOKEN` is referenced by CI when uploading coverage; its value is supplied as a GitHub Actions secret and is not documented here.

## CI, Documentation, And Release

- **Verified:** [`main.yml`](../../.github/workflows/main.yml) runs on pushes and pull requests targeting `master`, plus manual dispatch. It tests Ubuntu and Windows across the configured CPython/PyPy versions, checks package metadata, and tests normal, crypto-extra, and editable installs on Ubuntu, Windows, and macOS.
- **Verified:** The same workflow combines and uploads coverage from the Ubuntu/Python 3.9 run to Codecov.
- **Verified:** [`.readthedocs.yaml`](../../.readthedocs.yaml) builds documentation on Ubuntu with Python 3.11, installs the crypto extra and docs group, and fails on Sphinx warnings.
- **Verified:** [`pypi-package.yml`](../../.github/workflows/pypi-package.yml) builds and inspects packages, publishes development builds to TestPyPI on eligible `master` pushes, and publishes to PyPI when a GitHub release is published. Publishing uses GitHub OIDC trusted publishing (`id-token: write`).

## Failure Handling And Observability

- **Verified:** Token, key, and remote-JWKS failures are represented by documented exception types; callers need to catch or report them in their own process.
- **Verified:** JWKS retrieval converts network and timeout errors to `PyJWKClientConnectionError`. A signing-key miss refreshes the cached set once before `PyJWKClientError` is raised.
- **Verified:** The JWK-set cache is only replaced after a successful fetch, preserving a previously cached value through fetch errors.
- **Missing:** No repository-owned logs, metrics, traces, health endpoint, deployment rollback procedure, or production alerting configuration was found. Consumer applications own those concerns.

Public Python behavior is documented in [API_SURFACE.md](API_SURFACE.md); static component boundaries are documented in [ARCHITECTURE.md](ARCHITECTURE.md).