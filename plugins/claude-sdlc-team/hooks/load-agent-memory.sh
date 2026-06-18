#!/usr/bin/env bash
# SessionStart hook: load the repo's committed agent memory into the session.
# No-ops silently when the repo has no .claude/agent-memory/ (non-SDLC repos / pre-init).
# Load-only: always exits 0, never blocks a session.

MEMORY_DIR="${CLAUDE_PROJECT_DIR:-$PWD}/.claude/agent-memory"
MEMORY_FILE="$MEMORY_DIR/MEMORY.md"

[ -f "$MEMORY_FILE" ] || exit 0

echo "## Project agent memory (.claude/agent-memory/)"
echo
echo "Durable, team-shared project context loaded from the repo. The MEMORY.md index follows; read individual fact files as needed."
echo
cat "$MEMORY_FILE" 2>/dev/null

echo
echo "### Available memory files"
find "$MEMORY_DIR" -maxdepth 1 -type f -name '*.md' ! -name 'MEMORY.md' ! -name 'README.md' 2>/dev/null \
  | sort | while read -r f; do echo "- $(basename "$f")"; done

exit 0
