# Docker & CI/CD

Goals as always: **speed · lightweight · scalability · cost-efficiency · security**.

## Multi-stage, hardened image
- Multi-stage build: heavy build deps in a builder stage; copy only artifacts into a slim runtime stage.
- Minimal base: `distroless` or `alpine`; pin by version/digest, never `latest`.
- Run as a **non-root** user; read-only filesystem where possible; drop Linux capabilities.
- `.dockerignore` to keep the build context small; no secrets or `.env` in the image; add a `HEALTHCHECK`.
- Scan the image in CI (Trivy / Artifact Registry scanning) and fail on high/critical.

## Cross-platform local development (macOS / Windows / Linux)
The local image and compose stack must build and run on Apple Silicon + Intel macOS, Windows (Docker Desktop / WSL2), and Linux:
- **Multi-arch:** build with `docker buildx` for `linux/amd64,linux/arm64` so Apple Silicon and amd64 hosts both run natively; avoid arch-specific base images/binaries.
- **No OS-specific assumptions:** forward-slash paths inside the container; set `.gitattributes` (`* text=auto eol=lf`) so scripts keep LF on Windows; mark shell scripts executable and use `#!/usr/bin/env`.
- **Volumes/perf:** use named volumes for dependencies (`node_modules`, `vendor`) rather than host bind mounts to avoid slow/incorrect behavior on macOS/Windows; document Docker Desktop file-sharing.
- **Parity:** ship a `docker-compose.yml` for local that mirrors staging/prod via environment variables — **same image, different config, never a different Dockerfile per OS**.
- Verify `docker compose up` works from a clean checkout on each OS (at minimum amd64 + arm64).

## Environments: local → staging → prod
- **One image, many configs.** Build once; promote the same artifact. Configuration via env vars / Secret Manager, never code changes per env.
- Local: compose (app + DB + cache). Staging: deploy on merge to `development`. Prod: gated deploy on `main`.

## Industry-standard CI/CD pipeline
**CI (every push/PR):** install (cached) → lint → unit/integration tests → build image → security scan. Block merge on failure.

**CD — human manual approval is mandatory.** Every deployment or release to **UAT and production requires a human-intervention manual-approval trigger** before it runs. **Never auto-deploy to UAT or prod on merge.** Implement the gate with GitHub Actions Environments (required reviewers) + `workflow_dispatch`, GitLab `when: manual` environments, or a Cloud Build / Cloud Deploy approval step.

- **UAT deploy** (e.g. `development` → UAT/staging): manual approval → build & push the multi-arch image to Artifact Registry → deploy to UAT (Cloud Run) → **tag a pre-release** `vX.Y.Z-rc.N` and cut a **pre-release** (GitHub/GitLab Release marked pre-release) for UAT sign-off.
- **Production deploy** (`main`): manual approval → promote the **same image artifact** (no rebuild) → deploy to prod → **tag the final release** `vX.Y.Z` and publish the **release** with notes; keep a one-command rollback (previous revision/image) ready.

Derive versions from Conventional Commits (`git-conventions`): `fix`→patch, `feat`→minor, breaking→major. Tag **idempotently** (skip if the tag already exists). Authenticate via Workload Identity Federation (no keys); cache dependencies/layers for speed; run independent jobs in parallel.

> Example GitHub Actions shape — adapt to the project's forge (Cloud Build / GitLab CI): `test` → `build-scan-push` → `deploy-uat` (environment: `uat`, required reviewers) → `deploy-prod` (environment: `production`, required reviewers). Each deploy job ends with its tag + release step.
