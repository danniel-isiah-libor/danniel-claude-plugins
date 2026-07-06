# Filing decisions

The full policy behind the quick decision list in `SKILL.md`. Use this when the
quick list isn't enough — an ambiguous note, a meeting note to process, a batch of
requirement PDFs, or keepers to promote out of the capture streams.

## Where does this note go — full tree

```
Incoming note
│
├─ Raw capture (unprocessed, "what happened / was said today")?
│    ├─ From a meeting? ──────────────► Meetings/YYYY/MM-Month/
│    └─ Otherwise (log, scratch, WIP) ─► Daily Notes/YYYY/MM-Month/
│         └─ promote keepers into their permanent home when processing
│
├─ About one specific project?
│    ├─ Current employer ─────────────► Work/<Employer>/1 Projects/<Project>/
│    └─ Past employer ────────────────► Work/_Past Employers/<Employer>/1 Projects/<Project>/
│         (finished → 4 Archive/ under that employer)
│
├─ Reusable across one employer's projects (pattern / stack convention / playbook)?
│    └─────────────────────────────────► Work/<Employer>/3 Resources/
│         └─ add used_in: [[Project A]], [[Project B]] and a type tag
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

Rule of thumb for the hardest call — project note vs. employer reference note: if
it documents *how this particular project works*, it's a project note. If it
documents *a technique you'd reach for again on another of that employer's
projects*, it's a `3 Resources/` note that links back to the projects where you
used it. Context stays inside the employer either way.

## Requirement-PDF → notes workflow

The established flow: incoming requirement PDFs are converted into vault notes
(not left as PDFs) so the knowledge is reusable across projects.

1. Read the PDF(s) from wherever they arrive (often `_attachments/` or an upload).
2. Convert into clean Markdown notes — one atomic note per coherent requirement
   area, not one giant dump. Follow `obsidian:obsidian-markdown` for syntax.
3. File the notes under the relevant project:
   `Work/<Employer>/1 Projects/<Project>/`. These are project notes.
4. If a requirement reveals a *reusable* approach (e.g. a compliance-tracking
   pattern you'll want again), write a separate note in that employer's
   `3 Resources/` and `used_in:`-link it to this project — don't bury the
   reusable idea inside the project-specific notes.
5. Keep the original PDF in `_attachments/` for provenance; the notes are the
   reference once they exist.

## Meeting-note lifecycle

Meeting notes are a capture stream, treated like daily notes.

1. **Capture** into `Meetings/YYYY/MM-Month/` using `_templates/Meeting.md`; set
   the `company:` key to the employer it belongs to. Most of the note (attendees,
   scheduling, status chatter) has no long-term value — that's expected.
2. **Mark keepers in the moment** — put decisions, rationale, and action items
   under a clear `## Decisions` heading so they survive retrieval.
3. **Promote when processing the note** (right after the meeting, or on
   request) — lift decisions into the relevant project note; lift reusable
   insights into that employer's `3 Resources/`. The raw meeting note stays as
   the timestamped record.
4. **Never treat the raw meeting note as reference-grade** — it's mined for the
   two or three durable things inside it, not queried wholesale.

## Promoting keepers — on demand, not scheduled

The preferred path is writing durable material **directly** into its permanent
home (project note Business Rules, or the employer's `3 Resources/`) — by hand or
via a `project-context` write-back. There is no scheduled sweep. When
something lands in a capture stream first and is promoted later:

1. Find candidates by reading recent capture notes — their `## Decisions`
   headings and anything that reads like a durable rule, pattern, or fix.
2. For each hit, attribute it to an employer (meeting `company:` key, names in
   the text, or ask), then decide its permanent home: project note
   (project-specific) or that employer's `3 Resources/` (reusable).
3. Promote it — write/expand the destination note, link it, and leave the capture
   note in place as the record. Promotion is human-judged: propose before
   promoting when acting on the user's behalf.
4. Process any `_inbox/` backlog into PARA while you're here.

## Employer reference notes (`3 Resources/`) and the `used_in:` convention

Each employer's `3 Resources/` doubles as employment admin *and* that employer's
reusable reference layer. Reference-note kinds (as note types, not subfolders —
tag them instead):

- **pattern** — architecture & design patterns (e.g. two-way sync pipeline,
  polymorphic type modelling, approval-workflow state machine). Describe the
  pattern, when to use it, and the gotchas.
- **stack** — stack-specific conventions and cheatsheets (Laravel, Filament,
  GCP/Cloud Run, Redis session state).
- **playbook** — repeatable processes (technical-interview format, new-project
  scoping steps).

Every reference note links *out* to that employer's projects that prove it rather
than duplicating them:

```yaml
---
tags: [pattern]
used_in:
  - "[[Columbus Capital — HubSpot Middleware]]"
  - "[[Elton Group Sage X3 HubSpot Integration]]"
status: active
created: {{date:YYYY-MM-DD}}
---
```

This is what makes goal 3 work per employment: the pattern is written once inside
the employer folder, and its `used_in:` links answer "show me past
implementations of this" within that employment. **There is deliberately no
vault-level knowledge layer** — context stays inside the employer boundary, and
`project-context`-wired coding sessions read only that employer's folder plus its
captures.

## Build reactively, not preemptively

Don't back-fill `3 Resources/` reference notes in a big sweep. Write a pattern
note the first time you reach for a past pattern and can't find it fast — let
real retrieval failures decide what gets promoted. You'll build exactly the
library you need and nothing you don't.
