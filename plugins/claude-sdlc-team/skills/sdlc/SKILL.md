---
name: sdlc
description: Orchestrate the SDLC pipeline end to end. Use when the user runs /sdlc with a request, or asks to "run the SDLC pipeline", "build this feature properly", or take a feature/fix from requirements through design and implementation. Routes work to the requirements-analyst, solution-architect, and implementer agents, enforces approval gates, and relays clarifying questions. Covers Phases 0–6 (requirements → design → implementation → parallel inspection → release → docs).
---

# SDLC Pipeline Orchestrator

You are the engineering manager. You do NOT do SDLC work yourself — you sequence phases, dispatch agents via the Agent tool, enforce gates, and relay questions. The request is in the skill arguments; if absent, ask the user what to build.

Read the `sdlc-artifacts`, `sdlc-gates`, and `project-memory` skills first — `sdlc-artifacts` defines the artifact layout, manifest schema, and the clarify-don't-guess protocol; `sdlc-gates` defines the `GATE`, `LOOP-GUARD`, and `PRECONDITION` primitives that every gate, fix-loop, and state refusal below is an invocation of; `project-memory` defines the committed `.claude/agent-memory/` store you load at run start and persist durable facts to.

## Rules (every phase)
1. **Delegate via the Agent tool** with the exact `subagent_type`. Never do a phase's work inline. Never pass a `model` override — agents inherit the session model.
2. **Relay questions.** When an agent returns `QUESTIONS FOR USER`, ask the user with AskUserQuestion (use the agent's options as choices), then continue the SAME agent via SendMessage with the answers. Repeat until `NO QUESTIONS`. Record anything unresolved in the manifest's Open Questions.
3. **Pass context forward.** Each agent starts fresh — embed/point to the prior artifacts it needs.
4. **Announce handoffs.** Before each phase, state in one line which agent you're dispatching and why; after, summarize briefly.
5. **Update the manifest** after each phase/gate.
6. **Project memory** (`project-memory`). At run start, read `.claude/agent-memory/` and forward the relevant entries into each subagent's dispatch prompt (per Rule 3); at completion, persist durable new facts (orchestrator-owned writes — dedup against existing fact files). Skip silently if the folder is absent.

## Phase 0 — Setup & intake
0. **Backlog-first intake (if Notion + backlog enabled).** If `.sdlc/notion.json` has `enabled: true`, the Notion MCP is connected, and the request is a *new* item — not already a ticket in the **Active** sprint — apply the Backlog-intake-stop `PRECONDITION` (`sdlc-gates`) — via `notion-sync`, capture it as a Backlog ticket (`SDLC Phase = Backlog`, `Status = To Do`, `Ready = false`, no `Sprint`), tell the user it is in the backlog and to schedule it with `/sdlc-sprint add` then refine it with `/sdlc-plan` before the sprint starts, and **stop** (do not branch or run phases). Run the full pipeline below only when Notion is disabled/unavailable, or the request corresponds to a ticket already in the **Active** sprint (build mode).
1. Apply `capability-discovery` to inventory project agents/skills/MCP. Apply the delegation policy: plugin agents are the priority; borrow a project agent only when needed; plugin skills lead, agents also draw on project skills. Announce any borrowed capability.
2. Apply `stack-detection` for a stack profile.
3. Slugify the request (`sdlc-artifacts` rules); create `docs/sdlc/<slug>/00-manifest.md`.
4. **Per-task branch** (apply `git-conventions`): determine the task type (feature/fix/chore — ask the user if unclear, per clarify-don't-guess), then cut `<type>/<slug>` from the latest `development`. Pick the branch flow by checkout mode:
   - **Single checkout (default):** `git checkout development`, pull the latest (`git pull --ff-only`; skip silently if there is no remote), `git checkout -b <type>/<slug>`, then re-sync `development` into the branch (`git merge development`).
   - **Parallel / worktree mode** — when running inside a linked worktree (detect with `git rev-parse --git-dir` ≠ `git rev-parse --git-common-dir`, meaning `development` is checked out in the main checkout and **must not** be checked out here): apply `git-conventions`' worktree-per-ticket flow — `git fetch origin`, base the branch on `origin/development` (already done when the worktree was created via `git worktree add -b <type>/<slug>`), and re-sync with `git merge origin/development` (no remote: `git merge development`). **Never `git checkout development` in a worktree.**

   Surface any merge conflicts to the user; never force-resolve or force-push.

## Phase 1 — Requirements
Dispatch `requirements-analyst` with the request + stack profile. Resolve `QUESTIONS FOR USER` (Rule 2).

### GATE ① — approve requirements (conditional)
`GATE(01-requirements.md, unlocks: Phase 2, agent: requirements-analyst, condition: Notion enabled AND ticket Ready=true)` per `sdlc-gates` (the `condition` checks `.sdlc/notion.json` is enabled and the ticket's `Ready = true`). When the condition is true — sprint planning already approved the requirements via `/sdlc-plan` — **skip this gate**, record `auto-passed: requirements approved at sprint planning` in the manifest, and proceed to Phase 2. Otherwise (standalone mode, or a non-`Ready` ticket) run the full `GATE` protocol. No Phase 2 without an Approve or a conditional auto-pass.

## Phase 2 — Design
Dispatch `solution-architect` with the approved `01-requirements.md`. Resolve questions.

### GATE ② — approve design
`GATE(02-design.md, unlocks: Phase 3, agent: solution-architect)` per `sdlc-gates`. No Phase 3 without Approve. (No `condition` — design is not produced during `/sdlc-plan`, so this gate runs in both modes.)

## Phase 3 — Implementation
Dispatch `implementer` with the approved `01` + `02`. Resolve questions. Summarize the `03-implementation.md` report (files changed, test results) to the user.

## Phase 4 — Inspection (parallel)
Dispatch `qa-tester`, `code-reviewer`, `security-reviewer`, `pipeline-reviewer`, and `e2e-tester` **in parallel** (multiple Agent calls in one turn) with the approved `02-design.md` + the diff. Each writes its artifact (`04a`/`04b`/`04c`/`04d`/`04e`) and returns a `VERDICT`. The `pipeline-reviewer` audits the repo's CI/CD config (`cicd-pipeline-audit`) and no-ops (`VERDICT: PASS`) if none exists. The `e2e-tester` drives the running app via Playwright (`end-to-end-testing`), records a review video to `docs/sdlc/<slug>/e2e-recordings/`, and no-ops (`VERDICT: PASS (n/a)`) if there is no web UI (asking before installing Playwright). Resolve any `QUESTIONS FOR USER` per Rule 2.

Merge the four results into one **deduplicated, severity-sorted issue list**.

### Fix loop
If issues remain: send the merged list to the SAME `implementer` agent (SendMessage — it keeps its context) to fix, re-run tests, and report; then re-dispatch the four inspectors on the new diff. Repeat. Apply `LOOP-GUARD(3)` (`sdlc-gates`): after 3 fix→inspect cycles without a clean pass, ask the user to continue another cycle / accept the remaining issues / intervene; set Notion `Status = Blocked` on escalation.

### GATE ③ — review sign-off & auto-integration
When the merged issue list is empty (all `VERDICT: PASS`) or the user accepts the remainder, present the result. **If the `e2e-tester` produced a recording, print the video path (`docs/sdlc/<slug>/e2e-recordings/<slug>-<flow>.webm`) and ask the user to watch it before approving.** Then run `GATE(merged review result + the E2E video, unlocks: auto-integration, agent: implementer)` per `sdlc-gates` — **Approve & integrate** confirms the E2E video was watched and approved when one exists. On a standalone run continuing into `/sdlc-release` this same session, GATE ③ collapses with GATE ④ into one "Approve & ship" confirmation (see `sdlc-gates`). On approval — unless `.sdlc/config.json` has `"autoIntegrate": false` — apply `git-conventions` **auto-integration**: re-sync `development` into the task branch, then auto-open a PR `<type>/<slug> → development` and merge it (GitHub `gh` / GitLab `glab` / local `git merge` fallback). In parallel/worktree mode the PR path is unchanged (it operates on pushed refs); the local `git merge` fallback runs from the **main checkout** (which holds `development`), per `git-conventions`. On a merge conflict or a red required check, leave the PR open, notify the user, and continue (non-blocking). Set the Notion ticket `Status = Done`. All stage promotions follow `git-conventions`' promotion policy — always via a PR/MR, and merged non-protected branches are deleted (the tier branches `main`/`staging`/`development` are never deleted). No release/docs without this sign-off.

## Phase 5 — Release (two stages, both gated)
- **Sprint close → staging (UAT).** `/sdlc-sprint close` applies `git-conventions` staging promotion: open + auto-merge a PR `development → staging` and trigger the staging deploy for UAT. **No version bump, no tag, no `main`.**
- **Production release (separate, after UAT).** Run `/sdlc-release`. **If a sprint is Active, do NOT release** — tell the user to close + UAT the sprint first, then stop. Dispatch `release-engineer` with the prior artifacts + diff; it authors the Docker/CI-CD prod config (manual-trigger deploy) for GCP, a version bump, and a changelog, **self-audits with `cicd-pipeline-audit` and fixes findings**, and writes `05-release.md`. Then apply `git-conventions` **production release**: open a PR `staging → main` (opened, not auto-merged); after the Gate-④ merge + tag, **publish the GitHub/GitLab Release** — the CI deploy job does it, or run `gh release create` manually when the repo has no deploy job (a tag alone won't appear on the Releases page). Resolve `QUESTIONS FOR USER` per Rule 2.

### GATE ④ — outward-facing confirmation
`GATE(05-release.md, unlocks: deploy/publish/push, agent: release-engineer)` per `sdlc-gates`, before ANYTHING outward-facing. GATE ④ is **never** auto-passed by a `condition`. Deploys are manual-trigger only; the orchestrator never triggers them itself. **Same-session collapse:** on a standalone run (Notion disabled) going review → release in one session, GATE ③ and GATE ④ present as a single "Approve & ship" confirmation (`sdlc-gates`).

## Phase 6 — Docs (optional)
Ask the user whether to document the feature. If yes, dispatch `tech-writer` with `01`/`02`/`03` + the diff; it updates README/API docs/changelog and writes `06-docs.md`. Resolve `QUESTIONS FOR USER`.

## Completion
Update the manifest (phase, status). Give the user a final summary: what was built, files changed, test results, and any Open Questions the agents flagged. Do not commit/push or deploy unless asked.

## Notion (if enabled)
If `.sdlc/notion.json` has `enabled: true` and the Notion MCP is connected, use the `notion-sync` skill for persistence and the `scrum-master` skill for sprint methodology. New requests are captured to the **Backlog** (Phase 0 intake). Before a sprint commences they are **refined to the Definition of Ready** via `/sdlc-plan` (apply `scrum-master`); `/sdlc-sprint start` is governed by the Ready-to-start `PRECONDITION` (`sdlc-gates`) — every ticket must be `Ready`. A ticket advances only once pulled into a **started** sprint. While building a ticket in the active sprint, **set BOTH `SDLC Phase` and `Status` at each phase/gate boundary** per the `notion-sync` mapping (Requirements/Design/Implementation → In Progress; Inspection → In Review; auto-merged to `development` at Gate ③ → Done; `Blocked` on loop-guard escalation) — this column movement is the daily cadence. At **sprint close**, apply `scrum-master` for a brief **review + retrospective**, then the batch is promoted to **staging for UAT**; **production release is a separate step** (`/sdlc-release`, after UAT). All writes are **non-blocking** — warn and continue on failure. If Notion is disabled or unavailable, skip silently.
