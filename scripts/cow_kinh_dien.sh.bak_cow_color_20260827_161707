#!/usr/bin/env bash

# =====================================================
# cow_kinh_dien.sh
# Bò đọc danh ngôn kinh điển
# Không phụ thuộc cowsay bên ngoài
# Dùng được trên Mac / Windows Git Bash / iSH
# =====================================================

# Nhận diện repo
if [ -d "$HOME/Documents/ish_lang_nghiem" ]; then
  REPO_DIR="$HOME/Documents/ish_lang_nghiem"
elif [ -d "$HOME/ish_lang_nghiem" ]; then
  REPO_DIR="$HOME/ish_lang_nghiem"
elif [ -d "/d/ish_lang_nghiem" ]; then
  REPO_DIR="/d/ish_lang_nghiem"
else
  REPO_DIR="$(pwd)"
fi

FORTUNE_FILE="$REPO_DIR/data/fortune_kinh_dien.txt"

if [ ! -f "$FORTUNE_FILE" ]; then
  echo "Không tìm thấy file fortune:"
  echo "$FORTUNE_FILE"
  exit 1
fi

# Lấy ngẫu nhiên 1 dòng không rỗng
QUOTE="$(
  awk 'NF { lines[++n]=$0 } END { if (n>0) { srand(); print lines[int(rand()*n)+1] } }' "$FORTUNE_FILE"
)"

if [ -z "$QUOTE" ]; then
  echo "File fortune đang rỗng."
  exit 1
fi

# Bò ASCII tự chế, không dùng cowsay ngoài
echo " ______________________________"
echo "< $QUOTE >"
echo " ------------------------------"
echo "        \\   ^__^"
echo "         \\  (oo)\\_______"
echo "            (__)\\       )\\/\\"
echo "                ||----w |"
echo "                ||     ||"
