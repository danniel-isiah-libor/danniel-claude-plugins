# IaC review & rollback

## Terraform / IaC change checklist
Never `apply` to UAT/prod without explicit approval; run `plan` and show it.
- **Plan review:** read every `~ update` / `-/+ replace` / `- destroy` line; flag anything that recreates stateful resources (Cloud SQL, buckets, disks, KMS keys). Use `lifecycle { prevent_destroy = true }` on those.
- **State:** remote backend (GCS with versioning + locking); one state per environment; never edit state by hand — use `terraform state mv` / `import`; restrict state bucket access (it can contain secrets).
- **Drift:** run `plan` on a schedule or in CI; investigate non-empty plans instead of auto-applying.
- **Secrets:** none in `.tf`, `.tfvars`, or state outputs where avoidable; reference Secret Manager; mark sensitive variables/outputs.
- **IAM diffs:** least privilege; no `roles/owner|editor` on service accounts; no new `allUsers`/`allAuthenticatedUsers`; prefer per-service accounts and Workload Identity over keys.
- **Versions:** pin provider and module versions and the Terraform version; commit the lock file.
- **Environments:** same modules, different variable values; never copy-paste per environment.
- **Blast radius:** prefer small stacks (network, data, app) over one giant state; use `-target` only for recovery, never as routine.

## Rollback playbook (have it before you deploy)
| Layer | Rollback | Notes |
|---|---|---|
| Cloud Run app | Route traffic back to the previous revision (`gcloud run services update-traffic --to-revisions <rev>=100`) | Keep revisions; tag the last known-good |
| Container image | Redeploy the previous immutable tag/digest | Never rebuild an old tag; never use `latest` |
| IaC change | Revert the commit and `plan`/`apply`, or restore from the previous state version | Stateful resources may not be recoverable — snapshot first |
| DB migration | Down-migration only if it is data-safe; otherwise roll *forward* with a fix | Use expand → migrate → contract so the old code keeps working (`senior-development` → `database-design.md`) |
| Config / secret | Revert to the previous secret version / env value | Secret Manager keeps versions |

Before any prod change: state the **rollout order**, the **success signal** (health checks, error rate, latency), the **rollback trigger**, and who approves. After: verify the signal and record the outcome.
