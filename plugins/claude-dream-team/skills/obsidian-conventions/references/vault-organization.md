# Vault organization

How to structure an Obsidian vault. Obsidian is deliberately unopinionated, so these are the conventions most experienced users converge on. Always check the existing vault first (`project-adaptation`) and follow its conventions if it already has them.

## Principles

- **Plain-text, future-proof.** Standard Markdown first; avoid plugin-only syntax for content you'd hate to lose.
- **Links over folders.** Obsidian's strength is `[[wikilinks]]` and backlinks. Deep folder trees fight that. Keep structure flat-ish and lean on links, tags, and search.
- **Atomic notes.** One idea per note — small notes link and resurface better than large documents.
- **MOCs (Maps of Content).** Use index/hub notes that link out to related notes instead of nesting folders. A `Home` note linking to topic MOCs beats clicking through folders.

## PARA — the default scheme

PARA organizes by **actionability, not topic**. Four top-level buckets, and notes flow between them as their actionability changes:

- **`1 Projects`** — active efforts with a specific outcome and an end (a deadline). Finished/dropped → move to Archive.
- **`2 Areas`** — ongoing responsibilities with a standard to maintain and no end date (Health, Finances; at work: on-call, a system you own).
- **`3 Resources`** — topics of interest and reference material, not tied to one outcome.
- **`4 Archive`** — inactive items from the other three. Nothing is deleted; it's parked for reference.

Number the folders so they sort in PARA order. Give each bucket a MOC index note (see below).

> Alternative schemes: **Zettelkasten** (atomic + dense linking, good for research) and **Johnny.Decimal** (numbered taxonomy). PARA is the safe default for action- and project-oriented work.

### The employer / job lifecycle (why PARA scales)

A common mistake is a permanent topical tree — e.g. a folder per employer forever. PARA avoids that:

- A **current job is an Area** (an ongoing responsibility).
- A **past job is Archive** (inactive — kept for reference, not deleted).
- A **future job doesn't exist yet** — create nothing for it now; it becomes a new Area when you join.

So the lifecycle is `future → active Area → Archive`, and changing jobs is **one move**, not a reorganization. A clean pattern that keeps the move trivial:

```
Work/
  <Current Employer>/        ← active; PARA lives inside it
    1 Projects/
    2 Areas/
    3 Resources/
    4 Archive/
  _Past Employers/           ← move the whole employer folder here when you leave
```

## One vault vs. separate vaults

- **One vault, folders** — simplest; lets you cross-link everything; one backup/sync. Downside: personal and work share the same sync/backup location.
- **Separate vaults** — strongest isolation (separate sync, separate backup, no accidental cross-linking). Downside: switch vaults to switch context; no links across them.

Recommend **separate vaults when work data is confidential** or governed by data-handling rules; otherwise one vault with a top-level `Personal/` vs `Work/` split is fine.

## Utility folders

Keep a few at the root, prefixed so they sort to the top:

- **`_inbox`** — quick capture; dump notes here, then process into PARA regularly.
- **`_templates`** — note templates (project, daily note, meeting).
- **`_attachments`** — images, PDFs, pasted files. Set **Settings → Files and links → Default location for new attachments → `_attachments`**.
- **`Daily Notes`** — dated notes (`YYYY-MM-DD`). Enable the core **Daily notes** plugin; set its new-file location and template.

## MOCs with Dataview

Give each PARA bucket an index note that documents the bucket and auto-lists its notes:

````markdown
---
tags: [moc, para/projects]
---

# 📌 Projects

> Active efforts with a specific outcome and an end. Finished → move to `4 Archive`.

```dataview
LIST
FROM "1 Projects"
WHERE file.name != this.file.name
SORT file.mtime DESC
```
````

The `WHERE file.name != this.file.name` clause keeps the MOC from listing itself. As notes are added to the folder, the index fills in automatically.

## Naming conventions

- Pick one convention per note type and keep it: `Title Case` for concept notes, `YYYY-MM-DD` for dailies.
- Avoid characters that break links: `# | ^ [ ]`.
- Use `aliases` in frontmatter for acronyms/alternate names so links and search still resolve.

## Tags vs. links

- **Tags** for status/type: `#project`, `#draft`, `#area/health`.
- **Links** for relationships between concepts.
- Don't duplicate the folder tree as tags.

## Sync, backup, and git

- Use **one** sync method (Obsidian Sync, iCloud, Dropbox, or git) — mixing causes conflicts.
- A vault is just a folder, so any backup tool works. For git, gitignore `.obsidian/workspace*` and cache files to avoid noisy churn; the rest of `.obsidian/` can be versioned to share config.

## Editing safely

- Moving/renaming a note **inside Obsidian** updates every `[[link]]` to it. Moving via the filesystem or a raw REST API does **not** — links break. Prefer in-app moves, or repair references after a bulk external move.
- Empty folders aren't represented — create a folder by writing a note (e.g. its MOC) into it.
- Before deleting or overwriting a note, read it; never delete user content without confirming. Default Obsidian `Welcome.md` notes are safe placeholders to remove.

## Common pitfalls

- **Premature structure** — building deep folders before having notes. Start flat; let structure emerge.
- **Collector's fallacy** — saving everything, processing nothing. Capture *and* link/process.
- **Plugin dependency for core content** — notes unreadable without a plugin (e.g. all content inside Dataview). Keep the content plain; let plugins augment.
- **Plugin sprawl** — the top way to make a vault fragile and slow. Add a plugin only when you feel the pain it solves.
