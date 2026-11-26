# claude-dream-team — trigger & loop scenarios

Manual/automatable checks that the right agent is chosen and the review loop behaves. Run each prompt in a session with the plugin loaded (`claude --plugin-dir plugins/claude-dream-team`) and compare the delegated agent with **Expected**. A scenario fails if a different agent is chosen, or none when one is expected.

## Routing (prompt → expected agent)

| # | Prompt | Expected | Why / disambiguation |
|---|--------|----------|----------------------|
| 1 | "Add user profile editing — API endpoint, DB migration, and the settings form." | fullstack-developer | End-to-end feature code |
| 2 | "Our Cloud Run deploy times out pushing to Artifact Registry — fix the pipeline." | devops-engineer | CI/CD + GCP |
| 3 | "Write unit tests for the payment service covering edge cases." | qa-engineer | Only QA writes tests |
| 4 | "Add tests for the code you just wrote." (after a fullstack-developer turn) | qa-engineer | Developer must hand test authoring to QA |
| 5 | "Try to break the login form with XSS and SQL injection." | qa-engineer | Active VAPT, not CVE triage |
| 6 | "Scan this repo for known CVEs in our dependencies." | security-analyst | Known-vulnerability triage |
| 7 | "Does CVE-2024-3094 affect us?" | security-analyst | Single-CVE lookup |
| 8 | "Review my uncommitted changes for bugs and security issues." | qa-engineer | Code review |
| 9 | "Write a user guide for the billing dashboard for our client." | technical-writer | Audience-facing docs |
| 10 | "Draft release notes for the last release." | technical-writer | Uses git-conventions + release-notes recipe |
| 11 | "Add JSDoc comments to the utils module." | fullstack-developer | In-source comments are code, not docs deliverables |
| 12 | "Set up a Dockerfile and docker-compose for local dev on Mac and Windows." | devops-engineer | Containers |
| 13 | "Design the schema for an orders table with proper indexes." | fullstack-developer | Database design |
| 14 | "Create a Terraform module for Cloud SQL." | devops-engineer | IaC |
| 15 | "Update the npm packages that have vulnerabilities." | security-analyst first (report), then fullstack-developer for the change | Analyst is read-only; it routes the fix |
| 16 | "Summarize what this function does." | none | Trivial; no agent needed |

## Boundary checks

| # | Scenario | Expected behavior |
|---|----------|-------------------|
| B1 | Ask fullstack-developer to "also add unit tests" | Declines, flags the qa-engineer |
| B2 | Ask qa-engineer to "fix the bug you found in `src/`" | Reports finding, routes to `[fullstack-developer]`; edits no production code |
| B3 | Ask qa-engineer to "fix the flaky test" | Fixes the test file itself (`[qa-engineer]`) |
| B4 | Ask security-analyst to "just upgrade the vulnerable package" | Cannot (no Edit/Write); provides the exact command and routes to `[fullstack-developer]` |
| B5 | Ask technical-writer to "fix the typo in the code" | Declines code changes; flags for fullstack-developer |
| B6 | Ask devops-engineer to `terraform apply` on prod | Shows `plan`, asks for explicit approval first |

## `/dream-team-review` loop

| # | Invocation | Expected |
|---|-----------|----------|
| L1 | `/dream-team-review` with clean tree | Asks what to review |
| L2 | `/dream-team-review uncommitted` on a diff with no issues | One QA pass; report starts `VERDICT: PASS`; no fixes dispatched |
| L3 | Diff with a blocker in app code | Finding `F-01 … [fullstack-developer]` → developer fixes → re-verification table marks `F-01 FIXED`; ends PASS |
| L4 | Diff with "missing tests" major | Routed `[qa-engineer]`, not the developer; QA adds tests, then re-verifies |
| L5 | Dev and devops findings touching the same file | Dispatched sequentially, developer first |
| L6 | Diff changes `package-lock.json` | `security-analyst` also dispatched on iteration 1 and its items merged with continuing IDs |
| L7 | `--quick` | E2E and Security rows are `NOT RUN` (never PASS); no `security-analyst` unless deps changed |
| L8 | `--security` | Security + Review only; `security-analyst` always dispatched |
| L9 | A finding that never gets fixed | Stops after 3 iterations and lists open IDs for the user |
| L10 | Agent returns prose, not the report contract | Command asks QA to restate in the contract format |

## Static checks (run before each release)
1. `claude plugin validate plugins/<name>` and `claude plugin validate .` — no errors beyond the known reserved-name issue.
2. Frontmatter parses; `name` equals the file/folder name; every `references/*.md` is linked from its `SKILL.md`.
3. Plugin and marketplace versions match.

## Last run (2026-11-26, headless, `--plugin-dir`, empty repo, 2 turns)
Method: `claude -p "<prompt>" --plugin-dir plugins/claude-dream-team --max-turns 2 --output-format stream-json`, reading the first tool calls.

| Prompt # | First dream-team component engaged |
|---|---|
| 3 unit tests | skill `qa-testing` |
| 6, 7 CVE scan / lookup | skill `vulnerability-triage` |
| 9, 10 user guide / release notes | skill `documentation` |
| 12 Docker/compose | skills `project-adaptation` → `gcp-devops` |
| 13 schema design | skill `senior-development` |
| 14 Terraform | skill `gcp-devops` |
| 16 trivial | none (as expected) |
| 1, 5, 11 | none engaged — the model inspected the empty directory first |
| 2 | competing `superpowers:systematic-debugging` skill |
| 8 | built-in `code-review` skill |

Findings: skill triggering works for 8 of 14 prompts, including the new `vulnerability-triage`. In a one-shot headless run the main model handled work itself rather than delegating to an agent, so **agent auto-delegation (rows 1–16 "Expected") is not proven by this method** — re-run in a real repo, or name the agent explicitly. Prompts 1/5/11 need a populated repo; 2 and 8 compete with other installed plugins' skills.

Tool-allowlist check (agent asked to list its tools): `security-analyst` → Read, Bash, WebFetch, WebSearch, Skill (no Edit/Write ✔); `technical-writer` → Read, Write, Edit, Bash, Skill ✔. (Grep/Glob were not self-reported; agents' self-reports are not authoritative.)

Not executed: boundary checks B1–B6 and loop scenarios L1–L10 (need a populated repo and full multi-agent runs).
