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
