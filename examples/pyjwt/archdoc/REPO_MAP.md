Last Reviewed Scope: full review
Doc Status: DRAFT
Last Repo Map Update: 2026-07-06T14:44:06Z
Updated By: agent
Source Basis: README scan; pyproject scan; code scan; tests scan; workflow scan; docs scan

# Repository Map

## Overview

PyJWT is a Python library for encoding, decoding, and validating JSON Web Tokens. The repository is organized around a single import package, `jwt/`, with a broad automated test suite, Sphinx-based user documentation, and GitHub Actions workflows for CI, packaging, and publishing.

This is a library repository, not an application service. There is no long-running process, local database, or deployment stack inside the repo.

## README Reality Check

| Topic | README says | Repository shows | Status | Gap / note |
|---|---|---|---|---|
| Install | `pip install PyJWT` | `pyproject.toml` defines package `PyJWT`; optional `crypto` extra adds `cryptography` | verified | README only shows the base install command |
| Basic usage | `jwt.encode(...)` and `jwt.decode(...)` | `jwt/__init__.py`, `jwt/api_jwt.py`, and tests expose those helpers | verified | Public facade matches README |
| Docs | Read the docs online | `docs/` contains Sphinx sources; `.readthedocs.yaml` configures hosted docs build | verified | Local docs build command is not mentioned in README |
| Tests | Run `tox` | `tox.ini` defines lint, typing, test, docs, packaging, and coverage envs | verified | README omits narrower commands such as `pytest` or `tox -e docs` |
| Release / publish | not documented | `.github/workflows/pypi-package.yml` publishes to Test PyPI on `master` and to PyPI on GitHub Release | missing | Release flow exists but is not summarized in README |

## Root-Level Structure

| Path | Purpose | Notes |
|---|---|---|
| `jwt/` | Library source package | Core encode/decode, algorithm, JWK, and JWKS client logic |
| `tests/` | Automated test suite | Unit-style tests plus key fixtures under `tests/keys/` |
| `docs/` | Sphinx documentation source | End-user docs; generated archdoc files now live alongside it |
| `.github/workflows/` | CI and release automation | Test matrix, package validation, and publishing |
| `pyproject.toml` | Packaging and tool config | Build backend, dependency groups, pytest, mypy, coverage |
| `tox.ini` | Primary maintainer command surface | Drives tests, docs, typing, lint, and package description checks |
| `.pre-commit-config.yaml` | Formatting and repo hygiene hooks | pyupgrade, Ruff, workflow validation, manifest checks |
| `ruff.toml` | Ruff lint/format config | Python 3.9 target, 88-char line length |
| `.readthedocs.yaml` | Hosted docs build config | Python 3.11, install with `.[crypto]` and docs group |

## Important File Index

| File | Why it matters |
|---|---|
| `README.rst` | User-facing package summary, install instructions, and basic examples |
| `pyproject.toml` | Canonical source for supported Python versions, optional extras, and tool config |
| `jwt/__init__.py` | Public export surface and package version |
| `jwt/api_jwt.py` | JWT payload encode/decode API and claim validation flow |
| `jwt/api_jws.py` | Low-level compact JWS assembly, parsing, header validation, and signature verification |
| `jwt/algorithms.py` | Algorithm registry and cryptography-backed key handling |
| `jwt/api_jwk.py` | JWK and JWK set parsing and normalization |
| `jwt/jwks_client.py` | HTTP-based JWKS retrieval with caching and scheme restrictions |
| `jwt/jwk_set_cache.py` | In-memory TTL cache for JWKS payloads |
| `tests/test_api_jwt.py` | Main behavior coverage for claims validation and public JWT API |
| `tests/test_api_jws.py` | Lower-level signature/header behavior coverage |
| `tests/test_jwks_client.py` | Network, caching, and JWKS lookup behavior coverage |
| `.github/workflows/main.yml` | CI matrix and validation breadth |
| `.github/workflows/pypi-package.yml` | Packaging and publishing flow |

## Main Entry Files

The package entry surface is import-driven:

- `import jwt` resolves through `jwt/__init__.py`.
- `jwt.encode`, `jwt.decode`, and `jwt.decode_complete` are module-level wrappers around a global `PyJWT` instance in `jwt/api_jwt.py`.
- `jwt.get_unverified_header`, `jwt.register_algorithm`, and related JWS helpers route through a global `PyJWS` instance in `jwt/api_jws.py`.
- `jwt.PyJWKClient` is the network-facing integration entry for JWKS discovery.

## Commands And Validation Map

| Command | Purpose | Evidence |
|---|---|---|
| `python -m pip install .` | Install the base library | `.github/workflows/main.yml` |
| `python -m pip install .[crypto]` | Install crypto-backed algorithms | `.github/workflows/main.yml`, `pyproject.toml` |
| `python -m pip install -e . --group dev` | Editable dev environment | `.github/workflows/main.yml` |
| `tox` | Full maintainer validation surface | `README.rst`, `tox.ini` |
| `tox -e docs` | Build docs, run doctests, and check `README.rst`/`docs/usage.rst` | `tox.ini` |
| `python -m pytest` | Direct test runner alternative | `pyproject.toml` pytest config |
| `pre-commit run --all-files` | Linting and repo hygiene | `tox.ini`, `.pre-commit-config.yaml` |
| `sphinx-build -n -T -W -b html docs docs/_build/html` | Direct docs build | `tox.ini`, `docs/Makefile` |

## Module Overview

| Module | Responsibility |
|---|---|
| `jwt/api_jwt.py` | High-level JWT API, default decode options, registered claim validation, and public wrappers |
| `jwt/api_jws.py` | Compact token segmentation, JOSE header handling, algorithm dispatch, and signature verification |
| `jwt/algorithms.py` | Concrete algorithm implementations and key preparation rules |
| `jwt/api_jwk.py` | JWK/JWKS object model and algorithm inference from key metadata |
| `jwt/jwks_client.py` | Remote JWKS fetch, cache policy, and key selection by `kid` |
| `jwt/jwk_set_cache.py` | Monotonic-clock TTL cache for fetched JWKS sets |
| `jwt/utils.py` | Base64url helpers, key conversion, and signature helpers |
| `jwt/exceptions.py` | Package-specific exception taxonomy |
| `jwt/types.py` | Shared typing aliases for options and key material |
| `jwt/warnings.py` | Warning classes for deprecations and insecure key length |

## Test Suite Map

| Area | Coverage evidence |
|---|---|
| Core JWT encode/decode and claim validation | `tests/test_api_jwt.py`, `tests/test_jwt.py` |
| JWS segment parsing and header rules | `tests/test_api_jws.py` |
| Algorithm behavior and key preparation | `tests/test_algorithms.py` |
| JWK parsing and key set handling | `tests/test_api_jwk.py` |
| Remote JWKS client behavior | `tests/test_jwks_client.py` |
| Security regressions / advisories | `tests/test_advisory.py` |
| Utility helpers | `tests/test_utils.py` |

Key fixtures for asymmetric algorithms live under `tests/keys/`.

## Integration Surface

| External surface | How PyJWT touches it |
|---|---|
| `cryptography` package | Enables RSA, EC, PS, and EdDSA algorithm support |
| HTTP(S) JWKS endpoints | `PyJWKClient` fetches key sets using `urllib.request` |
| Sphinx / Read the Docs | Builds published documentation from `docs/` |
| PyPI / Test PyPI | Package publication targets driven by GitHub Actions |
| Codecov | CI uploads combined coverage reports |

## Domain Language

- JWT: the claims-bearing token returned by `jwt.encode` and accepted by `jwt.decode`.
- JWS: the signed compact serialization layer handled in `jwt/api_jws.py`.
- JWK: a single JSON Web Key parsed by `PyJWK`.
- JWKS: a JSON Web Key Set fetched remotely or parsed locally by `PyJWKSet`.

## Project Conventions

- Source is flat inside one package instead of split into many subpackages.
- Public convenience helpers are exposed as module-level functions backed by global objects.
- Optional crypto-backed behavior is feature-gated by whether `cryptography` is installed.
- Docs and examples are treated as testable surfaces via doctest and Sphinx warning failures.
- Formatting and linting are expected to run through pre-commit and Ruff.

## Generated And Artifact Paths

- `docs/_build/`: local Sphinx output directory; generated, not source.
- `.tox/`, `.pytest_cache/`, `.ruff_cache/`, `dist/`, and `build/`: expected tool artifacts; not part of the architecture.

## Recommended Reading Order

1. `README.rst`
2. `pyproject.toml`
3. `jwt/__init__.py`
4. `jwt/api_jwt.py`
5. `jwt/api_jws.py`
6. `jwt/algorithms.py`
7. `jwt/api_jwk.py` and `jwt/jwks_client.py`
8. `tests/test_api_jwt.py` and `tests/test_jwks_client.py`
9. `tox.ini` and `.github/workflows/main.yml`

## Agent Work Guide

Before changing code:

1. Identify whether the change belongs to JWT payload validation, JWS signing/parsing, JWK parsing, or JWKS retrieval.
2. Search for an existing test file that already covers the same API surface.
3. Check whether the behavior differs between base install and `.[crypto]` installs.
4. Update the narrowest relevant tests first.
5. Run the smallest useful command first, then widen to `tox` only if needed.

Rules:

- Do not invent a new module boundary unless the existing flat package has been checked first.
- Treat token headers, payloads, keys, and JWKS responses as untrusted inputs.
- Preserve explicit allow-list behavior for algorithms; do not infer trust from token content.
- Keep docs and doctests aligned with API behavior.

## High-Risk Areas

| Area | Why it is risky | Inspect first |
|---|---|---|
| Algorithm selection and key preparation | Security bugs often appear where headers, keys, and algorithm families intersect | `jwt/api_jws.py`, `jwt/algorithms.py`, `tests/test_algorithms.py` |
| Claim validation | Time, audience, issuer, subject, and required-claim checks affect auth correctness | `jwt/api_jwt.py`, `tests/test_api_jwt.py` |
| JWKS fetching and caching | Network behavior, scheme validation, cache invalidation, and `kid` matching affect remote verification | `jwt/jwks_client.py`, `jwt/jwk_set_cache.py`, `tests/test_jwks_client.py` |
| Release and docs automation | Packaging metadata, docs builds, and trusted publishing are split across multiple workflows | `pyproject.toml`, `tox.ini`, `.github/workflows/*.yml`, `.readthedocs.yaml` |

## Current Repository Health

- Broad CI coverage is present across CPython, PyPy, multiple operating systems, typing, docs, and packaging.
- The repository appears actively maintained; recent commits include security hardening and formatter adoption.
- This review did not execute tests or docs builds locally, so operational status remains based on configuration evidence rather than live verification.

## Open Questions And Gaps

- There is no dedicated maintainer-oriented release checklist document in the repo; the release process must be reconstructed from workflows.
- The repository does not include architecture-specific design notes or ADRs, so intent is inferred from code and tests.