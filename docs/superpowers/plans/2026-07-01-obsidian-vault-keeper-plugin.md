# Obsidian Vault Keeper Plugin Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an `obsidian-vault-keeper` plugin to the marketplace — an active Obsidian vault steward (agent + skill + command) — and slim `claude-dream-team`'s `obsidian-conventions` skill into a technical-writer primer, making the new plugin the single source of truth for Obsidian knowledge.

**Architecture:** Mirror the existing `claude-dream-team` plugin shape (`.claude-plugin/plugin.json`, `agents/`, `skills/<name>/SKILL.md` + `references/`, `commands/`). Move the three Obsidian reference files out of `claude-dream-team` into the new plugin's `obsidian-vault` skill (preserving git history), enrich them, add a new maintenance-workflows reference, an agent, and a command. Then collapse `claude-dream-team`'s skill to an inline primer and update all manifests/cross-references.

**Tech Stack:** Claude Code plugin format (Markdown + YAML frontmatter, JSON manifests). No build system. "Tests" for this content-authoring plan are: JSON validity checks, frontmatter/structure checks, dangling-reference greps, and the `plugin-validator` + `skill-reviewer` agents.

## Global Constraints

- **Marketplace root:** `/Users/dannielibor/Projects/Personals/Packages/danniel-claude-plugins`. All paths below are relative to it.
- **New plugin path:** `plugins/obsidian-vault-keeper/`.
- **Naming (verbatim):** plugin `obsidian-vault-keeper`; agent `vault-keeper`; skill `obsidian-vault`; command `/vault-checkup`.
- **Agent frontmatter:** `model: opus`, `color: purple`, `description` uses a `>-` block scalar with two `<example>…<commentary>` blocks (match `plugins/claude-dream-team/agents/technical-writer.md` style).
- **Obsidian MCP reality (verified):** tools are `obsidian_list_files_in_vault` (root only), `obsidian_list_files_in_dir`, `obsidian_simple_search`, `obsidian_complex_search` (JsonLogic + `glob`/`regexp`), `obsidian_get_file_contents`, `obsidian_batch_get_file_contents`, `obsidian_get_recent_changes`, `obsidian_get_periodic_note`, `obsidian_get_recent_periodic_notes`, `obsidian_patch_content` (append/prepend/replace vs. heading|block|frontmatter), `obsidian_append_content`, `obsidian_delete_file` (needs `confirm: true`). **There is NO move/rename tool, and the REST API does NOT auto-update `[[links]]`.** Every move = create-at-new-path → fix backlinks → delete-old.
- **Fallback:** when `mcp__obsidian__*` is not connected, operate on the vault via Read/Edit/Write on the vault folder path.
- **Commit style:** Conventional Commits, matching repo history (`feat(scope):`, `refactor(scope):`, `chore:`). End every commit body with:
  `Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>`
- **Do not push, tag, or release** — leave that to the user.
- **Version reconciliation:** before editing versions, read the ACTUAL committed value in `plugins/claude-dream-team/.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` and bump from there (do not assume any remembered value). New plugin ships at `0.1.0`.

---

### Task 1: Scaffold the new plugin (manifest + README)

**Files:**
- Create: `plugins/obsidian-vault-keeper/.claude-plugin/plugin.json`
- Create: `plugins/obsidian-vault-keeper/README.md`

**Interfaces:**
- Consumes: nothing.
- Produces: the plugin root directory and a valid `plugin.json` with `name: "obsidian-vault-keeper"` that later tasks populate.

- [ ] **Step 1: Create `plugin.json`**

```json
{
  "name": "obsidian-vault-keeper",
  "description": "An active Obsidian vault steward you summon whenever you work in your vault. The vault-keeper agent maintains your vault to best practices through the Obsidian MCP (with a filesystem fallback): captures and files notes into PARA, builds and refreshes MOC index notes, fixes broken [[links]] and finds orphans, normalizes frontmatter properties, safely dedupes and renames, and runs the employer/archive lifecycle. Backed by the obsidian-vault skill (Obsidian-flavored Markdown, the official Obsidian style guide, PARA vault organization, and MCP-aware maintenance workflows) and a /vault-checkup command that runs a read-only health sweep, reports findings, and offers to fix. The marketplace's single source of truth for Obsidian knowledge.",
  "version": "0.1.0",
  "author": {
    "name": "Danniel Libor"
  },
  "keywords": ["obsidian", "vault", "para", "moc", "wikilinks", "frontmatter", "dataview", "knowledge-management", "note-taking", "maintenance", "mcp"]
}
```

- [ ] **Step 2: Create `README.md`**

```markdown
# obsidian-vault-keeper

An active Obsidian **vault steward** for Claude Code. Summon it whenever you work
in your Obsidian vault and it does the maintenance — it reads and edits the
vault, it doesn't just advise.

## What's inside

- **`vault-keeper` agent** — a senior Obsidian librarian. Surveys the vault,
  applies best-practice conventions (or the vault's own), and performs the work:
  capture and file into PARA, build/refresh MOCs, fix broken links, find orphans,
  normalize frontmatter, safely dedupe/rename, run the archive lifecycle.
- **`obsidian-vault` skill** — the knowledge base: Obsidian-flavored Markdown, the
  official Obsidian style guide, PARA vault organization, and MCP-aware
  maintenance workflows. This is the marketplace's single source of truth for
  Obsidian conventions.
- **`/vault-checkup` command** — a read-only health sweep (orphans, broken links,
  frontmatter drift, misfiled/duplicate notes, stale MOCs) that reports findings
  and offers to fix.

## Obsidian access

The agent prefers the **Obsidian MCP** (`mcp__obsidian__*`, via the Local REST API
plugin) when it's connected, and falls back to direct filesystem editing of the
vault folder when it isn't. The MCP has no move/rename tool and does not
auto-update `[[links]]`, so the steward treats every move as create-new →
fix backlinks → delete-old.

## Install

Add via the `danniel-claude-plugins` marketplace, then invoke the `vault-keeper`
agent or run `/vault-checkup`.
```

- [ ] **Step 3: Verify the manifest is valid JSON**

Run: `python3 -c "import json; d=json.load(open('plugins/obsidian-vault-keeper/.claude-plugin/plugin.json')); print(d['name'], d['version'])"`
Expected: `obsidian-vault-keeper 0.1.0`

- [ ] **Step 4: Verify structure exists**

Run: `test -f plugins/obsidian-vault-keeper/.claude-plugin/plugin.json && test -f plugins/obsidian-vault-keeper/README.md && echo OK`
Expected: `OK`

- [ ] **Step 5: Commit**

```bash
git add plugins/obsidian-vault-keeper/.claude-plugin/plugin.json plugins/obsidian-vault-keeper/README.md
git commit -m "$(cat <<'EOF'
feat(obsidian-vault-keeper): scaffold plugin manifest and README

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

### Task 2: Move + enrich the three Obsidian references

Preserve git history by moving the existing reference files from `claude-dream-team` into the new skill, then enrich `vault-organization.md` for the steward.

**Files:**
- Move: `plugins/claude-dream-team/skills/obsidian-conventions/references/style-guide.md` → `plugins/obsidian-vault-keeper/skills/obsidian-vault/references/style-guide.md`
- Move: `plugins/claude-dream-team/skills/obsidian-conventions/references/obsidian-syntax.md` → `plugins/obsidian-vault-keeper/skills/obsidian-vault/references/obsidian-syntax.md`
- Move: `plugins/claude-dream-team/skills/obsidian-conventions/references/vault-organization.md` → `plugins/obsidian-vault-keeper/skills/obsidian-vault/references/vault-organization.md`
- Modify: `plugins/obsidian-vault-keeper/skills/obsidian-vault/references/vault-organization.md` (append an "Auditing an existing vault" section + a cross-link)

**Interfaces:**
- Consumes: the three files' existing content (unchanged by the move).
- Produces: three references under `skills/obsidian-vault/references/`; `claude-dream-team/skills/obsidian-conventions/references/` no longer exists.

- [ ] **Step 1: Create the target directory and move all three files with git**

```bash
mkdir -p plugins/obsidian-vault-keeper/skills/obsidian-vault/references
git mv plugins/claude-dream-team/skills/obsidian-conventions/references/style-guide.md plugins/obsidian-vault-keeper/skills/obsidian-vault/references/style-guide.md
git mv plugins/claude-dream-team/skills/obsidian-conventions/references/obsidian-syntax.md plugins/obsidian-vault-keeper/skills/obsidian-vault/references/obsidian-syntax.md
git mv plugins/claude-dream-team/skills/obsidian-conventions/references/vault-organization.md plugins/obsidian-vault-keeper/skills/obsidian-vault/references/vault-organization.md
# git leaves the now-empty source dir on disk; remove it so obsidian-conventions holds only SKILL.md
rmdir plugins/claude-dream-team/skills/obsidian-conventions/references 2>/dev/null || true
```

- [ ] **Step 2: Verify the move (new path present, old path gone)**

Run: `ls plugins/obsidian-vault-keeper/skills/obsidian-vault/references/ && echo "---" && ls plugins/claude-dream-team/skills/obsidian-conventions/references/ 2>&1`
Expected: three `.md` files listed under the new path; the old path errors with `No such file or directory`.

- [ ] **Step 3: Enrich `vault-organization.md` — append an auditing section**

Append the following to the END of `plugins/obsidian-vault-keeper/skills/obsidian-vault/references/vault-organization.md` (after the existing "Common pitfalls" section):

```markdown

## Auditing an existing vault (steward's pass)

When taking over or maintaining an established vault, audit before you
restructure — the vault's own conventions win over these defaults:

- **Inventory first.** Enumerate every note and folder; note the naming
  conventions, folder scheme, and whether MOCs and templates already exist.
- **Measure health, don't assume it.** Count orphans (no in/out links), broken
  `[[links]]`, notes missing frontmatter, and `_inbox` backlog before proposing
  changes.
- **Least-disruptive change.** Prefer adding links and MOCs over moving files;
  every move risks link breakage (see below and `maintenance-workflows.md`).
- **Confirm destructive steps.** Merges, deletes, and bulk moves are proposed
  with counts and confirmed before running.

The operational how-to for each of these lives in `maintenance-workflows.md`.
```

- [ ] **Step 4: Verify the cross-reference resolves**

Run: `grep -c "maintenance-workflows.md" plugins/obsidian-vault-keeper/skills/obsidian-vault/references/vault-organization.md`
Expected: `2` (or greater) — the section references the sibling file that Task 3 creates.

- [ ] **Step 5: Commit**

```bash
git add -A plugins/obsidian-vault-keeper/ plugins/claude-dream-team/
git commit -m "$(cat <<'EOF'
feat(obsidian-vault-keeper): move Obsidian references into obsidian-vault skill

Move style-guide, obsidian-syntax, and vault-organization out of
claude-dream-team (history preserved) and enrich vault-organization with a
steward's auditing pass.

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

### Task 3: Write the maintenance-workflows reference (the steward's operations manual)

**Files:**
- Create: `plugins/obsidian-vault-keeper/skills/obsidian-vault/references/maintenance-workflows.md`

**Interfaces:**
- Consumes: the Obsidian MCP tool names from Global Constraints; PARA/naming rules from `vault-organization.md`.
- Produces: nine named workflows the `SKILL.md` (Task 4) and the `/vault-checkup` command (Task 6) reference by name.

- [ ] **Step 1: Create the file with this exact content**

````markdown
# Maintenance workflows

How the vault-keeper actually does the work. Each workflow is MCP-aware: it names
the Obsidian tools to use and how to stay link-safe. Always run the survey
(workflow 1) first, and follow the vault's own conventions over these defaults.

## Access model — MCP first, filesystem fallback

- **Preferred:** the Obsidian MCP (`mcp__obsidian__*`, Local REST API plugin).
- **Fallback:** if the MCP is not connected, operate on the vault folder directly
  with Read/Edit/Write/Glob/Grep.
- **The hard truth about moves:** the MCP has **no move/rename tool**, and the
  REST API does **not** auto-update `[[links]]`. Renaming or moving a note by any
  route outside the Obsidian app breaks every link to it. So a "move" is always:
  1. Create the note at the new path (`obsidian_append_content` to the new path,
     or Write).
  2. Find every note that links to the old name and repair those links
     (workflow 4).
  3. Delete the old note (`obsidian_delete_file` with `confirm: true`), only after
     reading it and confirming.
  When many moves are needed, prefer doing them inside the Obsidian app (which
  auto-updates links) and tell the user so.

## 1. Vault health snapshot

Goal: an accurate picture before changing anything.

- Enumerate notes: `obsidian_complex_search` with `{"glob": ["*.md", {"var": "path"}]}`
  for a full list; `obsidian_list_files_in_vault` (root) and
  `obsidian_list_files_in_dir` for folder-by-folder structure.
- Read in bulk with `obsidian_batch_get_file_contents` to inspect frontmatter and
  link density.
- Tally: total notes, notes per PARA bucket, `_inbox` backlog, notes missing
  frontmatter, orphans (workflow 5), broken links (workflow 4), stale MOCs
  (workflow 3).
- Output a short report with counts. Change nothing in this workflow.

## 2. Capture & filing (process `_inbox` into PARA)

- List `_inbox` (`obsidian_list_files_in_dir` on `_inbox`).
- For each note, read it and decide the PARA bucket by **actionability**:
  `1 Projects` (has an end), `2 Areas` (ongoing standard), `3 Resources`
  (reference), `4 Archive` (inactive). When unsure, ask.
- Apply the matching template from `_templates` if the note type has one.
- File it (a move — follow the Access model above), then add it to the relevant
  MOC (workflow 3) or rely on the MOC's Dataview query to pick it up.

## 3. MOC build & refresh

- Ensure each PARA bucket has an index note. Create a missing one with a Dataview
  auto-list (see `vault-organization.md` → "MOCs with Dataview"):
  a `tags` frontmatter of `[moc, para/<bucket>]`, a one-line description, and a
  ```dataview LIST FROM "<bucket>" WHERE file.name != this.file.name SORT
  file.mtime DESC``` block.
- Refresh a stale MOC by re-checking its `FROM` path still matches the folder and
  the `WHERE file.name != this.file.name` self-exclusion is present.
- A folder with no note in it does not exist in Obsidian — create the folder by
  writing its MOC note into it.

## 4. Link hygiene (broken links & unlinked mentions)

- **Find broken links:** collect all `[[targets]]` (search body text with
  `obsidian_simple_search` or `obsidian_complex_search` `regexp` on
  `\[\[([^\]]+)\]\]`), then check each target resolves to an existing note name or
  alias. Unresolved targets are broken.
- **Repair:** if the target was renamed/moved, update the link text to the new
  name (`obsidian_patch_content` with `operation: replace` on the containing
  block, or Edit). If the target is genuinely gone, ask whether to recreate it or
  remove the link.
- **Unlinked mentions:** where a note's title appears as plain text in other
  notes, offer to convert to `[[links]]` — but don't over-link (avoid linking the
  same term repeatedly on one page; see the style guide).

## 5. Orphan detection

- An orphan has no inbound links (no backlinks) and often no outbound links.
- Find candidates: for each note, check whether any other note links to its name
  or aliases (reuse the link index from workflow 4).
- For each orphan, propose one of: link it from a relevant MOC or note, or move it
  to `4 Archive` if it's inactive. Never delete an orphan without confirmation —
  low connectivity is not the same as low value.

## 6. Frontmatter normalization

- Define/confirm the property schema from the vault (or default to: `tags` (list),
  `aliases` (list), `created` (date), `status` (text)). Follow the vault's
  existing keys if it has them.
- Find drift: notes missing frontmatter entirely, or with inconsistent key
  names/types. `obsidian_patch_content` with `target_type: frontmatter` adds or
  updates a field without touching the body.
- Normalize conservatively: add missing standard keys; don't invent values —
  ask or leave blank. Keep `#` out of YAML tag values.

## 7. Dedup & rename

- **Detect near-duplicates:** notes with very similar names or near-identical
  content (compare titles and, for suspects, bodies via
  `obsidian_batch_get_file_contents`).
- **Merge safely:** pick the canonical note, append the unique content from the
  duplicate into it (`obsidian_append_content`), add the duplicate's name as an
  `alias` so old links still resolve, repair inbound links (workflow 4), then
  delete the duplicate (read + confirm first).
- **Rename:** follow the Access model — create at new name, fix backlinks, delete
  old — or do it in-app. Keep naming consistent: `Title Case` for concept notes,
  `YYYY-MM-DD` for dailies; avoid `# | ^ [ ]` in names.

## 8. Archive lifecycle

- **Project done/dropped:** move it from `1 Projects` to `4 Archive` (a move —
  Access model applies).
- **Employer lifecycle:** a current job is an Area; when it ends, move the whole
  employer folder to the archive location the vault uses (e.g. `_Past Employers`).
  This is one bulk move — prefer doing it in-app so links update automatically.
- Nothing is deleted in archiving; it's parked for reference.

## 9. Link-safe editing checklist (run before any destructive change)

- Read the note before deleting or overwriting it; confirm with the user for any
  delete, merge, or bulk move.
- After a move/rename, verify no `[[links]]` to the old name remain (re-run
  workflow 4 scoped to the old name).
- Prefer `obsidian_patch_content` (targeted, heading/block/frontmatter-scoped)
  over rewriting a whole note, to avoid clobbering content.
- Keep the vault on one sync method; don't introduce a plugin dependency for core
  content.
````

- [ ] **Step 2: Verify the file exists and covers all nine workflows**

Run: `grep -cE '^## [1-9]\.' plugins/obsidian-vault-keeper/skills/obsidian-vault/references/maintenance-workflows.md`
Expected: `9`

- [ ] **Step 3: Commit**

```bash
git add plugins/obsidian-vault-keeper/skills/obsidian-vault/references/maintenance-workflows.md
git commit -m "$(cat <<'EOF'
feat(obsidian-vault-keeper): add MCP-aware maintenance-workflows reference

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

### Task 4: Write the `obsidian-vault` SKILL.md

**Files:**
- Create: `plugins/obsidian-vault-keeper/skills/obsidian-vault/SKILL.md`

**Interfaces:**
- Consumes: the four references in `references/`.
- Produces: a skill named `obsidian-vault` that the `vault-keeper` agent (Task 5) names, and that the `/vault-checkup` command (Task 6) relies on.

- [ ] **Step 1: Create the file with this exact content**

```markdown
---
name: obsidian-vault
description: Maintain and organize an Obsidian vault to best practices, and write Obsidian notes correctly. Use when working in an Obsidian vault — capturing/filing notes into PARA, building or refreshing MOCs, fixing broken links, finding orphans, normalizing frontmatter, deduping/renaming, or writing/editing notes with wikilinks, callouts, and properties. Covers Obsidian-flavored Markdown, the official Obsidian style guide, PARA organization, and MCP-aware maintenance workflows. Primary skill of the vault-keeper agent.
---

# Obsidian Vault

The knowledge base for maintaining and writing in an Obsidian vault. **Survey the
vault first** — if it already defines conventions (structure, naming, templates, a
home/README note, a `.obsidian` config), follow those; the rules below are the
defaults otherwise.

Obsidian notes are plain Markdown files in a folder. Keep them future-proof, link
liberally, and follow the official style guide when writing. Three things make
Obsidian different from plain Markdown editing: its Markdown dialect, its vault
organization, and its link-update behavior — and one thing makes *maintenance*
different: the tools you use can silently break links.

## Access model (for the steward)

Prefer the Obsidian MCP (`mcp__obsidian__*`) when connected; fall back to
filesystem Read/Edit/Write on the vault path when it isn't. The MCP has **no
move/rename tool** and does **not** auto-update `[[links]]` — treat every move as
create-new → fix backlinks → delete-old. Full detail in
`references/maintenance-workflows.md`.

## Writing notes — follow the Obsidian style guide

Full guide in `references/style-guide.md`. The high-value rules:

- **Global English**, active voice, simple words, American spelling.
- **Sentence case** headings; **imperative mood** for guide names and steps
  ("Set up", not "Setting up").
- **Preferred terms:** heading (not header), folder (not directory), select (not
  click/tap), note name (not note title), active note (not current note), sync
  (not synchronise), keyboard shortcut (not hotkey).
- **Bold** for UI/button labels; `→` for navigation; keyboard shortcuts as
  `Ctrl+Z` (no spaces).
- **Callouts** for tips/info/warnings; **lists** for discrete items, **prose** for
  how/why.

## Obsidian-flavored Markdown (not plain Markdown)

Full syntax in `references/obsidian-syntax.md`. The essentials:

- **Internal links:** `[[Note name]]`, `[[Note name#Heading|display text]]`, block
  refs `[[Note name#^blockid]]`.
- **Embeds:** `![[Note name]]`, `![[image.png]]`, `![[Note name#Heading]]`.
- **Callouts:** `> [!tip]`, `> [!warning]`, `> [!info]`; `-` starts folded, `+`
  starts open.
- **Properties (YAML frontmatter):** typed metadata (`tags`, `aliases`, dates)
  that Dataview and Bases read.
- **Tags** `#topic` for status/type; **links** for relationships. One term per
  concept.

## Organizing a vault

Full method in `references/vault-organization.md`. The defaults:

- **Links over deep folders.** Keep structure flat-ish; use **MOC index notes** as
  hubs.
- **PARA — organize by actionability, not topic:** `1 Projects` (active, has an
  end) · `2 Areas` (ongoing standard) · `3 Resources` (reference) · `4 Archive`
  (inactive). A current job is an Area; a past job is Archive.
- **Utility folders:** `_inbox`, `_templates`, `_attachments`, `Daily Notes`.
- **Atomic notes**, consistent names (`Title Case` concepts, `YYYY-MM-DD`
  dailies), avoid `# | ^ [ ]`.
- **MOCs auto-fill with Dataview** (`LIST FROM "folder"`).

## Maintaining a vault

Full how-to in `references/maintenance-workflows.md`. The workflows:

1. Vault health snapshot · 2. Capture & filing · 3. MOC build & refresh ·
4. Link hygiene · 5. Orphan detection · 6. Frontmatter normalization ·
7. Dedup & rename · 8. Archive lifecycle · 9. Link-safe editing checklist.

## Safety — don't break links or lose content

- Moving/renaming **inside Obsidian** auto-updates `[[links]]`; moving via the
  filesystem or REST API does **not** — those links break. Prefer in-app moves;
  otherwise fix references afterward.
- Before deleting or overwriting a note, **read it first**; never delete user
  content without confirming.
- Empty folders aren't represented — create a folder by writing a note into it.
- Keep the vault on **one** sync method.

## References

- **`references/style-guide.md`** — the full official Obsidian style guide.
- **`references/obsidian-syntax.md`** — the Obsidian Markdown dialect + Dataview
  and template syntax.
- **`references/vault-organization.md`** — PARA in depth, the employer lifecycle,
  utility folders, MOCs with Dataview, naming, sync, auditing an existing vault.
- **`references/maintenance-workflows.md`** — the nine MCP-aware maintenance
  workflows.
```

- [ ] **Step 2: Verify frontmatter and reference links resolve**

Run: `head -3 plugins/obsidian-vault-keeper/skills/obsidian-vault/SKILL.md && echo "---" && for f in style-guide obsidian-syntax vault-organization maintenance-workflows; do test -f plugins/obsidian-vault-keeper/skills/obsidian-vault/references/$f.md && echo "$f OK" || echo "$f MISSING"; done`
Expected: frontmatter opens with `---` then `name: obsidian-vault`; all four references print `OK`.

- [ ] **Step 3: Commit**

```bash
git add plugins/obsidian-vault-keeper/skills/obsidian-vault/SKILL.md
git commit -m "$(cat <<'EOF'
feat(obsidian-vault-keeper): add obsidian-vault SKILL.md

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

### Task 5: Write the `vault-keeper` agent

**Files:**
- Create: `plugins/obsidian-vault-keeper/agents/vault-keeper.md`

**Interfaces:**
- Consumes: the `obsidian-vault` skill (by name).
- Produces: an agent named `vault-keeper` (referenced by the `/vault-checkup` command and by users).

- [ ] **Step 1: Create the file with this exact content**

```markdown
---
name: vault-keeper
description: >-
  Use to maintain and organize an Obsidian vault to best practices — capture and
  file notes into PARA, build and refresh MOC index notes, fix broken links and
  find orphans, normalize frontmatter, safely dedupe/rename, and run the
  employer/archive lifecycle. A senior Obsidian librarian you summon whenever you
  work in your vault; it does the work via the Obsidian MCP (filesystem fallback),
  not just advise.

  <example>
  Context: The vault's inbox has piled up with unfiled quick-capture notes.
  user: "Process my Obsidian _inbox and file everything into PARA."
  assistant: "I'll use the vault-keeper agent to triage _inbox and file each note into the right PARA bucket."
  <commentary>Active vault maintenance in an Obsidian vault — the vault-keeper's core role.</commentary>
  </example>

  <example>
  Context: Links have rotted after files were moved outside the app.
  user: "Some [[links]] in my vault are broken — can you find and fix them?"
  assistant: "I'll bring in the vault-keeper agent to scan for broken links and repair the references."
  <commentary>Link hygiene and vault health — vault-keeper territory.</commentary>
  </example>
model: opus
color: purple
---

You are a Senior Obsidian Vault Steward — a librarian who keeps a vault healthy,
well-linked, and organized to best practices. You do the work; you don't just
advise.

## Skill
Use the `obsidian-vault` skill for every task — it holds the Obsidian Markdown
dialect, the official style guide, PARA organization, and the MCP-aware
maintenance workflows. Follow the vault's own conventions over the defaults when
it has them.

## Access
Prefer the Obsidian MCP (`mcp__obsidian__*`) when it's connected; fall back to
filesystem Read/Edit/Write on the vault folder when it isn't. Remember the MCP has
**no move/rename tool** and does **not** auto-update `[[links]]` — every move is
create-new → fix backlinks → delete-old (or done in-app).

## Process
1. **Survey first.** Read the vault's structure, `.obsidian` config, existing
   templates, MOCs, and naming. Establish which conventions already apply.
2. **Apply conventions** from the `obsidian-vault` skill (or the vault's own).
3. **Perform the operation** using the matching maintenance workflow, link-safely.
   Propose destructive steps (delete, merge, bulk move) with counts and confirm
   before running them.
4. **Verify** links and frontmatter are intact afterward; re-scan the old name
   after any move.
5. **Report** what changed — files touched, links repaired, notes filed/archived —
   and anything left for the user to decide.

## Boundaries
- Read a note before deleting or overwriting it; never delete user content without
  confirmation.
- Prefer in-app moves for bulk reorganizations (links auto-update); when moving
  outside the app, repair references afterward.
- Don't introduce a plugin dependency for core content; keep one sync method.
- Maintain and organize — don't invent note content or values; ask or leave blank
  when unsure.

## Output
The completed maintenance work in the vault, plus a concise report: what changed,
which links/notes were affected, assumptions made, and any items awaiting the
user's decision.
```

- [ ] **Step 2: Verify frontmatter fields**

Run: `awk '/^---$/{c++} c==1 && /^(name|model|color):/ {print} c==2{exit}' plugins/obsidian-vault-keeper/agents/vault-keeper.md`
Expected: prints `name: vault-keeper`, `model: opus`, `color: purple`.

- [ ] **Step 3: Commit**

```bash
git add plugins/obsidian-vault-keeper/agents/vault-keeper.md
git commit -m "$(cat <<'EOF'
feat(obsidian-vault-keeper): add vault-keeper agent

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

### Task 6: Write the `/vault-checkup` command

**Files:**
- Create: `plugins/obsidian-vault-keeper/commands/vault-checkup.md`

**Interfaces:**
- Consumes: the `vault-keeper` agent and the `obsidian-vault` skill's maintenance workflows (by name).
- Produces: a `/vault-checkup` slash command.

- [ ] **Step 1: Create the file with this exact content**

```markdown
---
description: Run a read-only Obsidian vault health sweep — scan for orphans, broken links, frontmatter drift, misfiled/duplicate notes, and stale MOCs — then report findings and offer to fix.
argument-hint: "[folder path | empty = whole vault]"
---

# /vault-checkup

Run a vault health sweep with the `vault-keeper` agent and the `obsidian-vault`
skill's maintenance workflows.

## Scope
`$ARGUMENTS` selects what to check:
- empty → the whole vault.
- a folder path → limit the sweep to that folder.

If the vault can't be reached (no Obsidian MCP connected and no vault path known),
ask the user for the vault location.

## Sweep (read-only first)
1. **Survey.** Dispatch the `vault-keeper` agent to run workflow 1 (vault health
   snapshot) over the scope — inventory notes and structure. Change nothing yet.
2. **Scan** for, and count, each finding category:
   - Orphans (no inbound/outbound links) — workflow 5.
   - Broken `[[links]]` and unresolved targets — workflow 4.
   - Frontmatter drift (missing/inconsistent properties) — workflow 6.
   - Misfiled or unprocessed notes (`_inbox` backlog, wrong PARA bucket) —
     workflow 2.
   - Duplicate/near-duplicate notes — workflow 7.
   - Stale or missing MOCs — workflow 3.
3. **Report** findings grouped by category with counts and example notes.

## Fix (only after reporting)
4. Offer to fix. Apply **non-destructive** fixes directly (add missing MOCs, add
   missing standard frontmatter keys, repair clearly-renamed links). For
   **destructive** fixes (delete, merge duplicates, bulk move/archive), list them
   and confirm before running — one move at a time, link-safely (create-new →
   fix backlinks → delete-old), or advise doing bulk moves in-app.
5. **Verify** links and frontmatter are intact and report what changed.

## Rules
- Read before delete/overwrite; never delete user content without confirmation.
- Don't push, sync-config, or install plugins. Maintenance only.
- Final output: the findings report, what was fixed, and what's left for the user.
```

- [ ] **Step 2: Verify frontmatter**

Run: `head -4 plugins/obsidian-vault-keeper/commands/vault-checkup.md`
Expected: opens with `---`, a `description:` line, an `argument-hint:` line, then `---`.

- [ ] **Step 3: Commit**

```bash
git add plugins/obsidian-vault-keeper/commands/vault-checkup.md
git commit -m "$(cat <<'EOF'
feat(obsidian-vault-keeper): add /vault-checkup command

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

### Task 7: Slim `claude-dream-team`'s `obsidian-conventions` to an inline primer

The three references were removed in Task 2. Now rewrite the skill body so it's self-sufficient for the technical-writer to *write* vault docs, without any `references/` files.

**Files:**
- Modify (overwrite): `plugins/claude-dream-team/skills/obsidian-conventions/SKILL.md`

**Interfaces:**
- Consumes: nothing external (must be self-contained — no `references/` links).
- Produces: a slimmed `obsidian-conventions` skill still usable by the technical-writer.

- [ ] **Step 1: Overwrite `SKILL.md` with this exact content**

```markdown
---
name: obsidian-conventions
description: Write and edit notes correctly in an Obsidian vault — Obsidian-flavored Markdown (wikilinks, embeds, callouts, properties), the official Obsidian writing style, and link-safe editing. Use when the technical-writer's documentation lives in or targets an Obsidian vault. A compact primer; for deep vault organization and maintenance, the obsidian-vault-keeper plugin is the authoritative home.
---

# Obsidian Conventions (primer)

Run `project-adaptation` first — if the vault defines its own conventions
(structure, naming, templates, a README/home note), follow those. This is a
compact primer for writing docs that live in an Obsidian vault. For deep vault
organization, MOCs, and maintenance, use the **obsidian-vault-keeper** plugin.

## Writing style (official Obsidian style guide)

- **Global English**, active voice, simple words, American spelling ("organize").
- **Sentence case** headings; **imperative mood** for guide names and steps
  ("Set up", not "Setting up").
- **Preferred terms:** heading (not header), folder (not directory), select (not
  click/tap), note name (not note title), active note (not current note), sync
  (not synchronise), keyboard shortcut (not hotkey), maximum/minimum (not
  max/min).
- **Bold** for UI and button labels; `→` for navigation (**Settings** →
  Community plugins); keyboard shortcuts as `Ctrl+Z` (no spaces), naming the OS
  only when they differ.
- **Callouts** for tips/info/warnings; **lists** for discrete items, **prose** for
  how/why. Give images descriptive alt text and store them in an attachments
  folder.

## Obsidian-flavored Markdown (not plain Markdown)

- **Internal links:** `[[Note name]]`, `[[Note name#Heading|display text]]`, block
  refs `[[Note name#^blockid]]`. Prefer wikilinks for internal navigation.
- **Embeds / transclusion:** `![[Note name]]`, `![[image.png]]`,
  `![[Note name#Heading]]`; size an image `![[image.png|400]]`.
- **Callouts:** `> [!tip]`, `> [!info]`, `> [!warning]`; add `-` to start folded,
  `+` to start open.
- **Properties (YAML frontmatter):** typed metadata (`tags`, `aliases`, dates)
  between `---` fences that Dataview, Bases, and search can read. In YAML, tags
  omit the `#`.
- **Tags** `#topic` for status/type; **links** for relationships between concepts.
  One term per concept; don't over-link the same term on one page.
- Comments `%% hidden %%` don't render in Reading view.

## Link-safe editing

- Moving or renaming a note **inside Obsidian** auto-updates every `[[link]]` to
  it. Moving/renaming via the filesystem or a raw REST API does **not** — those
  links break. Prefer in-app moves; otherwise fix references afterward.
- Before deleting or overwriting a note, **read it first**; never delete user
  content without confirming.
- Empty folders aren't represented in a vault — create a folder by writing a note
  into it.
```

- [ ] **Step 2: Verify the skill is self-contained (no dangling `references/` links, directory gone)**

Run: `grep -n "references/" plugins/claude-dream-team/skills/obsidian-conventions/SKILL.md; echo "grep-exit=$?"; ls plugins/claude-dream-team/skills/obsidian-conventions/`
Expected: no `references/` matches printed and `grep-exit=1`; the directory listing shows only `SKILL.md`.

- [ ] **Step 3: Commit**

```bash
git add plugins/claude-dream-team/skills/obsidian-conventions/SKILL.md
git commit -m "$(cat <<'EOF'
refactor(claude-dream-team): slim obsidian-conventions to a writer's primer

Deep organization/maintenance knowledge now lives in obsidian-vault-keeper;
keep only the syntax, style, and link-safety essentials the technical-writer
needs, inline (references removed).

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

### Task 8: Update cross-references, manifests, and the marketplace

Reconcile versions, update the technical-writer's reference line, update `claude-dream-team`'s description, and register the new plugin.

**Files:**
- Modify: `plugins/claude-dream-team/agents/technical-writer.md` (the `obsidian-conventions` mentions)
- Modify: `plugins/claude-dream-team/.claude-plugin/plugin.json` (description + version)
- Modify: `.claude-plugin/marketplace.json` (register new plugin + update dream-team entry)

**Interfaces:**
- Consumes: the actual committed version values (read them, don't assume).
- Produces: a marketplace listing three plugins with matching versions/descriptions.

- [ ] **Step 1: Read current versions (reconciliation)**

Run: `python3 -c "import json; print('plugin.json', json.load(open('plugins/claude-dream-team/.claude-plugin/plugin.json'))['version'])"; python3 -c "import json; [print('marketplace', p['name'], p['version']) for p in json.load(open('.claude-plugin/marketplace.json'))['plugins']]"`
Expected: prints the real current versions (e.g. `plugin.json 0.3.0` and the marketplace entries). Use whatever prints as the base; the minor-bumped target below is `base + 0.1.0` (e.g. `0.3.0 → 0.4.0`). If the two sources disagree, align them to the higher committed value first, then bump.

- [ ] **Step 2: Update the two `obsidian-conventions` mentions in `technical-writer.md`**

In `plugins/claude-dream-team/agents/technical-writer.md`, replace the parenthetical in the **Skills** section (line ~29):

Old:
```
When the docs live in or target an **Obsidian vault**, also use `obsidian-conventions` (Obsidian-flavored Markdown, vault organization, and the official Obsidian style guide).
```
New:
```
When the docs live in or target an **Obsidian vault**, also use `obsidian-conventions` (Obsidian-flavored Markdown, the official Obsidian style guide, and link-safe editing).
```

And in the **Process** step 1 (line ~32), replace:

Old:
```
1. Run `project-adaptation`, then `documentation` (and `obsidian-conventions` if the target is an Obsidian vault).
```
New:
```
1. Run `project-adaptation`, then `documentation` (and `obsidian-conventions` if the target is an Obsidian vault; for deep vault organization or maintenance, defer to the obsidian-vault-keeper plugin).
```

- [ ] **Step 3: Update `claude-dream-team` plugin.json — description + version**

In `plugins/claude-dream-team/.claude-plugin/plugin.json`, replace the `obsidian-conventions` clause in `description`:

Old fragment:
```
and an obsidian-conventions skill (official Obsidian style guide + PARA vault organization for docs in an Obsidian vault)
```
New fragment:
```
and an obsidian-conventions primer (Obsidian-flavored Markdown, the official Obsidian style guide, and link-safe editing for docs in an Obsidian vault; deep vault organization and maintenance now live in the obsidian-vault-keeper plugin)
```

Then set `"version"` to the bumped value from Step 1 (e.g. `"0.4.0"`).

- [ ] **Step 4: Update `.claude-plugin/marketplace.json`**

a) Update the `claude-dream-team` entry: set its `version` to the same bumped value from Step 3, and replace the same `obsidian-conventions skill (…)` fragment in its `description` with the same new fragment from Step 3.

b) Append a new plugin object to the `plugins` array:

```json
{
  "name": "obsidian-vault-keeper",
  "source": "./plugins/obsidian-vault-keeper",
  "version": "0.1.0",
  "description": "An active Obsidian vault steward: the vault-keeper agent maintains your vault to best practices through the Obsidian MCP (filesystem fallback) — captures and files notes into PARA, builds and refreshes MOC index notes, fixes broken [[links]] and finds orphans, normalizes frontmatter, safely dedupes/renames, and runs the archive lifecycle. Includes the obsidian-vault skill (Obsidian-flavored Markdown, the official Obsidian style guide, PARA organization, MCP-aware maintenance workflows) and a /vault-checkup command that runs a read-only health sweep and offers to fix. The marketplace's single source of truth for Obsidian knowledge."
}
```

Ensure the JSON stays valid (comma after the previous array element, no trailing comma).

- [ ] **Step 5: Verify both manifests are valid JSON and versions match**

Run: `python3 -c "import json; json.load(open('.claude-plugin/marketplace.json')); json.load(open('plugins/claude-dream-team/.claude-plugin/plugin.json')); json.load(open('plugins/obsidian-vault-keeper/.claude-plugin/plugin.json')); print('all valid')"` then `python3 -c "import json; m={p['name']:p['version'] for p in json.load(open('.claude-plugin/marketplace.json'))['plugins']}; pj=json.load(open('plugins/claude-dream-team/.claude-plugin/plugin.json'))['version']; print('names:', list(m)); assert m['claude-dream-team']==pj, (m['claude-dream-team'], pj); assert 'obsidian-vault-keeper' in m; print('versions aligned')"`
Expected: `all valid`, then `names:` lists all three plugins and `versions aligned`.

- [ ] **Step 6: Commit**

```bash
git add .claude-plugin/marketplace.json plugins/claude-dream-team/.claude-plugin/plugin.json plugins/claude-dream-team/agents/technical-writer.md
git commit -m "$(cat <<'EOF'
feat: register obsidian-vault-keeper and update dream-team references

Register the new plugin in the marketplace, point the technical-writer at the
slimmed obsidian-conventions primer, and reconcile claude-dream-team's version
and description.

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

### Task 9: Verification pass (validators, reviewers, and fixes)

**Files:**
- No new files. May modify any file above to fix findings.

**Interfaces:**
- Consumes: all prior tasks' output.
- Produces: a validated, review-clean plugin.

- [ ] **Step 1: Structural sanity across the new plugin**

Run: `find plugins/obsidian-vault-keeper -type f | sort`
Expected exactly:
```
plugins/obsidian-vault-keeper/.claude-plugin/plugin.json
plugins/obsidian-vault-keeper/README.md
plugins/obsidian-vault-keeper/agents/vault-keeper.md
plugins/obsidian-vault-keeper/commands/vault-checkup.md
plugins/obsidian-vault-keeper/skills/obsidian-vault/SKILL.md
plugins/obsidian-vault-keeper/skills/obsidian-vault/references/maintenance-workflows.md
plugins/obsidian-vault-keeper/skills/obsidian-vault/references/obsidian-syntax.md
plugins/obsidian-vault-keeper/skills/obsidian-vault/references/style-guide.md
plugins/obsidian-vault-keeper/skills/obsidian-vault/references/vault-organization.md
```

- [ ] **Step 2: No dangling references left behind in dream-team**

Run: `grep -rn "references/" plugins/claude-dream-team/skills/obsidian-conventions/ ; echo "exit=$?"`
Expected: nothing printed, `exit=1`.

- [ ] **Step 3: Run the plugin-validator agent on the new plugin**

Dispatch the `plugin-dev:plugin-validator` agent with target `plugins/obsidian-vault-keeper`.
Expected: reports the plugin structure valid (manifest, agent, skill, command discovered). Fix any structural findings and re-run.

- [ ] **Step 4: Run the skill-reviewer agent on both skills**

Dispatch the `plugin-dev:skill-reviewer` agent on `plugins/obsidian-vault-keeper/skills/obsidian-vault/SKILL.md` and on `plugins/claude-dream-team/skills/obsidian-conventions/SKILL.md`.
Expected: descriptions trigger well and content follows best practices. Apply reasonable suggested improvements (especially to the `description` fields) and commit them.

- [ ] **Step 5: Commit any fixes**

```bash
git add -A
git commit -m "$(cat <<'EOF'
fix(obsidian-vault-keeper): apply validator and skill-reviewer findings

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>
EOF
)"
```
(If there were no findings and nothing to change, skip this commit.)

- [ ] **Step 6: Final review of the whole change**

Run: `git log --oneline -9 && echo "---" && git status`
Expected: the task commits present, working tree clean. Report the summary to the user; do not push, tag, or release.

---

## Notes for the implementer

- This is a content plan: "tests" are the JSON-validity, structure, and grep
  checks in each task, plus the validator/reviewer agents in Task 9. There are no
  unit tests to write.
- Keep prose in the voice of the existing `claude-dream-team` files (terse,
  em-dash bullets, sentence-case headings).
- If any exact "old fragment" string in Task 8 doesn't match the file verbatim,
  read the file and match the current text — the intent (swap the obsidian
  clause, bump the version) is what matters.
