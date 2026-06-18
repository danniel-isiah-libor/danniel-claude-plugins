# Security Testing / VAPT

**Rules of engagement:** authorized testing of the project's own systems only; non-destructive; against local/staging (non-production); no DoS, no real data loss, no third-party targets. If scope or authorization is unclear, ask first.

## Method
1. Map the attack surface: inputs, endpoints, auth flows, file uploads, integrations, dependencies.
2. Test each class below; attempt a **safe proof-of-concept** to confirm exploitability (never a payload that destroys data).
3. Rate each finding (Critical / High / Medium / Low) with evidence/repro and a concrete remediation.

## Attack catalog
- **SQL injection:** tampered inputs reaching queries; confirm via parameterization gaps. Fix: parameterized queries / ORM bindings, input validation.
- **Cross-site scripting (XSS)** — reflected, stored, DOM: inject script via inputs/URLs/stored fields. Fix: context-aware output encoding, CSP, sanitize rich input.
- **CSRF:** state-changing requests without anti-CSRF tokens / SameSite cookies. Fix: tokens, `SameSite`, re-auth on sensitive actions.
- **SSRF:** user-controlled URLs fetched server-side. Fix: allowlist hosts, block internal ranges and metadata endpoints.
- **IDOR / broken access control:** swap IDs to reach other users' data; test every authorization boundary. Fix: server-side authorization on every object.
- **Auth/session:** weak passwords, missing lockout, session fixation, long-lived/predictable tokens, JWT algorithm issues. Fix: strong policies, rotation, secure cookies.
- **Secrets exposure:** secrets in code, logs, responses, client bundles, or git history. Fix: Secret Manager, scrub logs, rotate leaked secrets.
- **Dependency & config:** known-vulnerable packages, debug enabled, verbose errors, missing security headers. Run the toolchain audit (`npm audit`, `pip-audit`, `composer audit`, Trivy). Fix: upgrade, harden config, set headers.

## Tooling
Use what the project provides; otherwise standard OSS (OWASP ZAP for web, sqlmap to safely confirm SQLi, dependency auditors). Prefer automated scan + manual confirmation of real exploitability to cut false positives.

## Report
Per finding: title, category, severity, affected location (file/endpoint), repro/PoC, impact, remediation, and the owner tag for routing.
