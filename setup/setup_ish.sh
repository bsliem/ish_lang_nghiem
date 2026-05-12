#!/usr/bin/env bash
# =====================================================
# setup_ish.sh
# Cài lệnh tắt cho ish_lang_nghiem trên iSH iPhone
# Repo mặc định: ~/ish_lang_nghiem
# =====================================================

set -e

REPO_DIR="$HOME/ish_lang_nghiem"
BASHRC="$HOME/.bashrc"

echo "🔧 Cài đặt ish_lang_nghiem cho iSH..."
echo "Repo: $REPO_DIR"

if ! command -v bash >/dev/null 2>&1; then
  echo "⚠️ Chưa có bash. Đang cài bash..."
  apk add bash
fi

if ! command -v git >/dev/null 2>&1; then
  echo "⚠️ Chưa có git. Đang cài git..."
  apk add git
fi

if [[ ! -f "$REPO_DIR/ln_lang_nghiem.bash" ]]; then
  echo "❌ Không thấy file: $REPO_DIR/ln_lang_nghiem.bash"
  echo "👉 Kiểm tra repo có nằm ở ~/ish_lang_nghiem không."
  exit 1
fi

cat >> "$BASHRC" <<'EOF'

# =====================================================
# ish_lang_nghiem helper - iSH
# =====================================================
export ISH_LANG_NGHIEM_REPO="$HOME/ish_lang_nghiem"

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

