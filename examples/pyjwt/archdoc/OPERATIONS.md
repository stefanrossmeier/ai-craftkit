Last Reviewed Scope: full review
Doc Status: DRAFT
Last Operations Update: 2026-07-06T14:44:06Z
Updated By: agent
Source Basis: README scan; pyproject scan; tests scan; workflow scan; docs scan

# Operations

## Purpose

This document describes how PyJWT is developed, validated, documented, packaged, and published. Because PyJWT is a library repository, the operational model is mostly about local development, test execution, docs generation, and release automation rather than service deployment.

## Runtime Overview

- Normal runtime is import-and-call inside another Python process.
- There is no server entry point, background worker, container image, or persistent datastore in the repo.
- The only built-in network interaction is optional JWKS retrieval via `PyJWKClient`.
- Release and documentation operations are performed by GitHub Actions and Read the Docs.

## Local Development Quick Start

1. Install the package for the mode you need:
   - `python -m pip install .`
   - `python -m pip install .[crypto]`
   - `python -m pip install -e . --group dev`
2. Run focused validation:
   - `python -m pytest`
   - `tox -e docs`
   - `pre-commit run --all-files`
3. Run the full maintainer surface with `tox` when touching multiple areas.

## Command Map

| Command | Purpose | Evidence |
|---|---|---|
| `tox` | Full validation matrix entry point | `README.rst`, `tox.ini` |
| `python -m pytest` | Run the test suite directly | `pyproject.toml` |
| `tox -e lint` | Run pre-commit-based lint and formatting checks | `tox.ini` |
| `tox -e docs` | Build HTML docs, run doctests, and test README examples | `tox.ini` |
| `tox -e pypi-description` | Build a wheel and validate long description metadata | `tox.ini` |
| `python -m build` | Build distribution artifacts | `.github/workflows/main.yml` |
| `python -m twine check dist/*` | Validate package metadata rendering | `.github/workflows/main.yml` |

## Execution Model

PyJWT executes synchronously inside the caller's process.

- Encode/decode calls are pure request-response library operations.
- Claim validation uses current UTC time at decode time.
- Optional JWKS retrieval performs blocking HTTP requests through `urllib.request`.
- JWKS caching is in-memory only and process-local.
- There is no built-in job queue, retry worker, or scheduler.

## Runtime Modes

| Mode | What changes |
|---|---|
| Base install | Supports `none` and HMAC algorithms; no `cryptography` dependency |
| `.[crypto]` install | Enables RSA, EC, PSS, and EdDSA algorithms |
| Docs build | Sphinx imports the package with `SPHINX_BUILD=1` behavior in `docs/conf.py` |
| CI matrix | Runs across CPython 3.9-3.14 and PyPy 3.9-3.11 on Ubuntu and Windows |

## Environment And Secrets

- Normal package use does not require environment variables.
- `docs/conf.py` sets `SPHINX_BUILD=1` during documentation generation to expose type aliases for autodoc.
- GitHub Actions use `CODECOV_TOKEN` for coverage upload in CI.
- PyPI publishing is configured through GitHub trusted publishing (`id-token: write`) rather than a plaintext repository secret in the workflow files.

## Deployment And Publication

| Surface | Mechanism | Evidence |
|---|---|---|
| Package verification | GitHub Actions `main.yml` builds and checks the package on every change | `.github/workflows/main.yml` |
| Test PyPI publishing | Pushes to `master` publish to Test PyPI when the repo owner matches | `.github/workflows/pypi-package.yml` | verified |
| PyPI publishing | GitHub Release publication triggers real PyPI upload | `.github/workflows/pypi-package.yml` | verified |
| Hosted docs | Read the Docs builds Sphinx docs on Python 3.11 with crypto extras | `.readthedocs.yaml` | verified |

## External Runtime Dependencies

| Dependency | When it matters |
|---|---|
| `cryptography` | Required for asymmetric algorithm support |
| Network access to JWKS endpoint | Required only when using `PyJWKClient` |
| Sphinx + theme packages | Required for docs generation |
| GitHub Actions / Read the Docs / PyPI services | Required for CI, docs hosting, and publishing |

## One Real System Action Trace

### Verify a JWT against a remote JWKS endpoint

1. Caller receives an encoded token.
2. Caller constructs `PyJWKClient(<https-url>)`.
3. `get_signing_key_from_jwt()` parses the unverified header to extract `kid`.
4. `PyJWKClient` fetches or reuses a cached JWKS document.
5. `PyJWKSet` / `PyJWK` convert the matching JWK into a usable public key.
6. Caller passes that key into `jwt.decode(..., algorithms=[...])`.
7. `PyJWS` verifies the signature.
8. `PyJWT` validates registered claims and returns the payload dict.

Evidence: `jwt/jwks_client.py`, `jwt/api_jwt.py`, `jwt/api_jws.py`, `tests/test_jwks_client.py`.

## Main Runtime Flows

### Encode

- Payload dict enters `PyJWT.encode`.
- Datetime claims are converted to numeric dates.
- `PyJWS.encode` serializes headers and payload.
- The selected algorithm signs the compact input.

### Decode

- `PyJWS.decode_complete` parses the compact token and verifies signature.
- `PyJWT._decode_payload` loads JSON payload bytes into a dict.
- `PyJWT._validate_claims` checks time, issuer, audience, subject, JTI, and required claims.

### Docs build

- `tox -e docs` installs docs dependencies and crypto extras.
- Sphinx builds HTML docs and doctest output.
- Python doctest also runs against `README.rst` and `docs/usage.rst`.

## Data Flow And Persistence

- Normal library calls keep all state in memory.
- `PyJWKClient` can cache full JWKS responses with a TTL and optionally cache per-key lookups via `functools.lru_cache`.
- There is no persistent cache, no database, and no file output during normal package operations.
- Release jobs produce distribution artifacts in `dist/`; docs builds produce output in `docs/_build/`.

## Logging And Observability

- The package does not implement its own logging layer.
- Operational signals are exposed through exceptions, warnings, CI job status, and coverage reports.
- Coverage is combined and uploaded to Codecov in CI.
- Docs failures are treated as build failures because Sphinx runs with warnings as errors.

## Debugging Guide

| Problem | First checks |
|---|---|
| Signature verification failure | Confirm the `algorithms` allow-list, key type, and whether `cryptography` is installed for asymmetric algorithms |
| Claim validation failure | Inspect `exp`, `nbf`, `iat`, `aud`, `iss`, `sub`, `jti`, plus the `options` dict and `leeway` |
| JWKS lookup failure | Check URL scheme, network availability, cache settings, and whether the token header `kid` matches a signing key |
| Docs build failure | Run `tox -e docs`; inspect `docs/conf.py`, `README.rst`, and `docs/usage.rst` doctests |
| Packaging metadata failure | Run `tox -e pypi-description` or `python -m twine check dist/*` |

## Failure Modes

| Failure mode | Likely symptom | Inspect first |
|---|---|---|
| Missing `cryptography` for asymmetric use | `NotImplementedError` or missing algorithm support | `jwt/algorithms.py`, install extras |
| Invalid token structure | `DecodeError` for segments or padding | `jwt/api_jws.py` |
| Claim mismatch or missing required claim | `InvalidAudienceError`, `InvalidIssuerError`, `MissingRequiredClaimError`, similar | `jwt/api_jwt.py` |
| Bad JWKS endpoint or scheme | `PyJWKClientError` / connection errors | `jwt/jwks_client.py` |
| Docs regressions | CI or Read the Docs build failure | `tox.ini`, `docs/conf.py`, RST files |
| Release metadata issues | `twine check` or build job failures | `pyproject.toml`, workflow files |

## Manual Recovery Notes

- If a JWKS-related change fails, re-run `tests/test_jwks_client.py` and temporarily disable caching options to isolate fetch vs cache behavior.
- If a docs build fails, run `tox -e docs` locally because that path also covers doctest examples from the README and usage docs.
- If packaging fails, rebuild with `python -m build` and validate with `twine check` before touching workflow files.
- If CI failures differ by Python version, compare `tox.ini` env mapping and recent typing/formatter changes before assuming runtime logic is broken.

## Security Operations

- Supported security versions are documented in `SECURITY.md`.
- Vulnerability reports should go through GitHub Security Advisories or `security@jpadilla.com`.
- Security-sensitive edits should preserve explicit algorithm allow-lists and the untrusted-input assumptions visible in code and tests.

## Current Operational Health

- The repository has broad automated validation coverage configured in CI.
- Publishing and hosted docs are automated and appear actively maintained from workflow configuration.
- This review did not execute tests, builds, or network calls, so current green status was not independently verified here.

## Safe Change Workflow

1. Change the narrowest relevant module under `jwt/`.
2. Update or add the closest tests under `tests/`.
3. Run the most specific `pytest` file first.
4. Run `tox -e docs` when user-facing behavior, docstrings, or examples change.
5. Run broader `tox` validation before release-sensitive merges.
6. Update `README.rst` or `docs/` if public behavior changes.

## Operational Gaps And Known Unknowns

- The repository does not contain a single human-written release runbook; release operations are inferred from workflows.
- There is no explicit policy document for cache tuning or network retry strategy in `PyJWKClient` beyond code and tests.