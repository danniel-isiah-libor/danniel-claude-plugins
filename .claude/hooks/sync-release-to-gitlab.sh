#!/usr/bin/env bash
#
# Claude Code PostToolUse hook.
#
# Purpose: when a GitHub release is cut from THIS repo via `gh release create`,
# mirror the repository content into the GitLab counterpart and cut the matching
# release there too.
#
#   GitHub (danniel-claude-plugins)  = source of truth
#   GitLab (snap-claude-plugins)     = downstream mirror, keeps its own branding
#
# How it works
#   1. Reads the PostToolUse payload on stdin; acts only if the Bash command that
#      just ran contains `gh release create`.
#   2. Finds the latest GitHub release (the one just created).
#   3. If GitLab already has that release tag -> nothing to do (idempotent).
#   4. Clones GitLab into a temp dir, rsyncs this repo's content over it
#      (excluding .git and .claude), then re-applies GitLab branding
#      (marketplace name + install URLs). The .claude exclusion means this hook
#      is never copied to GitLab, so no sync loop is possible.
#   5. Commits, pushes main, creates+pushes the same tag, and runs
#      `glab release create` with the GitHub release's name + notes (rebranded).
#
# Notes
#   - Triggers only for releases created through Claude Code (a Bash tool call).
#     Releases made in the GitHub web UI or a plain terminal won't fire this.
#   - The GitHub release is NEVER affected; a sync failure only logs to stderr.
#   - Override targets via env: GITLAB_GIT_REMOTE, GITLAB_PROJECT. Set DRY_RUN=1
#     to do everything except push/tag/release.
#
set -uo pipefail

LOG_PREFIX="[gitlab-sync]"
log() { printf '%s %s\n' "$LOG_PREFIX" "$*" >&2; }

# --- read hook payload from stdin ---
PAYLOAD="$(cat)"

# Fast path: skip immediately unless this looks like a release command. Avoids
# spawning python on every single Bash call in the project.
case "$PAYLOAD" in
  *"gh release create"*) ;;
  *) exit 0 ;;
esac

# --- precise check: extract the actual command field and confirm ---
CMD="$(printf '%s' "$PAYLOAD" | python3 -c 'import sys,json
try:
    print(json.load(sys.stdin).get("tool_input",{}).get("command",""))
except Exception:
    print("")')"
case "$CMD" in
  *"gh release create"*) ;;
  *) exit 0 ;;
esac

log "GitHub release command detected; mirroring to GitLab."

# --- config (override via env) ---
SRC="${CLAUDE_PROJECT_DIR:-$PWD}"
GITLAB_GIT_REMOTE="${GITLAB_GIT_REMOTE:-git@snaboitiz.gitlab.com:snap-ocio/digital-solutions/snap-claude-plugins.git}"
GITLAB_PROJECT="${GITLAB_PROJECT:-snap-ocio/digital-solutions/snap-claude-plugins}"
DRY_RUN="${DRY_RUN:-0}"

# Branding rewrite (GitHub identity -> GitLab identity). Order matters: the
# install shorthand is replaced before the bare marketplace name.
GH_INSTALL="danniel-isiah-libor/danniel-claude-plugins"
GL_INSTALL="git@gitlab.com:snap-ocio/digital-solutions/snap-claude-plugins.git"
GH_NAME="danniel-claude-plugins"
GL_NAME="snap-claude-plugins"

# --- prerequisites ---
for bin in gh glab git rsync python3; do
  command -v "$bin" >/dev/null 2>&1 || {
    log "ERROR: '$bin' not on PATH; cannot sync. GitHub release is unaffected."
    exit 1
  }
done

# --- derive GitHub owner/repo from origin ---
GH_REPO="$(git -C "$SRC" remote get-url origin 2>/dev/null \
  | sed -E 's#(git@[^:]+:|https?://[^/]+/)##; s#\.git$##')"
[ -n "$GH_REPO" ] || { log "ERROR: could not determine GitHub repo from origin."; exit 1; }

# --- find the just-created release (latest) ---
TAG="$(gh -R "$GH_REPO" release list --limit 1 --json tagName --jq '.[0].tagName' 2>/dev/null)"
[ -n "$TAG" ] || TAG="$(gh -R "$GH_REPO" release list --limit 1 2>/dev/null | awk 'NR==1{print $1}')"
[ -n "$TAG" ] || { log "ERROR: no GitHub release found to mirror."; exit 1; }
log "Latest GitHub release: $TAG"

# --- idempotency: already mirrored? ---
if glab release view "$TAG" -R "$GITLAB_PROJECT" >/dev/null 2>&1; then
  log "GitLab already has release $TAG; nothing to do."
  exit 0
fi

# --- release metadata ---
REL_NAME="$(gh -R "$GH_REPO" release view "$TAG" --json name --jq '.name' 2>/dev/null)"
REL_BODY="$(gh -R "$GH_REPO" release view "$TAG" --json body --jq '.body' 2>/dev/null)"
[ -n "$REL_NAME" ] || REL_NAME="$TAG"

# --- work in a throwaway clone of GitLab ---
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
log "Cloning GitLab repo..."
git clone --quiet "$GITLAB_GIT_REMOTE" "$TMP/gitlab" \
  || { log "ERROR: git clone of GitLab failed."; exit 1; }
GL="$TMP/gitlab"

# --- mirror content (drop VCS + Claude tooling) ---
rsync -a --delete --exclude='.git/' --exclude='.claude/' "$SRC"/ "$GL"/

# --- re-apply GitLab branding across all tracked text files ---
python3 - "$GL" "$GH_INSTALL" "$GL_INSTALL" "$GH_NAME" "$GL_NAME" <<'PY'
import os, sys
root, gh_inst, gl_inst, gh_name, gl_name = sys.argv[1:6]
for dirpath, dirnames, filenames in os.walk(root):
    if '.git' in dirnames:
        dirnames.remove('.git')
    for fn in filenames:
        p = os.path.join(dirpath, fn)
        try:
            with open(p, encoding='utf-8') as fh:
                s = fh.read()
        except (UnicodeDecodeError, FileNotFoundError, IsADirectoryError, PermissionError):
            continue
        if gh_inst in s or gh_name in s:
            s = s.replace(gh_inst, gl_inst).replace(gh_name, gl_name)
            with open(p, 'w', encoding='utf-8') as fh:
                fh.write(s)
            print(f"  rebranded {os.path.relpath(p, root)}", file=sys.stderr)
PY

# rebrand the release notes the same way
REL_BODY_GL="$(printf '%s' "$REL_BODY" | python3 -c 'import sys
s=sys.stdin.read()
s=s.replace(sys.argv[1],sys.argv[2]).replace(sys.argv[3],sys.argv[4])
sys.stdout.write(s)' "$GH_INSTALL" "$GL_INSTALL" "$GH_NAME" "$GL_NAME")"

# --- commit ---
cd "$GL" || { log "ERROR: cannot enter clone."; exit 1; }
if [ -z "$(git config user.email)" ]; then
  git config user.email "release-sync@local"
  git config user.name "release-sync"
fi
git add -A
if git diff --cached --quiet; then
  log "No content changes after rebrand; creating release tag $TAG only."
else
  git commit -q -m "chore: sync content from GitHub for release $TAG

Mirrors the GitHub repo (source of truth) into this repo, preserving
snap-claude-plugins branding. Auto-generated by the release-sync hook."
fi

if [ "$DRY_RUN" = "1" ]; then
  log "DRY_RUN=1 -> would push main + tag $TAG + create release '$REL_NAME'. Stopping."
  git --no-pager log --oneline -2 >&2 || true
  exit 0
fi

# --- push main ---
git push -q origin main || { log "ERROR: push to GitLab main failed."; exit 1; }

# --- tag + push tag ---
if ! git rev-parse -q --verify "refs/tags/$TAG" >/dev/null; then
  git tag -a "$TAG" -m "$REL_NAME"
fi
git push -q origin "refs/tags/$TAG" || { log "ERROR: pushing tag $TAG failed."; exit 1; }

# --- GitLab release ---
NOTES_FILE="$TMP/notes.md"
printf '%s\n' "$REL_BODY_GL" > "$NOTES_FILE"
if glab release create "$TAG" -R "$GITLAB_PROJECT" --name "$REL_NAME" --notes-file "$NOTES_FILE" >/dev/null 2>&1; then
  log "✅ Mirrored release $TAG to GitLab ($GITLAB_PROJECT)."
else
  log "ERROR: 'glab release create $TAG' failed."
  exit 1
fi
exit 0
