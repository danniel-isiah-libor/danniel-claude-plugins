---
name: obsidian-conventions
description: Apply Obsidian conventions and the official Obsidian style guide when writing notes and organizing vaults — Obsidian-flavored Markdown (wikilinks, embeds, callouts, properties), PARA vault organization, note naming, and link-safe edits. Use when writing or editing notes in an Obsidian vault, organizing or restructuring a vault, or working with `.md` notes, wikilinks, callouts, tags, or frontmatter properties. Used by the technical-writer when documentation lives in an Obsidian vault.
---

# Obsidian Conventions

Run `project-adaptation` first — if the vault already defines conventions (an existing structure, naming, templates, a README/home note, a `.obsidian` config), follow those; the rules below are the defaults otherwise.

Obsidian notes are plain Markdown files in a folder. Keep them future-proof, link liberally, and follow the official Obsidian style guide when writing docs. Three things make Obsidian work different from plain Markdown editing: its Markdown dialect, its vault organization, and its link-update behavior.

## Writing notes — follow the Obsidian style guide

Full guide in `references/style-guide.md`. The high-value rules:

- **Global English**, active voice, simple words, American spelling.
- **Sentence case** headings; **imperative mood** for guide names and steps ("Set up", not "Setting up").
- **Preferred terms:** heading (not header), folder (not directory), select (not click/tap), note name (not note title), active note (not current note), sync (not synchronise), keyboard shortcut (not hotkey), maximum/minimum (not max/min), upper-left (not top-left).
- **Bold** for UI and button labels; `→` for navigation (**Settings** → Community plugins); keyboard shortcuts as `Ctrl+Z` (no spaces), and specify the OS only when they differ ("`Ctrl+Z` (Windows) or `Command+Z` (macOS)").
- Use **callouts** for tips/info/warnings; **lists** for discrete items, **prose** for how/why and workflows.
- Store images in an attachments folder; give descriptive alt text; optimize large images.

## Obsidian-flavored Markdown (not plain Markdown)

Full syntax in `references/obsidian-syntax.md`. The essentials:

- **Internal links:** `[[Note name]]`, `[[Note name#Heading|display text]]`, block refs `[[Note name#^blockid]]`.
- **Embeds / transclusion:** `![[Note name]]`, `![[image.png]]`, `![[Note name#Heading]]`.
- **Callouts:** `> [!tip]`, `> [!warning]`, `> [!info]`; add `-` to start folded, `+` to start open.
- **Properties (YAML frontmatter):** typed metadata (`tags`, `aliases`, `cssclasses`, dates) that Dataview and Bases can read.
- **Tags** `#topic` for status/type; **links** for relationships between concepts. One term per concept.

## Organizing a vault

Full method in `references/vault-organization.md`. The defaults:

- **Links over deep folders.** Keep structure flat-ish and use **MOC (Map of Content) index notes** as hubs instead of nesting.
- **PARA is the default scheme — organize by *actionability*, not topic:**
  - `1 Projects` (active, has an end) · `2 Areas` (ongoing, maintain a standard) · `3 Resources` (reference) · `4 Archive` (inactive).
  - A **job is an Area**; a **past job is Archive**. Don't build a permanent topical tree (e.g. a folder per employer forever) — notes flow between buckets as they change actionability.
- **Utility folders** at the root: `_inbox` (quick capture), `_templates`, `_attachments`, `Daily Notes`.
- **Atomic notes** (one idea each). Consistent file names — `Title Case` for concepts, `YYYY-MM-DD` for dailies; avoid `# | ^ [ ]` in names (they break links).
- **MOCs auto-fill with Dataview** — give each bucket an index note with a `LIST FROM "folder"` query so it lists its own notes.

## Safety — don't break links or lose content

- Moving or renaming a note **inside Obsidian** auto-updates every `[[link]]` to it. Moving/renaming via the filesystem or a raw REST API does **not** — those links break.
- Prefer in-app moves. When a bulk move must happen outside the app, fix the references afterward (or recreate links).
- Before deleting or overwriting a note, **read it first**; never delete user content without confirming. Empty folders aren't represented in a vault — create a folder by writing a note into it.
- Keep the vault in **one** sync method (Obsidian Sync, iCloud, Dropbox, or git — not several). If using git, gitignore `.obsidian/workspace*` and cache files to avoid churn.

## References

- **`references/style-guide.md`** — the full Obsidian style guide: terminology, headings, formatting, callouts, links, images/icons, properties, translations.
- **`references/obsidian-syntax.md`** — Obsidian Markdown dialect: links, embeds, callouts, properties, tags, comments, plus Dataview and template syntax.
- **`references/vault-organization.md`** — PARA in depth, the employer lifecycle, one-vault-vs-separate-vaults, utility folders, MOCs with Dataview, naming, sync, and common pitfalls.
