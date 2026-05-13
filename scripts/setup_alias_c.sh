#!/usr/bin/env bash

# =====================================================
# setup_alias_c.sh
# Tạo alias c / ckd / bo / kinh cho Mac và iSH
# =====================================================

# Tự nhận diện repo
if [ -d "$HOME/Documents/ish_lang_nghiem" ]; then
  REPO_DIR="$HOME/Documents/ish_lang_nghiem"   # Mac
elif [ -d "$HOME/ish_lang_nghiem" ]; then
  REPO_DIR="$HOME/ish_lang_nghiem"             # iSH
else
  echo "Không tìm thấy repo ish_lang_nghiem."
  echo "Kiểm tra lại thư mục:"
  echo "  Mac: ~/Documents/ish_lang_nghiem"
  echo "  iSH: ~/ish_lang_nghiem"
  exit 1
fi

COW_SCRIPT="$REPO_DIR/scripts/cow_kinh_dien.sh"

if [ ! -f "$COW_SCRIPT" ]; then
  echo "Không tìm thấy script:"
  echo "$COW_SCRIPT"
  exit 1
fi

chmod +x "$COW_SCRIPT"

# Chọn file shell config
if [ -n "$ZSH_VERSION" ] || [ "$(basename "$SHELL")" = "zsh" ]; then
  RC_FILE="$HOME/.zshrc"
else
  RC_FILE="$HOME/.bashrc"
fi

# Với iSH thường dùng bash/ash, ưu tiên .bashrc
if grep -qi "alpine" /etc/os-release 2>/dev/null; then
  RC_FILE="$HOME/.bashrc"
fi

# Xóa block alias cũ nếu có
if [ -f "$RC_FILE" ]; then
  sed -i.bak '/# >>> ish_lang_nghiem aliases >>>/,/# <<< ish_lang_nghiem aliases <<</d' "$RC_FILE"
fi

# Ghi block alias mới
cat >> "$RC_FILE" <<EOF

# >>> ish_lang_nghiem aliases >>>
alias c='bash "$COW_SCRIPT"'
alias ckd='bash "$COW_SCRIPT"'
alias bo='bash "$COW_SCRIPT"'
alias kinh='bash "$COW_SCRIPT"'
# <<< ish_lang_nghiem aliases <<<
EOF

echo "Đã thêm alias vào: $RC_FILE"
echo "Các lệnh dùng được:"
echo "  c"
echo "  ckd"
echo "  bo"
echo "  kinh"
echo
echo "Nạp lại bằng:"
echo "  source $RC_FILE"