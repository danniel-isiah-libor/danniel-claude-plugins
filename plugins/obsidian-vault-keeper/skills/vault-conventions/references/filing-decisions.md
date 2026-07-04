# Filing decisions

The full policy behind the quick decision list in `SKILL.md`. Use this when the
quick list isn't enough — an ambiguous note, a meeting note to process, a batch of
requirement PDFs, or the weekly harvest.

## Where does this note go — full tree

```
Incoming note
│
├─ Raw capture (unprocessed, "what happened / was said today")?
│    ├─ From a meeting? ──────────────► Meetings/YYYY/MM-Month/
│    └─ Otherwise (log, scratch, WIP) ─► Daily Notes/YYYY/MM-Month/
│         └─ tag any keeper section #reusable in the moment
│
├─ About one specific project?
│    ├─ Current employer ─────────────► Work/<Employer>/1 Projects/<Project>/
│    └─ Past employer ────────────────► Work/_Past Employers/<Employer>/1 Projects/<Project>/
│         (finished → 4 Archive/ under that employer)
│
├─ Reusable across projects (pattern / stack convention / playbook)?
│    └─────────────────────────────────► Knowledge/{Patterns|Stacks|Playbooks}/
│         └─ add used_in: [[Project A]], [[Project B]] and #reusable
│
├─ Employment admin (contract, payslip, onboarding, company profile)?
│    └─────────────────────────────────► Work/<Employer>/3 Resources/
│
├─ Personal life?
│    └─────────────────────────────────► Personal/{1 Projects|2 Areas|3 Resources|4 Archive}/
│
└─ Genuinely unsure / fast dump?
     └────────────────────────────────► _inbox/  (file properly on next review)
```

Rule of thumb for the hardest call — project note vs. Knowledge note: if it
documents *how this particular project works*, it's a project note. If it
documents *a technique you'd reach for again on a different project*, it's a
Knowledge note that links back to the projects where you used it.

## Requirement-PDF → notes workflow

The established flow: incoming requirement PDFs are converted into vault notes
(not left as PDFs) so the knowledge is reusable across projects.

1. Read the PDF(s) from wherever they arrive (often `_attachments/` or an upload).
2. Convert into clean Markdown notes — one atomic note per coherent requirement
   area, not one giant dump. Follow `obsidian:obsidian-markdown` for syntax.
3. File the notes under the relevant project:
   `Work/<Employer>/1 Projects/<Project>/`. These are project notes.
4. If a requirement reveals a *reusable* approach (e.g. a compliance-tracking
   pattern you'll want again), write a separate `Knowledge/Patterns/` note for the
   pattern and `used_in:`-link it to this project — don't bury the reusable idea
   inside the project-specific notes.
5. Keep the original PDF in `_attachments/` for provenance; it does not need to
   enter the Graphify graph once the notes exist (the notes are the reference).

## Meeting-note lifecycle

Meeting notes are a capture stream, treated like daily notes.

1. **Capture** into `Meetings/YYYY/MM-Month/` using `_templates/Meeting.md`. Most
   of the note (attendees, scheduling, status chatter) has no long-term value —
   that's expected.
2. **Tag keepers in the moment** — decisions, rationale, action items, and any
   reusable insight get `#reusable` (or a clear `## Decisions` heading) so they
   survive retrieval.
3. **Harvest on the weekly review** — lift decisions into the relevant project
   note; lift reusable insights into `Knowledge/`. The raw meeting note stays as
   the timestamped record.
4. **Never treat the raw meeting note as reference-grade** — it's mined for the
   two or three durable things inside it, not queried wholesale.

## The weekly harvest ritual

The step that keeps capture from dying in the stream. Run it weekly (a natural fit
for the weekly periodic note as a checklist):

1. Query everything tagged `#reusable` created this week across `Daily Notes/` and
   `Meetings/`.
2. For each hit, decide its permanent home: project note (project-specific) or
   `Knowledge/` (reusable).
3. Promote it — write/expand the destination note, link it, and leave the capture
   note in place as the record.
4. Process the `_inbox/` backlog into PARA while you're here.
5. If any note content changed meaningfully, run `/graphify --update` on the vault
   so the graph's reference layer catches up (see `SKILL.md` → Graphify scope).

## Knowledge/ note types and the `used_in:` convention

- **Patterns/** — architecture & design patterns (e.g. two-way sync pipeline,
  polymorphic type modelling, approval-workflow state machine). Describe the
  pattern, when to use it, and the gotchas.
- **Stacks/** — stack-specific conventions and cheatsheets (Laravel, Filament,
  GCP/Cloud Run, Redis session state).
- **Playbooks/** — repeatable processes (technical-interview format, new-project
  scoping steps).

Every `Knowledge/` note links *out* to the projects that prove it rather than
duplicating them:

```yaml
---
tags: [pattern, reusable]
used_in:
  - "[[Columbus Capital — HubSpot Middleware]]"
  - "[[Elton Group Sage X3 HubSpot Integration]]"
status: active
created: {{date:YYYY-MM-DD}}
---
```

This is what makes goal 3 work: the pattern is written once, stays out of the
per-employer archive sweep, and Graphify can traverse `used_in:` to answer "show
me past implementations of this" across the whole vault.

## Build reactively, not preemptively

Don't back-fill `Knowledge/` in a big sweep. Write a pattern note the first time
you reach for a past pattern and can't find it fast — let real retrieval failures
decide what gets promoted. You'll build exactly the library you need and nothing
you don't.
