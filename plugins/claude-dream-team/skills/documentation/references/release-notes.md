# Release notes from Conventional Commits

Release notes are for **users**, not a commit log. Derive them from history, then rewrite in user language.

## Recipe
1. **Find the range.** Last release tag → HEAD: `git describe --tags --abbrev=0` then `git log <tag>..HEAD --pretty='%h %s'` (add `--merges` for PR merges). If there is no tag, ask for the starting point.
2. **Derive the version** with `git-conventions`: any `!`/`BREAKING CHANGE:` → major; else any `feat` → minor; else `fix`/`perf` → patch. Don't invent a version the maintainers didn't choose — propose and confirm.
3. **Group by type:**
   | Commit type | Section |
   |---|---|
   | `feat` | New features |
   | `fix` | Fixes |
   | `perf`, `refactor` with user impact | Improvements |
   | `!` / `BREAKING CHANGE:` | Breaking changes / upgrade notes (first, with migration steps) |
   | `docs`, `test`, `ci`, `chore`, `build`, `style` | Omit unless users are affected |
4. **Rewrite** each item as a user benefit in plain language ("You can now export reports as PDF"), not the commit subject. Merge duplicates; link the issue/PR (`Refs #123`) when public.
5. **Verify** claims against the code/feature; drop anything you can't confirm and list it under open questions.
6. **Format:** version + date → Highlights → New features → Improvements → Fixes → Breaking changes / upgrade notes. Keep internal ticket IDs, infra details, and security-sensitive specifics (undisclosed vulnerabilities) out of client-facing notes.
