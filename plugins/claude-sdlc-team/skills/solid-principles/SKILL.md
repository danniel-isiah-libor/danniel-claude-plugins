---
name: solid-principles
description: Apply and review against the five SOLID object-oriented design principles. Use when designing components, writing classes/modules, or reviewing code for maintainability and coupling. Language-neutral guidance with review heuristics for the architect, implementer, and code reviewer.
---

# SOLID Principles

- **S — Single Responsibility.** A unit has one reason to change. Smell: a class touched by unrelated feature requests; mixed concerns (I/O + business logic). Fix: split by responsibility.
- **O — Open/Closed.** Open for extension, closed for modification. Prefer adding new types/strategies over editing switch-ladders. Smell: growing `if/elseif` on a type tag.
- **L — Liskov Substitution.** Subtypes must be usable wherever the base is, honoring its contract. Smell: overrides that throw "not supported" or tighten preconditions.
- **I — Interface Segregation.** Many small, focused interfaces over one fat one. Smell: implementers forced to stub methods they don't use.
- **D — Dependency Inversion.** Depend on abstractions, not concretions; inject dependencies. Smell: `new` of a concrete service deep inside business logic.

## Review heuristics
For each changed unit ask: one responsibility? extendable without editing it? substitutable? interface minimal? dependencies injected? Cite the specific principle + file:line when flagging.

## Balance
SOLID serves clarity, not ceremony. Don't add abstraction layers a single concrete implementation doesn't need (see clean-code-standards: YAGNI).
