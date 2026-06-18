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

## Security
- Least-privilege DB users (app ≠ admin); parameterized queries only; encrypt sensitive columns / at rest; keep credentials in Secret Manager.
