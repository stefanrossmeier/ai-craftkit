# Operations

Review Scope: local verification, documentation build, package/release workflows, and JWKS runtime behavior
Doc Status: MAINTAINED
Last Updated: 2026-10-04T09:21:37Z
Updated By: agent
Source Repository: [jpadilla/pyjwt](https://github.com/jpadilla/pyjwt/tree/7144e4534c34810f4525dc4578a32addd8212cff)
Source Revision: [7144e4534c34810f4525dc4578a32addd8212cff](https://github.com/jpadilla/pyjwt/commit/7144e4534c34810f4525dc4578a32addd8212cff)
Source Basis: `pyproject.toml`, `tox.ini`, `.readthedocs.yaml`, GitHub workflows, `jwks_client.py`, JWKS tests

Related docs: [REPO_MAP.md](REPO_MAP.md), [ARCHITECTURE.md](ARCHITECTURE.md), and [API_SURFACE.md](API_SURFACE.md).

## Execution Modes

| Mode | Entry point / command | Purpose | Status |
|---|---|---|---|
| Library use | `import jwt` | Encode/decode JWTs in the host process | verified |
| Test matrix | `tox` | Runs configured Python, crypto/no-crypto, lint, typing, docs, and package targets according to environment mapping | verified |
| Documentation | `tox -e docs` | Builds Sphinx HTML/doctests and runs doctests for README and usage docs | verified |
| Package build | `python -m build` | Creates source and wheel artifacts in `dist/` | verified |

## Local Development and Verification

```bash
tox
tox -e lint
tox -e docs
python -m build
```

`pyproject.toml` requires Python 3.9+. Tox's default test environment uses the `tests` dependency group; its crypto variants install the `crypto` extra. The documentation environment uses Python 3.11, the docs dependency group, and the same crypto extra as Read the Docs. These commands are repository-defined in [`tox.ini`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/tox.ini).

## Runtime Configuration and Dependencies

| Name / dependency | Purpose | Default / behavior | Status |
|---|---|---|---|
| `pyjwt[crypto]` / `cryptography` | Asymmetric signing and verification algorithms | optional package extra; required for RSA, EC, PSS, and EdDSA | verified |
| `PyJWKClient.uri` | Remote JWKS endpoint | HTTP(S) only | verified |
| `headers`, `timeout`, `ssl_context` | Outbound JWKS request configuration | headers empty; timeout 30 seconds; TLS context optional | verified |
| `cache_jwk_set`, `lifespan` | Whole JWKS response cache | enabled; 300-second in-memory lifetime | verified |
| `cache_keys`, `max_cached_keys` | Per-`kid` key LRU cache | disabled; maximum 16 entries when enabled; no time expiry | verified |

PyJWT has no environment-variable-based runtime configuration evidenced in this revision. Host applications supply keys, validation options, and `PyJWKClient` configuration directly through the Python API.

## Important Runtime Flow: Remote JWKS Lookup

1. A host application constructs `PyJWKClient` with an HTTP(S) JWKS URI.
2. `get_jwk_set` returns its unexpired process-local cache or fetches JSON via `urllib.request.urlopen` using configured headers, timeout, and TLS context.
3. The client validates that the response is a JSON object, constructs a `PyJWKSet`, filters signing keys, and optionally refreshes once when a `kid` is absent.
4. A successful fetch updates the JWKS cache; a failed fetch raises `PyJWKClientConnectionError` without clearing a previously cached set.

Evidence: [`jwt/jwks_client.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/jwt/jwks_client.py) and [`tests/test_jwks_client.py`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/tests/test_jwks_client.py).

## Observability

No structured logging, metrics, tracing, health check, or library-owned telemetry is evidenced. Callers can observe failures through typed exceptions and warnings, including `PyJWKClientConnectionError` for network errors and `InsecureKeyLengthWarning` when weak keys are detected but enforcement is disabled. Host applications own production monitoring and recovery workflows.

## Deployment and Release

| Artifact / target | Delivery mechanism | Evidence | Status |
|---|---|---|---|
| Python distribution | CI builds via `python -m build`; artifacts are checked with Twine | [`main.yml`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/.github/workflows/main.yml) | verified |
| Test PyPI package | GitHub Actions publishes master-branch builds when repository owner is `jpadilla` | [`pypi-package.yml`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/.github/workflows/pypi-package.yml) | verified |
| PyPI release | GitHub Release publication triggers PyPI trusted publishing through `id-token: write` | [`pypi-package.yml`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/.github/workflows/pypi-package.yml) | verified |
| Hosted documentation | Read the Docs installs `.[crypto]` plus docs dependencies and runs Sphinx | [`.readthedocs.yaml`](https://github.com/jpadilla/pyjwt/blob/7144e4534c34810f4525dc4578a32addd8212cff/.readthedocs.yaml) | verified |

## Failure Modes and Operational Checks

| Failure | Expected behavior | Recovery / verification | Status |
|---|---|---|---|
| JWKS endpoint network/timeout failure | `PyJWKClientConnectionError`; existing JWKS cache is retained after unsuccessful refresh | Restore endpoint connectivity; retry through the caller; test coverage asserts cache preservation | verified |
| Invalid/non-object JWKS response | `PyJWKClientError` | Correct endpoint response; use `tests/test_jwks_client.py` as contract reference | verified |
| Missing optional `cryptography` dependency | Requested asymmetric algorithm is unavailable | Install `pyjwt[crypto]`; verify with crypto tox environment | verified |
| Package/docs regression | CI or local tox target fails | Run the failed repository-defined target | verified |

## Operational Gaps

- No package signing, release rollback, incident runbook, service-level objective, or live deployment observability procedure was found in repository evidence.
- `PyJWKClient` does not provide built-in retry/backoff beyond the one refresh for a missing key identifier; retry policy is caller-owned.