---
description: Wire the current repo to the vault — find or scaffold its project note (repo frontmatter key + Business Rules section) and add the one-line pointer to the repo's CLAUDE.md, so every future session pulls domain context automatically.
argument-hint: "[project name | empty = derive from git remote / folder name]"
---

# /vault-wire

Connect the repo you are standing in to its Obsidian vault project note. After
this runs, the `project-context` skill has everything it needs: a vault note with
a `repo:` key and a `## Business Rules` section, and a pointer line in the repo's
`CLAUDE.md`. Use the `vault-keeper` agent, with `vault-conventions` deciding
*where* the note goes (it takes precedence on filing).

## Identify the repo

1. Confirm the cwd is a git repository; collect the **remote URL**
   (`git remote get-url origin`), the **folder name**, and a quick **stack
   sniff** (`composer.json` → PHP/Laravel + version, `package.json`,
   `Dockerfile`, etc.).
2. Project name = `$ARGUMENTS` if given, else derive from the remote/folder name
   and **confirm it with the user** before creating anything.

## Find or scaffold the vault note

3. **Match first, create second.** Search `Work/*/1 Projects/` (and
   `4 Archive/`) frontmatter for a `repo:` matching the remote URL — normalize
   `https`/`ssh` forms and a trailing `.git`. Fall back to a name match against
   note titles and folder names.
4. **If a note matches:** ensure its `repo:` key is set to the remote URL and
   that a `## Business Rules` section exists (add an empty scaffold with a
   one-line prompt if missing). Do not restructure the rest of the note.
5. **If nothing matches:** propose creating
   `Work/<current employer>/1 Projects/<Project>/<Project>.md` — confirm
   employer and name with the user, then create it from `_templates/Project.md`
   enriched with: `company`, `role`, `stack` (from the sniff), `repo` (remote
   URL), `status: active`, `created`, and a `## Business Rules` section.
   File per `vault-conventions`; never invent rules content — leave the section
   ready to be filled.

## Wire the repo

6. Add the pointer to the repo's `CLAUDE.md` (create a minimal one if absent),
   under a `## Knowledge sources` heading — **ask before writing** since this
   modifies the user's repo:

   ```markdown
   ## Knowledge sources
   - Vault project note (business rules / domain context):
     `<vault path to the note>`
   - Cross-project patterns: `<vault>/Knowledge/`
   ```

   If the heading already exists, update the path rather than duplicating it.
7. Skip the pointer gracefully if the user declines — the `project-context`
   skill can still find the note via the `repo:` match; say so.

## Rules

- Idempotent: re-running against an already-wired repo verifies and repairs
  (missing `repo:`, missing section, stale pointer path) instead of duplicating.
- Never overwrite existing note content or an existing CLAUDE.md section without
  showing the diff and confirming.
- Final output: the note path (found or created), what was added to it, and the
  CLAUDE.md change (or why it was skipped).
