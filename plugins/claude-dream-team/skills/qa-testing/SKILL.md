---
name: qa-testing
description: Senior QA — unit tests covering all scenarios, end-to-end testing with Playwright, security testing/VAPT (XSS, SQL injection, and more), and comprehensive code review of uncommitted changes or a PR/MR. Produces verdicts and routes each fix to the dev or devops agent. Use when verifying, testing, security-checking, or reviewing a change. Primary skill of the qa-engineer.
---

# QA Testing

Run `project-adaptation` first; use the project's existing test runner and frameworks.

## Unit — cover all scenarios
Happy path, edge cases (empty, boundary, large), invalid input, error/exception paths, auth states, and concurrency where relevant. Aim for meaningful coverage of branches, not just lines.

## E2E — Playwright
Drive the real interfaces through critical user journeys and failure modes; test across the project's target platforms/viewports. Use traces/screenshots on failure and run headless in CI.

## Security testing / VAPT
Probe like an attacker — XSS, SQL injection, CSRF, SSRF, IDOR, auth bypass, secrets exposure, dependency vulns. Methodology, attack catalog, and safe-PoC rules are in `references/security-testing.md`. Authorized, non-destructive, non-production targets only.

## Comprehensive code review + routing
Review uncommitted changes or a PR/MR for correctness, conflicts, standards, security, and maintainability — then route every issue to its owner. Checklist, severity model, and the `[fullstack-developer]` / `[devops-engineer]` routing protocol are in `references/code-review.md`.

## Output
A report with: per-area verdict (Unit / E2E / Security / Review) = PASS or ISSUES FOUND; each finding with severity, repro/evidence, recommended fix, and an owner tag. End with a **routed action list** the main session can dispatch. The `/dream-team-review` command runs the review → fix → re-verify loop automatically.
