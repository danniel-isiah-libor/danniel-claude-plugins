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
- **Parity:** ship a single `docker-compose.yml` for local that mirrors staging/prod via environment variables — **same image, same compose file, different config, never a different Dockerfile or compose file per OS or per environment**.
- Verify `docker compose up` works from a clean checkout on each OS (at minimum amd64 + arm64).

## One shared container setup for every environment (local → UAT/staging → prod)
The single biggest cause of "it works only in this environment" bugs is drift between separate Docker files and per-environment config files. **Eliminate that drift by sharing one container definition across every environment and letting only runtime values differ.** This is the default — do not split it per environment unless the user explicitly asks.

- **One Dockerfile.** Build the image **once** and promote that exact artifact unchanged from local → UAT → prod. No `Dockerfile.prod`/`Dockerfile.staging`, and no build args that change runtime behavior per environment.
- **One `docker-compose.yml`.** A single compose file serves every environment. Do **not** create `docker-compose.staging.yml`, `docker-compose.prod.yml`, or per-environment `docker-compose.override.yml`. If a value must differ, it is an environment variable — not a new file.
- **No per-environment env files.** Do **not** create `.env.development`, `.env.staging`, `.env.production`, etc. The set of variable **names** is identical everywhere; only the **values** differ, and they are injected at runtime by the platform:
  - **Cloud (UAT/prod):** values come from the platform's env config + Secret Manager (e.g. Cloud Run env vars and secret references). Nothing committed, nothing baked into the image.
  - **Local:** a single committed `.env.example` (variable names + placeholders, **no real secrets**) that each developer copies to a gitignored `.env`. One template — not one file per environment.
- **Same names, different values.** Reference variables identically in code and compose (`${DATABASE_URL}`, `${REDIS_URL}`, …) so the wiring is byte-for-byte the same everywhere; the environment supplies the value. Identical definition + identical wiring is exactly what kills "it only works in X."
- **What still differs per environment is data and identity, never the definition.** Each environment keeps its own isolated GCP project / Cloud Run service, its own database, its own secret **values**, and its own IAM. The container image and its orchestration definition stay identical; only the surrounding infrastructure and injected values are isolated.
- Local compose brings up the full stack (app + DB + cache) from that same image and file. UAT deploys on merge to `development`; prod is a gated deploy on `main` — both promoting the **same image artifact**.

## Industry-standard CI/CD pipeline
**CI (every push/PR):** install (cached) → lint → unit/integration tests → build image → security scan. Block merge on failure.

**CD — human manual approval is mandatory.** Every deployment or release to **UAT and production requires a human-intervention manual-approval trigger** before it runs. **Never auto-deploy to UAT or prod on merge.** Implement the gate with GitHub Actions Environments (required reviewers) + `workflow_dispatch`, GitLab `when: manual` environments, or a Cloud Build / Cloud Deploy approval step.

- **UAT deploy** (e.g. `development` → UAT/staging): manual approval → build & push the multi-arch image to Artifact Registry → deploy to UAT (Cloud Run) → **tag a pre-release** `vX.Y.Z-rc.N` and cut a **pre-release** (GitHub/GitLab Release marked pre-release) for UAT sign-off.
- **Production deploy** (`main`): manual approval → promote the **same image artifact** (no rebuild) → deploy to prod → **tag the final release** `vX.Y.Z` and publish the **release** with notes; keep a one-command rollback (previous revision/image) ready.

Derive versions from Conventional Commits (`git-conventions`): `fix`→patch, `feat`→minor, breaking→major. Tag **idempotently** (skip if the tag already exists). Authenticate via Workload Identity Federation (no keys); cache dependencies/layers for speed; run independent jobs in parallel.

> Example GitHub Actions shape — adapt to the project's forge (Cloud Build / GitLab CI): `test` → `build-scan-push` → `deploy-uat` (environment: `uat`, required reviewers) → `deploy-prod` (environment: `production`, required reviewers). Each deploy job ends with its tag + release step.
