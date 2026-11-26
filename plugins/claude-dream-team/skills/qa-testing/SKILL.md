---
name: qa-testing
description: Senior QA — unit tests covering all scenarios, end-to-end testing with Playwright, security testing/VAPT (XSS, SQL injection, and more), and comprehensive code review of uncommitted changes or a PR/MR. Produces verdicts and routes each fix to the dev or devops agent. Use when verifying, testing, security-checking, or reviewing a change. Primary skill of the qa-engineer.
---

# QA Testing

Run `project-adaptation` first; use the project's existing test runner and frameworks.

## Unit — cover all scenarios
Happy path, edge cases (empty, boundary, large), invalid input, error/exception paths, auth states, and concurrency where relevant. Aim for meaningful coverage of branches, not just lines. Scenario matrix, design rules, and coverage guidance: `references/unit-testing.md`.

## E2E — Playwright
Drive the real interfaces through critical user journeys and failure modes; test across the project's target platforms/viewports. Locator strategy, isolation, flake handling, and CI setup: `references/playwright-e2e.md`.

## Security testing / VAPT
Probe like an attacker — XSS, SQL injection, CSRF, SSRF, IDOR, auth bypass, secrets exposure, config. (Known-CVE dependency triage goes to the `security-analyst` + `vulnerability-triage`.) Methodology, attack catalog, and safe-PoC rules are in `references/security-testing.md`. Authorized, non-destructive, non-production targets only — record target, authorization, and constraints first (see the scope checklist in that reference).

## Comprehensive code review + routing
Review uncommitted changes or a PR/MR for correctness, conflicts, standards, security, and maintainability — then route every issue to its owner. Checklist, severity model, and the `[fullstack-developer]` / `[devops-engineer]` / `[qa-engineer]` routing protocol are in `references/code-review.md`.

## Test authoring boundary
The qa-engineer is the only agent that writes test code — it may create or modify tests, fixtures, mocks, and test config, never production code. Test gaps are owned `[qa-engineer]`.

## Output
Follow the exact format in `references/report-contract.md`: overall `VERDICT:` line, per-area verdicts (Unit / E2E / Security / Review), a findings table with stable IDs (severity, owner, repro, fix), and a **routed action list**. The `/dream-team-review` command parses it to run the review → fix → re-verify loop.
