# GCP Services — patterns by service

Judge every choice on: **speed · lightweight · scalability · cost-efficiency · security**. Prefer Infrastructure-as-Code (Terraform); isolate `dev`/`staging`/`prod` (separate projects, or strict per-env config).

## Cloud Run (default compute for containers)
- Stateless, request-driven; deploy the hardened container image (see `docker-and-cicd.md`).
- **Scale:** set `--concurrency` (e.g. 80), `--min-instances` (0 for cost, ≥1 to kill cold starts on hot paths), `--max-instances` to cap cost/blast radius.
- **Cost:** scale-to-zero for spiky/low traffic; right-size `--cpu`/`--memory`; CPU-always-allocated only when you need background work.
- **Security:** dedicated runtime service account with least privilege; `--no-allow-unauthenticated` + IAM / Identity-Aware Proxy for internal services; ingress controls; secrets from Secret Manager (env/mount), never baked in.

## Cloud SQL (managed Postgres/MySQL)
- Connect via the Cloud SQL Auth Proxy / connector over **private IP** — no public exposure.
- **Scale/cost:** start small, autoscale storage; read replicas for read-heavy load; stop non-prod instances off-hours.
- **Security:** IAM database auth where possible; least-privilege DB users (see senior-development → `database-design.md`); automated backups + point-in-time recovery; enforce SSL.
- **Speed:** pool connections (at the service, not per-request); push schema/index work into database-design.

## Cloud Storage (objects/blobs)
- **Cost:** right storage class (Standard/Nearline/Coldline/Archive); lifecycle rules to transition/delete; set retention.
- **Speed:** serve static/public assets via Cloud CDN or signed URLs; regional buckets near compute.
- **Security:** uniform bucket-level access + IAM (no per-object ACLs); private by default; signed URLs for temporary access; never public unless intended.

## Artifact Registry (images/packages)
- One registry per env or clear repo separation; **enable vulnerability scanning**; cleanup policies to delete old images (cost).
- Grant CI push and Cloud Run pull via least-privilege service accounts.

## IAM & Workload Identity
- **No long-lived service-account keys.** CI authenticates via Workload Identity Federation; workloads use an attached service account.
- One service account per workload, least privilege; avoid primitive roles (Owner/Editor); audit with the policy analyzer.

## Networking
- VPC with private connectivity to Cloud SQL / Memorystore; a Serverless VPC connector for Cloud Run egress to private resources.
- Cloud Load Balancing + Cloud Armor (WAF, rate limiting) in front of public services; HTTPS only.

## Secret Manager
- All secrets and sensitive config live here; grant access per service account; rotate; reference from Cloud Run / CI — never commit.

## Observability
- Cloud Logging + Monitoring; uptime checks and health endpoints; alerts on error rate / latency / saturation; **budget alerts** for cost; trace hot paths.
