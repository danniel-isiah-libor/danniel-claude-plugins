# Architecture Styles: Monolith vs Microservices

- **Monolith (default for most projects):** one deployable; simplest ops; refactor boundaries internally first. Prefer until scale/organizational pressure justifies otherwise.
- **Microservices:** independent deploy/scale per service at the cost of distributed-systems complexity (network, data consistency, observability). Justify with concrete drivers (team autonomy, independent scaling, fault isolation).
- **Modular monolith** is often the right middle: strong internal module boundaries, single deploy.
- Decision checklist: team size, deploy cadence, scaling profile, data-consistency needs, ops maturity.
