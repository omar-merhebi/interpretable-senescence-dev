#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

EXT_FILE="${EXTENSIONS_FILE:-"/workspace/.devcontainer/extensions.txt"}"

log() { printf '[setup] %s\n' "$*"; }

if [[ -n "${GIT_NAME:-}" ]]; then
    git config --global user.name "$GIT_NAME"
    log "Git username set as $GIT_NAME"
else
    log "No git username env variable found, skipping setting git username..."
fi

if [[ -n "${GIT_EMAIL:-}" ]]; then
    git config --global user.email "$GIT_EMAIL"
    log "Git Email set as $GIT_EMAIL"
else
    log "No git email env variable found, skipping setting git email..."
fi