#!/usr/bin/env bash

# =====================================================
# setup_db.sh
# Cài lệnh db thật vào ~/.local/bin/db
# Dùng được trên Mac và iSH
# =====================================================

if [ -d "$HOME/Documents/ish_lang_nghiem" ]; then
  REPO_DIR="$HOME/Documents/ish_lang_nghiem"
elif [ -d "$HOME/ish_lang_nghiem" ]; then
  REPO_DIR="$HOME/ish_lang_nghiem"
else
  echo "Không tìm thấy repo ish_lang_nghiem."
  echo "Mac: ~/Documents/ish_lang_nghiem"
  echo "iSH: ~/ish_lang_nghiem"
  exit 1
fi

DB_SCRIPT="$REPO_DIR/scripts/db.sh"

if [ ! -f "$DB_SCRIPT" ]; then
  echo "Không tìm thấy script:"
  echo "$DB_SCRIPT"
  exit 1
fi

chmod +x "$DB_SCRIPT"

mkdir -p "$HOME/.local/bin"

cat > "$HOME/.local/bin/db" <<EOF
#!/usr/bin/env bash
bash "$DB_SCRIPT" "\$@"
EOF

chmod +x "$HOME/.local/bin/db"

if [ -n "$ZSH_VERSION" ] || [ "$(basename "$SHELL")" = "zsh" ]; then
  RC_FILE="$HOME/.zshrc"
else
  RC_FILE="$HOME/.bashrc"
fi

if grep -qi "alpine" /etc/os-release 2>/dev/null; then
  RC_FILE="$HOME/.bashrc"
fi

touch "$RC_FILE"

if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$RC_FILE"; then
  cat >> "$RC_FILE" <<'EOF'

# ~/.local/bin for personal commands
export PATH="$HOME/.local/bin:$PATH"
EOF
fi

echo "Đã cài lệnh db:"
echo "  $HOME/.local/bin/db"
echo
echo "Nạp lại bằng:"
echo "  source $RC_FILE"
echo
echo "Test:"
echo "  db b0"