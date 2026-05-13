#!/usr/bin/env bash

# =====================================================
# setup_gp.sh
# Cài lệnh gp thật vào ~/.local/bin/gp
# Dùng chung cho MacBook, Windows Git Bash, iSH
# =====================================================

set -u

# ---- Nhận diện repo ----
if [ -d "$HOME/Documents/ish_lang_nghiem" ]; then
  REPO_DIR="$HOME/Documents/ish_lang_nghiem"
elif [ -d "$HOME/ish_lang_nghiem" ]; then
  REPO_DIR="$HOME/ish_lang_nghiem"
elif git rev-parse --show-toplevel >/dev/null 2>&1; then
  REPO_DIR="$(git rev-parse --show-toplevel)"
else
  echo "❌ Không tìm thấy repo ish_lang_nghiem."
  echo "Hãy cd vào repo trước, ví dụ:"
  echo "  cd ~/Documents/ish_lang_nghiem"
  echo "  cd ~/ish_lang_nghiem"
  exit 1
fi

GP_SCRIPT="$REPO_DIR/scripts/gp.sh"

if [ ! -f "$GP_SCRIPT" ]; then
  echo "❌ Không tìm thấy:"
  echo "$GP_SCRIPT"
  exit 1
fi

chmod +x "$GP_SCRIPT"

# ---- Tạo ~/.local/bin ----
mkdir -p "$HOME/.local/bin"

# ---- Tạo lệnh thật gp ----
cat > "$HOME/.local/bin/gp" <<EOF
#!/usr/bin/env bash
bash "$GP_SCRIPT" "\$@"
EOF

chmod +x "$HOME/.local/bin/gp"

# ---- Chọn file cấu hình shell ----
UNAME_S="$(uname -s)"

case "$UNAME_S" in
  Darwin*)
    RC_FILE="$HOME/.zshrc"
    DEFAULT_DEVICE="mac"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    RC_FILE="$HOME/.bashrc"
    DEFAULT_DEVICE="win"
    ;;
  Linux*)
    RC_FILE="$HOME/.bashrc"
    if grep -qi "alpine" /etc/os-release 2>/dev/null; then
      DEFAULT_DEVICE="ish"
    else
      DEFAULT_DEVICE="linux"
    fi
    ;;
  *)
    RC_FILE="$HOME/.bashrc"
    DEFAULT_DEVICE="unknown"
    ;;
esac

touch "$RC_FILE"

# ---- Thêm PATH nếu chưa có ----
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$RC_FILE"; then
  cat >> "$RC_FILE" <<'EOF'

# ~/.local/bin for personal commands
export PATH="$HOME/.local/bin:$PATH"
EOF
fi

# ---- Nếu chưa có device file thì tạo mặc định ----
DEVICE_FILE="$HOME/.ish_device_name"

if [ ! -f "$DEVICE_FILE" ]; then
  echo "$DEFAULT_DEVICE" > "$DEVICE_FILE"
fi

echo "✅ Đã cài lệnh gp:"
echo "  $HOME/.local/bin/gp"
echo
echo "Repo:"
echo "  $REPO_DIR"
echo
echo "Device hiện tại:"
echo "  $(cat "$DEVICE_FILE")"
echo
echo "Đã cập nhật PATH trong:"
echo "  $RC_FILE"
echo
echo "Nạp lại:"
echo "  source $RC_FILE"
echo
echo "Dùng:"
echo "  gp"
echo "  gp \"message\""
echo
echo "Đổi tên máy nếu cần:"
echo "  echo \"ip-1\" > ~/.ish_device_name   # iPhone 14 Pro Max"
echo "  echo \"ip-2\" > ~/.ish_device_name   # iPhone XS"
echo "  echo \"mac\"  > ~/.ish_device_name   # MacBook"
echo "  echo \"win\"  > ~/.ish_device_name   # Windows"