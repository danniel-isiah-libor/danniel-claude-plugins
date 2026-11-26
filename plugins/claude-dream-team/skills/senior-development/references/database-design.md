# Database Schema Design

Design to the project's standards (`project-adaptation`); apply these defaults otherwise. Goals: correctness/integrity first, then optimization, at the lowest sensible complexity.

## Modeling & normalization
- Model real entities and relationships; one fact in one place.
- Normalize to **3NF** by default (eliminate redundancy and update anomalies).
- **Denormalize deliberately** only for proven read-performance needs — document the trade-off and how you keep the copies consistent.

## Keys & integrity
- Explicit primary keys (prefer surrogate keys; UUID/BIGINT per project norm); foreign keys with intentional `ON DELETE` / `ON UPDATE` behavior.
- Enforce invariants in the schema: `NOT NULL`, `UNIQUE`, `CHECK`, and correct types/precision (money as decimal, timestamps in UTC).

## Indexing & optimization
- Index foreign keys and columns used in `WHERE` / `JOIN` / `ORDER BY`; order composite indexes by selectivity and query shape.
- Don't over-index (each index taxes writes); use covering indexes for hot reads; verify with `EXPLAIN`.
- Avoid N+1 access patterns; paginate large reads; pool connections.

## Transactions & consistency
- Wrap multi-statement writes in a transaction (all-or-nothing); commit on success, **roll back on error**; keep transactions short to limit lock contention.
- Choose isolation levels deliberately; prevent race conditions with the database (unique constraints, `SELECT … FOR UPDATE`, optimistic version columns) rather than relying on app-level checks.
- For retry-safe writes, prefer upserts / `INSERT … ON CONFLICT` so a repeated operation doesn't duplicate data (pairs with idempotency in `SKILL.md`).

## Migrations
- Versioned, reviewed, and **reversible**; additive/backward-compatible where possible; never run destructive changes on prod without a backup and a plan.
- **Zero-downtime = expand → migrate → contract.** (1) *Expand:* add new nullable columns/tables/indexes (create indexes concurrently where supported); (2) deploy code that writes both and reads new-with-fallback; (3) backfill in small batches outside the request path; (4) switch reads; (5) *Contract:* drop the old column/table in a later release once nothing reads it.
- Never in one step: rename a column/table in use, add `NOT NULL` without a default/backfill, change a column type with a table rewrite on a large table, or hold long locks. Set lock/statement timeouts on migrations.
- Make migrations **idempotent and re-runnable**; keep schema changes separate from data backfills; test against a production-sized copy when the table is large; rehearse the rollback.

## Security
- Least-privilege DB users (app ≠ admin); parameterized queries only; encrypt sensitive columns / at rest; keep credentials in Secret Manager.
