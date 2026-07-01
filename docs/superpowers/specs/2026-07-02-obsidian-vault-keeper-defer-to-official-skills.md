# Design: obsidian-vault-keeper defers authoring syntax to the official `obsidian` plugin

**Date:** 2026-07-02
**Status:** approved
**Scope:** `obsidian-vault-keeper` (0.1.0 → 0.2.0), `claude-dream-team` (0.4.0 → 0.5.0), repo docs

## Problem

The marketplace's Obsidian knowledge was split awkwardly:

- `obsidian-vault-keeper`'s `obsidian-vault` skill re-teaches Obsidian Flavored
  Markdown (`references/obsidian-syntax.md`) — duplicating the authoritative
  **official `obsidian` plugin** by Steph Ango / kepano (Obsidian's creator),
  which the user has installed. That plugin ships five skills:
  `obsidian-markdown`, `obsidian-bases`, `json-canvas`, `obsidian-cli`,
  `defuddle`.
- `claude-dream-team` still carries an `obsidian-conventions` skill and Obsidian
  mentions in its manifest, agent, and README.

Two consequences the user set as constraints:

1. **The official `obsidian` plugin is required** — no need to keep a syntax
   fallback in our plugin.
2. **The official plugin auto-updates** — so we must reference its skills **by
   name/capability only, never by copying their content or pinning a version**.
   Duplicated syntax would silently drift out of sync on every kepano release.

## Decision

Keep the two plugins **isolated** and have `obsidian-vault-keeper` **complement
and defer** to the official plugin rather than absorb or override it.

### Ownership boundary

**Official `obsidian` plugin owns (we defer by name, never duplicate):**

| Need | Skill |
|------|-------|
| Obsidian Flavored Markdown (wikilinks, embeds, callouts, properties syntax, tags, comments, math, Mermaid, footnotes) | `obsidian:obsidian-markdown` |
| `.base` files (database views, filters, formulas) | `obsidian:obsidian-bases` |
| `.canvas` files (visual MOCs, mind maps) | `obsidian:json-canvas` |
| Driving a running vault from the shell | `obsidian:obsidian-cli` |
| Clipping web pages → clean markdown (capture) | `obsidian:defuddle` |

**`obsidian-vault-keeper` keeps owning (kepano covers none of these):**

- The official **Obsidian style guide** (prose style, preferred terms) — `style-guide.md`
- **PARA** organization, MOC method, utility folders, naming, employer/archive
  lifecycle — `vault-organization.md`
- The nine **maintenance workflows** — `maintenance-workflows.md`
- **Dataview + Templates/Templater** — kepano promotes Bases and does not cover
  these; they stay ours (lean), with Bases named as the modern core option for
  new MOCs/dashboards.

Skills don't override each other — Claude loads every skill whose description
matches. The only real risk is a **trigger collision**, so the `obsidian-vault`
skill description is narrowed to stewardship + style, explicitly ceding
authoring syntax to the official skills.

## Changes

**`obsidian-vault-keeper` (0.1.0 → 0.2.0):**
1. `references/obsidian-syntax.md` → gutted and renamed to
   `references/queries-and-templates.md` (Dataview + Templates only; a header
   pointer cedes all syntax to the official skills; Bases named as the modern
   alternative).
2. `SKILL.md` — replace the "Obsidian-flavored Markdown" section with
   "Authoring syntax → use the official `obsidian` skills" (names all five);
   narrow the skill *description* to stewardship + style; add the `obsidian` CLI
   as a third access channel (deferring commands to `obsidian-cli`); reference
   `defuddle` in the capture path; fix the References list.
3. `agents/vault-keeper.md` — add a section naming the official skills and when
   to reach for each; its own skill stays authoritative for organizing/maintaining.
4. `references/style-guide.md` — redirect its one callout-syntax pointer to
   `obsidian:obsidian-markdown`.
5. `README.md` + `plugin.json` + marketplace description — note the required
   official `obsidian` plugin and the defer boundary; bump version.

**`claude-dream-team` (0.4.0 → 0.5.0):**
6. Delete `skills/obsidian-conventions/`.
7. Strip Obsidian from `plugin.json` (description + `obsidian` keyword),
   `agents/technical-writer.md`, the root README skills table, and the
   marketplace description; bump version.

**Repo:**
8. `CLAUDE.md` — rewrite the cross-plugin ownership note (vault-keeper is the
   sole Obsidian owner among our plugins and defers syntax to the required
   official plugin); update the plugins table (dream-team 7→6 skills; both
   versions).

## Validation

`plugin-dev:plugin-validator` on both changed plugins, `plugin-dev:skill-reviewer`
on the revised `obsidian-vault` skill. No commit/push/release unless requested.
