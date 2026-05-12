#!/usr/bin/env bash
# =====================================================
# setup_ish.sh
# Cài lệnh tắt cho ish_lang_nghiem trên iSH iPhone
# Mục tiêu:
# - Mở iSH lên là dùng được: ln 3
# - Repo mặc định: ~/ish_lang_nghiem
# =====================================================

set -e

REPO_DIR="$HOME/ish_lang_nghiem"

echo "🔧 Cài đặt ish_lang_nghiem cho iSH..."
echo "Repo: $REPO_DIR"

# -----------------------------------------------------
# 1) Bảo đảm có bash và git
# -----------------------------------------------------

if ! command -v bash >/dev/null 2>&1; then
  echo "⚠️ Chưa có bash. Đang cài bash..."
  apk add bash
fi

if ! command -v git >/dev/null 2>&1; then
  echo "⚠️ Chưa có git. Đang cài git..."
  apk add git
fi

# -----------------------------------------------------
# 2) Kiểm tra repo và file chính
# -----------------------------------------------------

if [[ ! -d "$REPO_DIR" ]]; then
  echo "❌ Không thấy repo: $REPO_DIR"
  echo "👉 Hãy clone trước:"
  echo "cd ~"
  echo "git clone https://github.com/bsliem/ish_lang_nghiem.git"
  exit 1
fi

if [[ ! -f "$REPO_DIR/ln_lang_nghiem.bash" ]]; then
  echo "❌ Không thấy file: $REPO_DIR/ln_lang_nghiem.bash"
  exit 1
fi

if [[ ! -f "$REPO_DIR/lang_nghiem.md" ]]; then
  echo "❌ Không thấy file: $REPO_DIR/lang_nghiem.md"
  exit 1
fi

# -----------------------------------------------------
# 3) Backup cấu hình cũ
# -----------------------------------------------------

cp "$HOME/.profile" "$HOME/.profile.bak" 2>/dev/null || true
cp "$HOME/.bashrc" "$HOME/.bashrc.bak" 2>/dev/null || true

echo "✅ Đã backup ~/.profile và ~/.bashrc nếu có"

# -----------------------------------------------------
# 4) Tạo ~/.bashrc sạch cho iSH
# -----------------------------------------------------

cat > "$HOME/.bashrc" <<'EOF'
# =====================================================
# ~/.bashrc - iSH
# Auto setup ish_lang_nghiem
# =====================================================

export ISH_LANG_NGHIEM_REPO="$HOME/ish_lang_nghiem"

ln() {
  bash "$ISH_LANG_NGHIEM_REPO/ln_lang_nghiem.bash" "$@"
}

lnk() {
  bash "$ISH_LANG_NGHIEM_REPO/ln_lang_nghiem.bash" lnk "$@"
}

# Gợi ý ngắn khi mở shell
echo "ish_lang_nghiem repo: $ISH_LANG_NGHIEM_REPO"
echo 'Use: ln 3 | ln 0* | ln 1* | lnk "tát đát"'
EOF

echo "✅ Đã tạo ~/.bashrc sạch"

# -----------------------------------------------------
# 5) Tạo ~/.profile để iSH tự nạp ~/.bashrc mỗi lần mở
# -----------------------------------------------------

cat > "$HOME/.profile" <<'EOF'
# =====================================================
# ~/.profile - iSH auto load bashrc
# =====================================================

if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
EOF

echo "✅ Đã tạo ~/.profile tự nạp ~/.bashrc"

# -----------------------------------------------------
# 6) Nạp ngay trong phiên hiện tại
# -----------------------------------------------------

. "$HOME/.profile"

# -----------------------------------------------------
# 7) Kiểm tra
# -----------------------------------------------------

echo
echo "🔎 Kiểm tra lệnh ln:"
type ln

echo
echo "✅ Cài xong iSH."
echo "👉 Từ lần sau mở iSH, chỉ cần:"
echo "cd ~/ish_lang_nghiem"
echo "ln 3"

echo
echo "🧪 Test nhanh:"
ln 3