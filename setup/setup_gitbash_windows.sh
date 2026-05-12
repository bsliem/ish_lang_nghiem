#!/usr/bin/env bash
# =====================================================
# setup_gitbash_windows.sh
# Cài lệnh tắt cho ish_lang_nghiem trên Git Bash Windows
# Repo mặc định: ~/Documents/ish_lang_nghiem
# =====================================================

set -e

REPO_DIR="$HOME/Documents/ish_lang_nghiem"
BASHRC="$HOME/.bashrc"

echo "🔧 Cài đặt ish_lang_nghiem cho Git Bash Windows..."
echo "Repo: $REPO_DIR"

if [[ ! -f "$REPO_DIR/ln_lang_nghiem.bash" ]]; then
  echo "❌ Không thấy file: $REPO_DIR/ln_lang_nghiem.bash"
  echo "👉 Nếu repo nằm chỗ khác, sửa REPO_DIR trong file setup này."
  exit 1
fi

cat >> "$BASHRC" <<'EOF'

# =====================================================
# ish_lang_nghiem helper - Git Bash Windows
# =====================================================
export ISH_LANG_NGHIEM_REPO="$HOME/Documents/ish_lang_nghiem"

ln() {
  bash "$ISH_LANG_NGHIEM_REPO/ln_lang_nghiem.bash" "$@"
}

lnk() {
  bash "$ISH_LANG_NGHIEM_REPO/ln_lang_nghiem.bash" lnk "$@"
}

add() {
  bash "$ISH_LANG_NGHIEM_REPO/add_a_di_da.bash" "$@"
}

EOF

echo "✅ Đã thêm lệnh tắt vào ~/.bashrc"
echo "👉 Chạy tiếp:"
echo "source ~/.bashrc"
echo ""
echo "Thử:"
echo "ln 3"
echo "ln 0*"
echo "lnk \"tát đát\""

