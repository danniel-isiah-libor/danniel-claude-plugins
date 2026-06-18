---
name: software-architecture
description: Turn requirements into a technical design. Use when writing 02-design.md — decomposition into components with clear boundaries, interfaces/contracts, data flow, a file-level build sequence, trade-off analysis, and a test strategy outline. Primary skill of the solution-architect.
---

# Software Architecture

## Produce (02-design.md)
1. **Approach** — the chosen design in 2–4 sentences + why.
2. **Components** — each with one responsibility, its interface, and dependencies. Design so each unit can be understood and tested in isolation.
3. **Data model** — entities/relationships (defer physical schema/indexing to database-design).
4. **Interfaces/contracts** — function signatures, API shapes, events.
5. **Affected files** — exact paths to create/modify.
6. **Build sequence** — ordered, each step independently testable.
7. **Trade-offs & risks** — alternatives considered, why rejected.
8. **Test strategy outline** — what to cover and at which level.

## Design-for-isolation test
For each unit: can someone understand what it does without reading its internals? Can internals change without breaking consumers? If not, fix the boundary.

## Rule
Reuse existing patterns in the repo (per stack-detection). Cite solid-principles and, for cross-cutting concerns, ui-ux-design / performance-and-cost / database-design as relevant. Ask via `QUESTIONS FOR USER` when requirements leave a design-significant choice open.
