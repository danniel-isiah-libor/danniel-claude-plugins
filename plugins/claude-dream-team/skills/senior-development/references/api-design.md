# API design

Follow the project's existing API style first (`project-adaptation`); these are defaults.

- **Contract first.** Define request/response shapes (OpenAPI/GraphQL schema/protobuf) before implementing; keep one source of truth and generate types/docs from it.
- **Resources & verbs (REST).** Nouns for resources, HTTP verbs for actions; correct status codes (201 create, 204 no body, 400 validation, 401/403 authn/authz, 404, 409 conflict, 422, 429); consistent naming and casing.
- **Errors.** One error shape everywhere (e.g. RFC 9457 problem details): stable machine-readable `code`, human `message`, field-level details; never leak stack traces or internals.
- **Validation at the boundary.** Validate and normalize all input; reject unknown fields or allowlist writable ones (prevents mass assignment).
- **Pagination, filtering, sorting.** Paginate every list (cursor-based for large/changing sets); cap page size; document defaults.
- **Idempotency & retries.** `PUT`/`DELETE` idempotent by design; accept an `Idempotency-Key` on non-idempotent creates that can be retried (payments, orders).
- **Concurrency.** Use ETags / version fields for optimistic locking on updates.
- **Versioning & compatibility.** Additive changes are non-breaking; breaking changes need a new version (path/header) and a deprecation window with `Deprecation`/`Sunset` headers.
- **Security.** Authn on every endpoint, authorization per object (not just per route), rate limiting, CORS allowlist, no secrets in URLs.
- **Performance.** Avoid chatty and N+1 endpoints; allow field selection or expansion where useful; support conditional requests/caching.
