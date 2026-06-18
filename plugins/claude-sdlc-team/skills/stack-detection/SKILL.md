---
name: stack-detection
description: Detect and adapt to any repository's tech stack and conventions. Use as the FIRST step of every SDLC agent, before doing phase work, to identify language, framework, package manager, test runner, build/lint tooling, and the repo's own conventions (including its CLAUDE.md). Ensures the team follows existing repo conventions rather than imposing defaults.
---

# Stack Detection

Run this before any phase work. Produce a short "stack profile" you can reason from.

## What to read
- Dependency manifests: `package.json`, `composer.json`, `go.mod`, `pyproject.toml`/`requirements.txt`, `Cargo.toml`, `Gemfile`, `pom.xml`/`build.gradle`.
- Lockfiles to confirm the package manager (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `composer.lock`).
- Test runner & scripts: the `scripts` block (npm), `composer.json` scripts, `Makefile`, CI files under `.github/workflows/`.
- Lint/format config: `.eslintrc*`, `.prettierrc*`, `pint.json`, `ruff.toml`, `.editorconfig`.
- The repo's own `CLAUDE.md`/`AGENTS.md` and any `README` for stated conventions.

## Output: stack profile
Summarize: primary language(s) & version, framework(s), package manager, test command, lint/format command, build command, and notable conventions. Note anything missing (e.g. "no test runner configured").

## Rule
When the repo already has a convention, **follow it**. Fall back to the opinionated skills only when a choice is genuinely open (greenfield or a brand-new component).
