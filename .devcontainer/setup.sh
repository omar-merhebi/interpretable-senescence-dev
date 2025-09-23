#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

EXT_FILE="${EXTENSIONS_FILE:-"$SCRIPT_DIR/extensions.txt"}"

log() { printf '[setup] %s\n' "$*"; }

install_extensions() {
  local installer=""
  for cmd in code code-server codium; do
    if command -v "$cmd" >/dev/null 2>&1; then
      installer="$cmd"
      break
    fi
  done

  if [[ -z "$installer" ]]; then
    log "VS Code CLI not found (code/code-server/codium). Skipping extension install."
    return 0
  fi

  if [[ ! -f "$EXT_FILE" ]]; then
    log "No extensions file found at: $EXT_FILE (skipping)."
    return 0
  fi

  # Filter: non-empty lines that don't start with '#'
  mapfile -t exts < <(grep -E '^[[:space:]]*[^#[:space:]][^#]*' "$EXT_FILE" | sed -E 's/^[[:space:]]+|[[:space:]]+$//g')

  if (( ${#exts[@]} == 0 )); then
    log "Extensions file is present but empty after filtering comments—nothing to install."
    return 0
  fi

  log "Installing ${#exts[@]} extension(s) from $EXT_FILE using '$installer'..."
  for ext in "${exts[@]}"; do
    if [[ -n "$ext" ]]; then
      # --force makes it idempotent across rebuilds; ignore failures to keep the script resilient
      "$installer" --install-extension "$ext" --force || log "Failed to install: $ext (continuing)"
    fi
  done
}

if [[ -n "${GIT_NAME:-}" ]]; then
    git config --global user.name "$GIT_NAME"
fi

if [[ -n "${GIT_EMAIL:-}" ]]; then
    git config --global user.email "$GIT_EMAIL"
fi

python3 -m pip install --upgrade pip 
cat ../requirements.txt | xargs -n 1 pip install

log "Setup complete"