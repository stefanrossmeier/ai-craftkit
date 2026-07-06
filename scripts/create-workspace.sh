#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(pwd)"
ROOT_NAME="$(basename "$ROOT_DIR")"

# Create a safe workspace filename from the current folder name
SAFE_NAME="$(printf '%s' "$ROOT_NAME" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9._-]+/-/g; s/^-+//; s/-+$//')"

if [[ -z "$SAFE_NAME" ]]; then
  SAFE_NAME="workspace"
fi

WORKSPACE_FILE="${ROOT_DIR}/${SAFE_NAME}.code-workspace"

# Create VS Code workspace JSON.
# It includes all direct child directories of the current folder.
# It does not include "." as a workspace folder.
python3 - "$ROOT_DIR" "$WORKSPACE_FILE" <<'PY'
import json
import os
import sys
from pathlib import Path

root = Path(sys.argv[1])
workspace_file = Path(sys.argv[2])

folders = []

for entry in sorted(root.iterdir(), key=lambda p: p.name.lower()):
    if not entry.is_dir():
        continue

    # Keep this conservative. Remove this block if you really want .git as a workspace folder.
    if entry.name == ".git":
        continue

    folders.append({
        "path": entry.name
    })

workspace = {
    "folders": folders,
    "settings": {}
}

workspace_file.write_text(
    json.dumps(workspace, indent=2, ensure_ascii=False) + "\n",
    encoding="utf-8"
)
PY

echo "Created: $WORKSPACE_FILE"
