#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"

echo "📦 Installing ish_lang_nghiem..."
mkdir -p "$BIN_DIR"

ln -sf "$ROOT/ln.sh"  "$BIN_DIR/lng"
ln -sf "$ROOT/lnk.sh" "$BIN_DIR/lngk"
ln -sf "$ROOT/db.sh"  "$BIN_DIR/db"

chmod +x "$ROOT/ln.sh" "$ROOT/lnk.sh" "$ROOT/db.sh" 2>/dev/null || true

RC_FILE="$HOME/.bashrc"
if [[ -n "${ZSH_VERSION:-}" ]] || [[ "${SHELL:-}" == *"zsh"* ]]; then
  RC_FILE="$HOME/.zshrc"
fi

if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo "" >> "$RC_FILE"
  echo '# ish_lang_nghiem' >> "$RC_FILE"
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$RC_FILE"
  echo "👉 PATH updated in: $RC_FILE"
  echo "   Restart terminal or run: source \"$RC_FILE\""
fi

echo "✅ Installed: lng, lngk, db"
echo "✨ Done."