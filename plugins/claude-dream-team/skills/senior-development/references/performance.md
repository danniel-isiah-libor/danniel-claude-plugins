# Performance

Measure first, optimize the bottleneck, then re-measure. Premature optimization violates KISS/YAGNI; ignoring obvious hotspots violates senior judgment.

- **Define budgets** where it matters (e.g. API p95 latency, Largest Contentful Paint, bundle size) and check them in CI when the project has tooling.
- **Backend:** avoid N+1 (eager load/batch), index queried columns (verify with `EXPLAIN`), paginate, cache expensive reads with explicit invalidation and TTLs, move slow work off the request path (queues/jobs), set timeouts and connection-pool limits on every outbound call.
- **Algorithms & memory:** pick data structures for the access pattern; stream large payloads instead of loading them whole; bound unbounded collections.
- **Frontend:** ship less (code-split, tree-shake, lazy-load below the fold), optimize images (modern formats, responsive sizes, explicit dimensions to avoid layout shift), avoid blocking the main thread, debounce expensive handlers.
- **Network:** compression, HTTP caching headers/CDN for static assets, keep payloads small, reuse connections.
- **Cost link:** on pay-per-use platforms, performance is also cost — see the `gcp-devops` skill.
