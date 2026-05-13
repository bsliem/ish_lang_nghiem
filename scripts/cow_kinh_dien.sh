#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
FORTUNE_FILE="$REPO_DIR/data/fortune_kinh_dien.txt"

if [ ! -f "$FORTUNE_FILE" ]; then
  echo "Không tìm thấy file:"
  echo "$FORTUNE_FILE"
  exit 1
fi

COUNT=$(grep -cve "^[[:space:]]*$" "$FORTUNE_FILE")

if [ "$COUNT" -eq 0 ]; then
  echo "File fortune đang rỗng."
  exit 1
fi

N=$(( (RANDOM % COUNT) + 1 ))
QUOTE=$(grep -ve "^[[:space:]]*$" "$FORTUNE_FILE" | sed -n "${N}p")

if command -v cowsay >/dev/null 2>&1; then
  echo "$QUOTE" | cowsay
else
  echo "=============================="
  echo "$QUOTE"
  echo "=============================="
fi