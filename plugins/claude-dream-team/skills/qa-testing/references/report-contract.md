# QA report contract

The qa-engineer's final message MUST follow this format so `/dream-team-review` (and a human) can parse it and track findings across iterations. Keep headings and keys exactly as shown.

## Format

```
VERDICT: PASS | ISSUES FOUND
SCOPE: <what was reviewed/tested; modes run: unit, e2e, security, review>

## Areas
| Area     | Verdict                          | Notes (coverage, tools, what was skipped and why) |
|----------|----------------------------------|----------------------------------------------------|
| Unit     | PASS / ISSUES FOUND / NOT RUN    | ... |
| E2E      | PASS / ISSUES FOUND / NOT RUN    | ... |
| Security | PASS / ISSUES FOUND / NOT RUN    | ... |
| Review   | PASS / ISSUES FOUND / NOT RUN    | ... |

## Findings
| ID   | Severity | Area | Owner | Location | Summary |
|------|----------|------|-------|----------|---------|
| F-01 | blocker  | Review | [fullstack-developer] | src/Foo.php:42 | ... |

### F-01 — <title>
- **Repro / evidence:** ...
- **Recommended fix:** ...

## Routed action list
[fullstack-developer]
- F-01 (blocker) — <one-line fix>
[devops-engineer]
- (none)
[qa-engineer]
- F-03 (major) — <missing/flaky test to add or fix>
```

## Rules
- **Verdict.** `PASS` only when there are zero `blocker` and zero `major` findings. `minor`/`nit` findings may accompany a PASS. Any open blocker/major → `ISSUES FOUND`.
- **IDs are stable.** Number findings `F-01`, `F-02`, … in the first pass. On re-verification, **reuse the same ID** for the same issue, never renumber, and give new issues the next unused number.
- **Re-verification** adds a `## Re-verification` table: `| ID | Status | Evidence |` with Status = `FIXED`, `STILL OPEN`, or `REGRESSION` (a previously fixed issue came back, or the fix broke something — give it a new ID and reference the old one). Then re-run the Areas table for the touched scope only.
- **Owners** are exactly `[fullstack-developer]`, `[devops-engineer]`, or `[qa-engineer]` (test gaps/flakiness). Dependency CVEs found during review → note them and recommend running the `security-analyst`; do not triage them yourself.
- **Not run ≠ pass.** An area that was skipped (scope flag, missing tooling, unsafe target) is reported `NOT RUN` with the reason; it never counts as PASS.
- **Evidence over assertion.** Every finding has repro steps or a `file:line` reference; never report a vulnerability you did not confirm (label unconfirmed ones `needs-confirmation`).
