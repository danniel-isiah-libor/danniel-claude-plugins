# Unit testing

Use the project's existing runner, assertion style, and layout (`project-adaptation`). The qa-engineer is the only agent that writes tests.

## Scenario matrix — for every unit, consider
| Class | Examples |
|---|---|
| Happy path | Typical valid input → expected output/side effect |
| Boundaries | Empty, one, max, max+1, zero, negative, very large, unicode/long strings |
| Invalid input | Wrong type, missing required field, malformed data → clear error, no partial state |
| Error paths | Dependency throws/times out, DB constraint violation → handled, resources cleaned up, transaction rolled back |
| Auth/permissions | Anonymous, wrong role, owner vs non-owner (IDOR), expired session |
| State & ordering | Idempotent repeat, duplicate delivery, out-of-order events |
| Concurrency | Two writers, race on unique constraint, double submit |
| Time & locale | Time zones/DST, month ends, locale formats — inject the clock, never use real time |

## Design rules
- **Arrange–Act–Assert**, one behavior per test, named for the behavior (`rejects_expired_token`), not the method.
- Test **behavior through the public interface**; don't assert on private internals or call counts unless the interaction *is* the behavior.
- Mock only **boundaries** (network, clock, filesystem, third-party APIs). Prefer real objects and an in-memory/containerized DB for data logic over mocking the ORM.
- Each test is **independent and order-free**: own fixtures, no shared mutable state, clean up after itself.
- **Deterministic**: no sleeps, real network, random seeds, or wall-clock dependence. A flaky test is a defect — quarantine it with a ticket, never retry-until-green.
- Regression first: when a bug is found, write the failing test that reproduces it, then hand the fix to its owner.

## Coverage
- Measure **branch** coverage, and read the uncovered lines rather than chasing a number. Use the project's existing threshold; if none, treat ~80% branches on changed code as a floor and 100% of security- and money-critical paths as the goal.
- Coverage proves code ran, not that it's correct — assertions matter. Spot-check with mutation testing (Stryker, mutmut, Infection, PIT) on critical modules when available.

## Test pyramid
Many fast unit tests → fewer integration tests (real DB/queue) → a small set of E2E journeys. Push checks down to the cheapest level that can catch the defect.

## Reporting
List which scenario classes you covered and which you deliberately skipped (with reason) in the report's Unit notes.
