# PyJWT Repository Map

> Generated with `ai-craftkit` skill: `archdoc`  
> Source: `https://github.com/jpadilla/pyjwt.git` at commit `7144e4534c34810f4525dc4578a32addd8212cff`  
> Prompt: `Follow instructions in #prompt:SKILL.md with these arguments: generate the architecture documentation for the pyjwt repo.`

Last Reviewed Scope: full review
Doc Status: DRAFT
Last Repo Map Update: 2026-07-06T21:43:59Z
Updated By: agent
Source Basis: README scan | docs scan | code scan | test scan | workflow scan

## Overview

PyJWT is a Python library that implements JSON Web Token and JSON Web Signature handling for in-process use inside other applications. The repository is small and concentrated: most behavior lives under `jwt/`, documentation is built with Sphinx from `docs/`, and validation confidence comes primarily from a broad pytest suite exercised through `tox`.

This is not a service repository. There is no HTTP server, worker, database, or deployment manifest. The main integration surfaces are Python imports and the optional outbound JWKS fetch path in `PyJWKClient`.

## Where To Start

Recommended reading order for agents making code changes:

1. `README.rst` for install, usage, and test entry points.
2. `jwt/__init__.py` for the supported public import surface.
3. `jwt/api_jws.py` for token framing, signing, and signature verification.
4. `jwt/api_jwt.py` for JWT claim validation layered on top of JWS.
5. `jwt/api_jwk.py` and `jwt/jwks_client.py` for JWK/JWKS integration.
6. `tests/` nearest to the touched module.
7. `tox.ini`, `pyproject.toml`, and `.github/workflows/main.yml` for verification expectations.

## README Reality Check

| Topic | README says | Repository shows | Status | Gap / note |
|---|---|---|---|---|
| Install | `pip install PyJWT` | `pyproject.toml` defines package `PyJWT`; docs also show `pip install pyjwt` | verified | Package install works case-insensitively via PyPI naming conventions, but docs mostly use lowercase `pyjwt` |
| Basic usage | `jwt.encode(...)` and `jwt.decode(...)` | Public exports are re-exported from `jwt/__init__.py`; detailed examples live in `docs/usage.rst` | verified | README stays intentionally short |
| Tests | `tox` from project root | `tox.ini` defines lint, typing, docs, packaging, coverage, and Python-version matrices | verified | README does not mention narrower targets |
| Optional crypto install | not covered in README | `docs/installation.rst` documents `pip install pyjwt[crypto]` | missing | README omits the asymmetric-algorithm prerequisite |
| Docs build | not covered in README | `tox -e docs`, `.readthedocs.yaml`, and `docs/conf.py` define the docs pipeline | missing | Docs contribution path is discoverable only from repo files |
| Packaging / publish | not covered in README | GitHub Actions build and publish to TestPyPI / PyPI | missing | Release flow is workflow-driven, not described in README |

## Root-Level Structure

| Path | Purpose | Notes |
|---|---|---|
| `jwt/` | Library implementation | Core package; the main code area for almost every change |
| `tests/` | Pytest suite and test keys / JWK fixtures | High-value starting point for behavior changes |
| `docs/` | End-user and API documentation source | Sphinx sources plus generated architecture docs |
| `.github/workflows/` | CI, packaging, stale issue, and changelog enforcement workflows | Operational source of truth for automation |
| `pyproject.toml` | Packaging metadata, dependency groups, pytest and mypy config | Primary modern project manifest |
| `tox.ini` | Test, docs, lint, typecheck, and packaging environments | Best source for supported verification commands |
| `ruff.toml` | Ruff lint and formatting configuration | Encodes line length and lint selection |
| `.readthedocs.yaml` | Read the Docs build config | Uses Python 3.11 and installs `.[crypto]` plus docs group |
| `README.rst` | Quick start and project summary | Minimal but accurate |
| `SECURITY.md` | Security support and reporting policy | Operationally relevant for vulnerability handling |

## Important File Index

| File | Why it matters |
|---|---|
| `jwt/__init__.py` | Declares the stable public import surface and exported exceptions |
| `jwt/api_jws.py` | Owns compact token parsing, header validation, signing, and signature verification |
| `jwt/api_jwt.py` | Owns JWT claim validation and the top-level `encode`, `decode`, and `decode_complete` behavior |
| `jwt/algorithms.py` | Defines algorithm registry, optional cryptography support, and key preparation rules |
| `jwt/api_jwk.py` | Converts JWK JSON into usable key objects and validates JWK/JWK Set structure |
| `jwt/jwks_client.py` | Performs outbound JWKS retrieval and in-memory caching |
| `jwt/jwk_set_cache.py` | Defines TTL cache behavior for JWKS data |
| `jwt/types.py` | Documents typed option dictionaries that shape decode and verify behavior |
| `jwt/help.py` | Support utility that prints environment information for bug reports |
| `tests/test_api_jwt.py` | Main behavior specification for claim validation |
| `tests/test_api_jws.py` | Main behavior specification for token framing, algorithms, and detached payloads |
| `tests/test_jwks_client.py` | Network and caching contract tests for JWKS integration |

## Module Overview

| Module | Responsibility | Depends on |
|---|---|---|
| `jwt.api_jwt` | JWT payload encoding/decoding and claim validation | `jwt.api_jws`, `jwt.types`, `jwt.exceptions` |
| `jwt.api_jws` | JWS framing, signing, verification, and header parsing | `jwt.algorithms`, `jwt.api_jwk`, `jwt.utils` |
| `jwt.algorithms` | Algorithm implementations and key parsing | stdlib plus optional `cryptography` |
| `jwt.api_jwk` | JWK and JWK Set parsing | `jwt.algorithms`, `jwt.types`, `jwt.exceptions` |
| `jwt.jwks_client` | JWKS HTTP retrieval and cache-backed signing key lookup | `urllib`, `jwt.api_jwk`, `jwt.api_jwt`, `jwt.jwk_set_cache` |
| `jwt.exceptions` / `jwt.warnings` | Public error and warning taxonomy | referenced throughout package |
| `jwt.utils` | Base64url, PEM, DER/RAW signature helpers, and key-shape helpers | used by `api_jws` and `algorithms` |
| `jwt.types` | TypedDict contracts for options and JWK dictionaries | compile-time aid, also docs source |

## Commands And Verification

| Command | Purpose | Evidence |
|---|---|---|
| `tox` | Full local verification entry point | `README.rst`, `tox.ini` |
| `tox -e docs` | Build Sphinx docs, doctests, and README doctests | `tox.ini` |
| `python -m tox -e lint` | Run pre-commit hooks across the repo | `tox.ini` |
| `python -m tox -e py311-crypto` | Run one representative crypto-enabled test environment | `tox.ini` |
| `python -m tox -e py311-mypy` | Run static typing | `tox.ini` |
| `python -m build` | Build distribution artifacts | `.github/workflows/main.yml` |
| `python -m pip install .` | Install base package | `.github/workflows/main.yml` |
| `python -m pip install .[crypto]` | Install asymmetric-algorithm support | `docs/installation.rst`, `.github/workflows/main.yml` |
| `python -m pip install -e . --group dev` | Install editable development environment | `.github/workflows/main.yml` |
| `python -m jwt.help` | Print environment info for bug reports | `jwt/help.py` |

## Test Suite Map

| Area | Coverage focus |
|---|---|
| `tests/test_api_jwt.py` | Claim validation, option handling, registered claims, deprecations |
| `tests/test_api_jws.py` | Token parsing, header rules, algorithm selection, detached payload handling |
| `tests/test_algorithms.py` | Key preparation, JWK conversion, crypto algorithm behavior |
| `tests/test_api_jwk.py` | JWK parsing and JWK Set validation |
| `tests/test_jwks_client.py` | HTTP fetch, caching, signing-key selection, failure handling |
| `tests/test_exceptions.py` | Public exception hierarchy |
| `tests/test_advisory.py` | Security regressions / vulnerability-focused behavior |
| `tests/test_compressed_jwt.py` | Subclass override path for custom payload encoding/decoding |
| `tests/keys/` | PEM, JWK, JWK Set, and certificate fixtures |

## Integration Surface Summary

PyJWT does not expose an HTTP API or a CLI application. The meaningful integration points are:

- Python import surface re-exported from `jwt/__init__.py`
- Optional cryptography-backed algorithm support via `.[crypto]`
- Outbound JWKS retrieval over `http` or `https` through `PyJWKClient`

Detailed interface ownership and contracts are documented in `API_SURFACE.md`.

## Conventions

| Convention | Evidence |
|---|---|
| Python 3.9+ only | `pyproject.toml`, GitHub Actions matrix |
| Keep core package importable without `cryptography` | `pyproject.toml` optional extra, `jwt/algorithms.py` fallback path |
| Use `tox` as the umbrella task runner | `README.rst`, `tox.ini` |
| Use pytest for behavioral tests | `pyproject.toml`, `tests/` |
| Use mypy in strict mode | `pyproject.toml` |
| Use Ruff and pre-commit for lint / formatting enforcement | `ruff.toml`, `tox.ini` |
| Keep documentation in Sphinx `.rst` plus doctests | `docs/`, `tox.ini`, `.readthedocs.yaml` |

## Glossary

| Term | Meaning in this repo |
|---|---|
| JWT | Claims-oriented token format handled in `jwt.api_jwt` |
| JWS | Compact signed token framing handled in `jwt.api_jws` |
| JWK | JSON key material parsed by `jwt.api_jwk.PyJWK` |
| JWKS | JSON Web Key Set fetched or parsed into `PyJWKSet` |
| `verify_signature` | Switch controlling cryptographic verification during decode |
| `strict_aud` | Option that tightens audience matching semantics |

## Search Hints For Agents

- Search `verify_` in `jwt/api_jwt.py` to find claim-validation switches.
- Search `b64` in `jwt/api_jws.py` for detached-payload handling.
- Search `requires_cryptography` in `jwt/algorithms.py` to find crypto-gated algorithms.
- Search `cache_keys` and `lifespan` in `jwt/jwks_client.py` for JWKS cache behavior.
- Search `RemovedInPyjwt3Warning` across `jwt/` and `tests/` before changing deprecated arguments.

## Agent Work Guide

Before changing code:

1. Identify the owning module from the module overview.
2. Search for an existing test that already describes the target behavior.
3. Check whether the change affects the top-level exports in `jwt/__init__.py`.
4. For decode behavior, inspect both `jwt/api_jwt.py` and `jwt/api_jws.py` before editing.
5. For key handling, inspect `jwt/algorithms.py`, `jwt/api_jwk.py`, and fixtures under `tests/keys/` together.
6. Run the narrowest relevant tox or pytest target first.
7. Update docs if the public import surface or behavior changes.

Rules:

- Do not add a new integration pattern until the current public surface has been checked.
- Keep compatibility with `cryptography`-absent installs unless the task explicitly changes that policy.
- Treat decode defaults and warning behavior as compatibility-sensitive.
- Prefer changes that preserve top-level imports or document the break clearly.

## High-Risk Areas

| Area | Why risky | What to inspect first |
|---|---|---|
| Algorithm selection and key preparation | Mistakes can reintroduce algorithm-confusion or invalid-key acceptance issues | `jwt/algorithms.py`, `tests/test_algorithms.py`, `tests/test_advisory.py` |
| Decode defaults and claim validation | Small changes alter security posture and compatibility | `jwt/api_jwt.py`, `jwt/types.py`, `tests/test_api_jwt.py` |
| Detached payload handling | RFC-specific edge cases affect signature safety and parsing costs | `jwt/api_jws.py`, `tests/test_api_jws.py` |
| JWKS client fetching and caching | Network failures and stale caches change auth behavior in downstream apps | `jwt/jwks_client.py`, `jwt/jwk_set_cache.py`, `tests/test_jwks_client.py` |
| Public exports and exceptions | External applications import these symbols directly | `jwt/__init__.py`, `docs/api.rst` |

## Current Repository Health

- Verified from repository scan: active CI, packaging, typecheck, lint, docs, and coverage paths are all defined.
- Verified from repository scan: the repo is focused and low on structural sprawl.
- Missing from this review: local execution of `tox`, docs build, and packaging commands.

## Known Unknowns

- Could not verify test or docs pass status because dependencies were not installed and no commands were executed beyond read-only inspection.
- Could not confirm whether any undocumented downstream consumers depend on semi-internal modules such as `jwt.utils`; only the documented and exported surface was inspected directly.