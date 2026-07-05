---
name: vault-conventions
description: The house rules for THIS specific Obsidian vault (Danniel's) — the filing decisions, folder map, and conventions that say where an incoming note goes and how to write it. Use whenever capturing, writing, filing, converting, or routing any note into the vault (project notes, requirement docs turned into notes, meeting notes, daily notes, reusable patterns) so it lands in the right place with the right frontmatter and tags. Encodes the per-employer PARA nesting under Work/, the vault-level Knowledge/ reference layer, the capture-vs-harvest rule for Daily Notes/ and Meetings/, and the #reusable carry-forward tag. Overrides the generic obsidian-vault skill wherever they differ; defers to obsidian-vault for maintenance workflows and to the official obsidian:* skills for authoring syntax.
---

# Vault conventions — this vault's house rules

The vault-specific policy layer for the vault at
`/Users/dannielibor/Documents/Obsidian Vault`. Where the generic `obsidian-vault`
skill knows how a *good* vault works in general, this skill knows how *this* vault
has decided to work. When you are about to write, file, or route a note here,
consult this first so it lands correctly.

## Precedence — how this fits the other skills

- **This skill wins on vault-specific decisions** — where a note goes, what
  frontmatter it carries, which tag marks it, how capture streams are handled.
  When it conflicts with a generic default, follow this skill.
- **Defer to `obsidian-vault`** for the *how* of maintenance — link hygiene, MOC
  build/refresh, orphan detection, frontmatter normalization, dedupe/rename, the
  link-safe move checklist. This skill sets policy; that skill executes it.
- **Defer to the official `obsidian:*` skills** for authoring syntax —
  `obsidian:obsidian-markdown` (wikilinks, callouts, properties, tags),
  `obsidian:obsidian-bases` (`.base`), `obsidian:json-canvas` (`.canvas`). Never
  restate syntax here.

## The vault map

```
Obsidian Vault/
├── CLAUDE.md                    vault guide for Claude Code
├── Work/                        career history + active work (memory + project KB)
│   ├── SN Aboitiz Power Group/  current employer — per-employer PARA inside
│   │   ├── 1 Projects/  2 Areas/  3 Resources/  4 Archive/
│   ├── _Past Employers/         former employers, preserved with their PARA sets
│   ├── Career Journey.md  ·  Work.md
├── Personal/                    single PARA set + Personal Documents/
├── Knowledge/                   * vault-wide reusable reference (future-project memory)
│   ├── Patterns/                cross-project architecture & design patterns
│   ├── Stacks/                  Laravel / Filament / GCP conventions & cheatsheets
│   ├── Playbooks/               repeatable processes (interviewing, scoping)
│   └── Knowledge.md             MOC / index
├── Daily Notes/                 * capture stream — foldered YYYY/MM-Month
├── Meetings/                    * capture stream — foldered YYYY/MM-Month
├── Dashboard/                   Home + Claude Code status integration
└── _inbox/  ·  _templates/  ·  _attachments/
```

`*` = layers being established. If a survey doesn't find `Knowledge/`,
`Meetings/`, or the dated subfolders yet, **create them to this spec** rather than
treating the vault as convention-less. The per-employer nesting under `Work/` is
deliberate and correct — do not flatten it to satisfy textbook PARA.

## The three goals this vault serves

1. **Long-term memory** of all past and current work → `Work/`.
2. **Knowledge base** of every project worked on → project notes under each
   employer's `1 Projects/` (and `4 Archive/` when done).
3. **Reusable reference** for future projects, pulled on demand only →
   `Knowledge/`, surfaced by the `#reusable` tag.

Goals 1 and 2 are met by `Work/`; goal 3 is the reason `Knowledge/` exists.

## Where a note goes — the decision

Ask in this order (full tree in `references/filing-decisions.md`):

1. **Is it a raw capture** (something said/decided today, unprocessed)? →
   `Daily Notes/` or `Meetings/`. It is a *log*, not reference. Do not put raw
   captures in `Knowledge/`.
2. **Is it about a specific project?** → that employer's
   `1 Projects/<Project>/`. Deep technical project notes live here.
3. **Is it a reusable pattern/convention/playbook** meant to inform *future*
   projects, independent of any one project? → `Knowledge/` (Patterns / Stacks /
   Playbooks). Link it back to the projects that used it via `used_in:`.
4. **Is it employment admin** (contract, payslip, onboarding)? → that employer's
   `3 Resources/`.
5. **Personal?** → `Personal/`.
6. **Unsure / quick dump?** → `_inbox/`, to be filed later.

## Capture vs. reference — the core mental model

`Daily Notes/` and `Meetings/` are **capture streams**: fast, chronological,
mostly ephemeral, written before you know what matters. They are raw material, not
reference. `Knowledge/` and project notes are **reference**: curated, topic-shaped,
written with hindsight so future-you can reuse them.

**The harvest ritual** is what turns capture into reference: capture fast in the
stream, then during a weekly review lift the durable keepers (a decision, a
pattern that worked, a non-obvious fix) into their permanent home — a project note
or a `Knowledge/` note. The capture note stays as the timestamped record; the
insight graduates. Meeting notes follow the same path: store the raw note in
`Meetings/`, harvest the decisions and reasoning out of it. Detail and the
weekly-review steps in `references/filing-decisions.md`.

## The `#reusable` tag

The single carry-forward filter that cuts across the by-employer filing. Apply
`#reusable` to any note *or* section — the moment you write something you know is
worth referencing later, even inside a daily/meeting note. It makes an insight
findable before it's formally harvested, and gives the weekly review a single
query: sweep everything tagged `#reusable` in capture streams and promote it.

## Frontmatter conventions

- **Project notes** carry rich frontmatter — observed keys: `tags`, `company`,
  `client`, `end_client`, `role`, `status` (`active`/`completed`), `stack`,
  `repo`, `created`, `updated`. Start from `_templates/Project.md`.
- **Daily notes** from `_templates/Daily Note.md`; **meeting notes** from
  `_templates/Meeting.md`.
- **Knowledge notes** carry `tags` (including `#reusable`) and a `used_in:` list
  of `[[wikilinks]]` to the projects that prove the pattern.
- **MOC/index notes** are named after their folder and tagged `moc`, embedding a
  Dataview (or Bases) query rather than a hardcoded list.

## References

- **`references/filing-decisions.md`** — the full where-does-it-go decision tree,
  the meeting-note lifecycle, the requirement-PDF-to-notes workflow, the weekly
  harvest ritual, and the `Knowledge/` note types with the `used_in:` convention.

For authoring syntax defer to the official `obsidian:*` skills; for maintenance
workflows defer to `obsidian-vault`.
