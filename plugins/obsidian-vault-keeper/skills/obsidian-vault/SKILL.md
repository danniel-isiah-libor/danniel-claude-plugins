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
