#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

EXT_FILE="${EXTENSIONS_FILE:-"/workspace/.devcontainer/extensions.txt"}"

log() { printf '[setup] %s\n' "$*"; }


if [[ -n "${GIT_NAME:-}" ]]; then
    git config --global user.name "$GIT_NAME"
fi

if [[ -n "${GIT_EMAIL:-}" ]]; then
    git config --global user.email "$GIT_EMAIL"
fi

log "Working dir: $(pwd)"

python3 -m pip install --upgrade pip 
cat /workspace/requirements.txt | xargs -n 1 pip install
log "Setup complete"