---
name: database-design
description: Design and review relational schemas, MySQL-focused. Use when the design or implementation involves data modeling — tables, keys, relationships, normalization, indexing, constraints, migrations, and query/EXPLAIN optimization. Used by the architect (data model) and implementer (schema/migrations).
---

# Database Design (MySQL-focused)

## Schema
- Normalize to 3NF by default; denormalize only with a measured read-performance reason (note it).
- Primary keys: prefer surrogate `BIGINT UNSIGNED AUTO_INCREMENT` (or UUID when distribution requires); always declare them.
- Foreign keys with explicit `ON DELETE`/`ON UPDATE`; name constraints.
- Choose narrow, correct column types; `NOT NULL` unless null is meaningful; sensible defaults.

## Indexing
- Index columns used in `WHERE`, `JOIN`, `ORDER BY`. Composite index column order = equality → range → sort.
- Avoid redundant/overlapping indexes; watch write cost.
- Verify with `EXPLAIN`; look for full scans, filesorts, temporary tables.

## Migrations
- Forward-only, reversible where possible; one logical change per migration; never edit a shipped migration.

## Review heuristics
Flag missing indexes on FK/lookup columns, N+1-prone access patterns (coordinate with performance-and-cost), wrong types, missing constraints.
