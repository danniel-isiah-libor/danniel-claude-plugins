---
name: requirements-engineering
description: Turn a raw request into clear, testable requirements. Use when writing 01-requirements.md — eliciting user stories, INVEST-quality criteria, Given/When/Then acceptance criteria, scope boundaries, and assumptions. Primary skill of the requirements-analyst.
---

# Requirements Engineering

## Produce
1. **Problem statement** — the user need and the why (1–2 sentences).
2. **User stories** — `As a <role>, I want <capability>, so that <benefit>.`
3. **Acceptance criteria** — for each story, `Given <context>, When <action>, Then <outcome>.` Make them observable/testable.
4. **Scope** — explicit In / Out lists. Out-of-scope prevents creep.
5. **Assumptions & constraints.**
6. **Open questions** — anything ambiguous (drives the clarify protocol).

## INVEST check
Each story: Independent, Negotiable, Valuable, Estimable, Small, Testable. Split stories that fail.

## Rule
Stay at the what/why altitude — no implementation choices (that's the architect). If the request is ambiguous or could be read multiple ways, ask via `QUESTIONS FOR USER` rather than guessing.
