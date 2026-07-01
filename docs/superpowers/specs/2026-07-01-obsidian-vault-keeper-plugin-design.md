# Design: `obsidian-vault-keeper` plugin

**Date:** 2026-07-01
**Status:** Approved (design) — ready for implementation planning
**Repo:** `danniel-claude-plugins` (marketplace)

## Summary

A new marketplace plugin whose single job is to be an **active Obsidian vault
steward**. It performs vault-maintenance work through the connected Obsidian MCP
tools (`mcp__obsidian__*`), with a filesystem fallback, while enforcing
best-practice Obsidian conventions. The plugin becomes the marketplace's single
source of truth for deep Obsidian knowledge; `claude-dream-team`'s existing
`obsidian-conventions` skill is slimmed to a compact primer for the
technical-writer.

Modeled on the existing `claude-dream-team` plugin (agent + skill + `references/`
+ command) so it feels native to the marketplace.

## Goals

- A `vault-keeper` agent the user summons whenever they interact with their
  Obsidian vault — it reads and edits the vault, not just advises.
- An `obsidian-vault` skill holding the authoritative Obsidian knowledge (the
  three references moved from `claude-dream-team`, enriched) plus a new
  maintenance-operations manual.
- A `/vault-checkup` command that runs a full health sweep (read-only first),
  reports findings, then offers to fix.
- Consolidate deep Obsidian knowledge here; slim `claude-dream-team`'s copy.

## Non-goals (YAGNI)

- **No bundled Obsidian MCP** (`.mcp.json`). The `mcp-obsidian` server needs a
  secret API key that can't be hardcoded, and the user already has it connected
  user-wide — bundling would risk a duplicate-server conflict. The agent uses the
  MCP when present and falls back to filesystem access otherwise.
- No auto-scheduled maintenance (a future hook/cron could add it).
- No Dataview/Bases dashboards beyond MOC index templates.
- `claude-sdlc-team` is untouched.

## Naming

| Component | Name |
|-----------|------|
| Plugin    | `obsidian-vault-keeper` |
| Agent     | `vault-keeper` |
| Skill     | `obsidian-vault` |
| Command   | `/vault-checkup` |

## Structure

```
plugins/obsidian-vault-keeper/
  .claude-plugin/plugin.json
  README.md
  agents/vault-keeper.md
  commands/vault-checkup.md
  skills/obsidian-vault/
    SKILL.md
    references/
      style-guide.md            # moved from claude-dream-team
      obsidian-syntax.md         # moved from claude-dream-team
      vault-organization.md      # moved from claude-dream-team (enriched)
      maintenance-workflows.md   # NEW — the steward's operations manual
```

## Component: the `vault-keeper` agent

A senior Obsidian librarian. `model: opus`, `color: purple` (distinct from the
blue technical-writer). Tools unrestricted (matching the other plugin agents) so
it can reach both the Obsidian MCP tools and the filesystem.

Process:

1. **Survey first** — read the vault's structure, `.obsidian` config, existing
   templates/MOCs/naming conventions. Follow the vault's *own* conventions if
   present; use the skill's defaults otherwise. This replaces the cross-plugin
   `project-adaptation` dependency (plugins can't share skills) — the
   survey-first step is built into the agent and skill directly.
2. **Apply conventions** from the `obsidian-vault` skill.
3. **Operate via MCP** — prefer link-safe operations; use `mcp__obsidian__*` when
   connected, fall back to Read/Edit/Write on the vault path when not.
4. **Verify** links/frontmatter intact after changes; report what changed.

Boundaries:

- Read a note before deleting or overwriting it; never delete user content
  without confirming.
- Warn that filesystem/REST moves don't auto-update `[[links]]`, and compensate
  (fix backlinks / recreate links).
- Don't introduce plugin dependencies for core content; keep one sync method.

## Component: the `obsidian-vault` skill

`SKILL.md` is the steward's operating manual: survey-first, a conventions summary
(syntax/style/organization essentials), and a maintenance section pointing into
the references. It is an enriched evolution of the current
`obsidian-conventions/SKILL.md`.

The three moved references (`style-guide.md`, `obsidian-syntax.md`,
`vault-organization.md`) carry over; `vault-organization.md` is enriched with the
steward's perspective.

The new `references/maintenance-workflows.md` is the heart of the skill — each
maintenance job as a repeatable, MCP-aware workflow:

1. **Vault health snapshot** — inventory structure; count orphans, broken links,
   notes missing frontmatter.
2. **Capture & filing** — process `_inbox` into PARA; apply templates.
3. **MOC build & refresh** — create/update bucket index notes with Dataview.
4. **Link hygiene** — find & fix broken `[[links]]`, unlinked mentions, safe
   renames.
5. **Orphan detection** — no-inbound/outbound notes → propose linking or
   archiving.
6. **Frontmatter normalization** — enforce a property schema; fix drift.
7. **Dedup & rename** — detect near-duplicates, merge safely, consistent naming.
8. **Archive lifecycle** — projects → archive, the employer lifecycle moves.
9. **Link-safe editing via MCP** — the critical caveat (filesystem/REST moves
   break `[[links]]`) and how to compensate.

## Component: the `/vault-checkup` command

Parallels `/dream-team-review`:

- **Read-only sweep first** — scan for orphans, broken links, frontmatter drift,
  misfiled/duplicate notes, stale MOCs.
- **Report** findings grouped by category with counts.
- **Offer to fix**, confirming before any destructive operation. Non-destructive
  fixes can be applied directly; destructive ones (delete, merge, bulk move)
  require confirmation.
- `$ARGUMENTS` optionally scopes the checkup to a folder.

## Changes to `claude-dream-team` (the "slim" part)

To make the new plugin the single source of truth, `claude-dream-team`'s
`obsidian-conventions` becomes a genuine slim primer:

- **Delete** its `references/` folder — all three files move to the new plugin.
- **Collapse inline into its `SKILL.md`** (~40–50 lines) only the essentials the
  technical-writer still needs to *write* vault docs: Obsidian Markdown syntax
  essentials (links/embeds/callouts/properties), the writing style essentials,
  and link safety. It stays self-sufficient for writing; for organizing and
  maintaining, the `obsidian-vault-keeper` plugin is the authoritative home.
- **Update** the skill's `description`, the one line in `technical-writer.md`
  that references it, `claude-dream-team`'s `plugin.json` description, and its
  `marketplace.json` entry.
- **Bump** `claude-dream-team`'s version.
- **Register** the new plugin in `marketplace.json` at `0.1.0`.

### Version reconciliation note

Committed files show `claude-dream-team` at `v0.3.0`, but session memory recorded
a bump to `v1.2.0`. During implementation, reconcile against the actual committed
value and bump from there (do not assume the memory value).

## Verification

- Run the `plugin-validator` agent on the new plugin.
- Run the `skill-reviewer` agent on the new `obsidian-vault` skill and the slimmed
  `obsidian-conventions` skill.
- Manually confirm no cross-references break after moving files, and that the
  technical-writer remains self-sufficient for writing vault docs.

## Open decisions (defaulted, may be revisited)

- MCP is used-if-available with filesystem fallback; not bundled (see Non-goals).
- Names per the table above; may be renamed before/at implementation.
