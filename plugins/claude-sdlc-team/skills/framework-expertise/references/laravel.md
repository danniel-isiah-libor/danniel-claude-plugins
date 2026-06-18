# Laravel / Filament

- Follow Laravel conventions: named routes, Eloquent API Resources for APIs, factories/seeders for models, `route()` for URLs.
- Eloquent: avoid N+1 with eager loading (`with`); push filtering to the query; use scopes for reuse.
- Validation in Form Requests; authorization in Policies; thin controllers, logic in actions/services.
- Tests with the project's runner (often Pest/PHPUnit); prefer feature tests for HTTP behavior.
- Filament v5: resources/pages/schemas/forms/tables/actions/widgets; keep custom components minimal.
- Format with the project's tool (e.g. Pint) if configured.
