#!/usr/bin/env bash
# =====================================================
# setup_mac.sh
# Cài lệnh tắt cho ish_lang_nghiem trên Mac
# Repo mặc định: ~/Documents/ish_lang_nghiem
# =====================================================

set -e

REPO_DIR="$HOME/Documents/ish_lang_nghiem"
ZSHRC="$HOME/.zshrc"

echo "🔧 Cài đặt ish_lang_nghiem cho Mac..."
echo "Repo: $REPO_DIR"

if [[ ! -f "$REPO_DIR/ln_lang_nghiem.bash" ]]; then
  echo "❌ Không thấy file: $REPO_DIR/ln_lang_nghiem.bash"
  exit 1
fi

cat >> "$ZSHRC" <<'EOF'

# =====================================================
# ish_lang_nghiem helper - Mac - zsh safe
# =====================================================
export ISH_LANG_NGHIEM_REPO="$HOME/Documents/ish_lang_nghiem"

_ln_lang_nghiem() {
  bash "$ISH_LANG_NGHIEM_REPO/ln_lang_nghiem.bash" "$@"
}

_lnk_lang_nghiem() {
  bash "$ISH_LANG_NGHIEM_REPO/ln_lang_nghiem.bash" lnk "$@"
}

alias ln='noglob _ln_lang_nghiem'
alias lnk='_lnk_lang_nghiem'

EOF

echo "✅ Đã thêm lệnh tắt vào ~/.zshrc"
echo "👉 Chạy tiếp: source ~/.zshrc"
echo "Thử: ln 3 | ln 0* | lnk \"tát đát\""
