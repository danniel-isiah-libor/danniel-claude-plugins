---
description: Run the dream-team review loop — QA reviews & tests the change, then routes fixes to the dev/devops agents and re-verifies until clean.
argument-hint: "[uncommitted | <PR/MR number or URL> | <path>]"
---

# /dream-team-review

Orchestrate the claude-dream-team review → fix → verify loop over a change.

## Target
`$ARGUMENTS` selects what to review:
- empty or `uncommitted` → the working tree's uncommitted changes (`git diff` + untracked files).
- a PR/MR number or URL → fetch that PR/MR's diff (`gh pr diff`, or the platform's API).
- a path → review changes under that path.

If the target is ambiguous, or empty with a clean tree, ask the user what to review.

## Loop (max 3 iterations, then report and ask)
1. **Review + test.** Dispatch the `qa-engineer` agent on the target. It runs unit / E2E / security testing as applicable plus a comprehensive code review, and returns findings — each with severity, repro/evidence, recommended fix, and an owner tag `[fullstack-developer]` or `[devops-engineer]`.
2. **Verdict.** If there are no `blocker` or `major` findings → stop and report **PASS** with the full QA report.
3. **Route + fix.** Group findings by owner and dispatch in parallel:
   - `[fullstack-developer]` findings → the `fullstack-developer` agent to implement the fixes.
   - `[devops-engineer]` findings → the `devops-engineer` agent to implement the fixes.
   Give each agent only its own findings (severity, repro, recommended fix) and the relevant files.
4. **Re-verify.** Re-dispatch `qa-engineer` on the updated change to confirm the fixes and check for regressions. Go back to step 2.
5. After 3 iterations with findings still open, stop and report what's left for the user to decide.

## Rules
- Apply fixes to the **working tree only**. Do not commit, push, deploy, or merge — leave that to the user.
- Preserve each agent's boundaries (e.g. the devops-engineer confirms before destructive infra actions).
- Final output: the latest QA verdict, what each agent changed per iteration, and any unresolved findings.
