# Observability & logging

- **Structured logs** (JSON) with level, timestamp (UTC), service, version, and a **correlation/request ID** propagated across services and into error reports. One event per line.
- **Levels with meaning:** `error` = needs action; `warn` = recoverable anomaly; `info` = business events and lifecycle; `debug` = off in prod by default. Don't log in hot loops.
- **Log context, not secrets.** Never log credentials, tokens, full card numbers, or sensitive personal data; mask/hash identifiers where needed. Never log request bodies wholesale.
- **Errors:** log once at the boundary that handles them, with the cause chain and context; don't log-and-rethrow at every layer.
- **Health:** liveness (process up) and readiness (dependencies reachable) endpoints, kept cheap, no auth leaks.
- **Metrics:** the four golden signals — latency, traffic, errors, saturation — plus key business counters; label sparingly (avoid unbounded cardinality such as user IDs).
- **Tracing:** propagate trace context (W3C `traceparent`) across calls; instrument outbound HTTP/DB.
- **Make it actionable:** every alert maps to a runbook step and a user-visible symptom; prefer alerting on SLO burn rate over raw thresholds.
- On GCP this maps to Cloud Logging (structured JSON on stdout), Cloud Monitoring, and Cloud Trace — see the `gcp-devops` skill.
