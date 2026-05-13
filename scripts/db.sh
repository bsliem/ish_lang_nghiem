#!/usr/bin/env bash

# =====================================================
# db.sh
# Tụng Chú Đại Bi từ file dai_bi.md
# Dùng được trên Mac và iSH
#
# Usage:
#   db          -> tụng toàn bộ
#   db 1        -> câu 1 đến 12
#   db 13       -> câu 13 đến 24
#   db 13 24    -> câu 13 đến 24
#   db b0       -> block 0: câu 1 đến 12
#   db b1       -> block 1: câu 13 đến 24
#   db b2       -> block 2: câu 25 đến 36
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

DATA_FILE="$REPO_DIR/dai_bi.md"
BLOCK_SIZE=12
DELAY=3

if [ ! -f "$DATA_FILE" ]; then
  echo "Không tìm thấy file:"
  echo "$DATA_FILE"
  exit 1
fi

TOTAL_LINES="$(
  grep -E '^[[:space:]]*[0-9]+\.' "$DATA_FILE" | wc -l | tr -d ' '
)"

if [ "$TOTAL_LINES" -eq 0 ]; then
  echo "Không tìm thấy câu đánh số trong file:"
  echo "$DATA_FILE"
  exit 1
fi

ARG1="${1:-}"
ARG2="${2:-}"

if [ -z "$ARG1" ]; then
  START=1
  END="$TOTAL_LINES"
  BLOCK_LABEL="all"

elif [[ "$ARG1" =~ ^b[0-9]+$ ]]; then
  BLOCK_NUM="${ARG1#b}"
  START=$(( BLOCK_NUM * BLOCK_SIZE + 1 ))
  END=$(( START + BLOCK_SIZE - 1 ))
  BLOCK_LABEL="$ARG1"

elif [[ "$ARG1" =~ ^[0-9]+$ ]] && [ -z "$ARG2" ]; then
  START="$ARG1"
  END=$(( START + BLOCK_SIZE - 1 ))
  BLOCK_LABEL="${START}-${END}"

elif [[ "$ARG1" =~ ^[0-9]+$ ]] && [[ "$ARG2" =~ ^[0-9]+$ ]]; then
  START="$ARG1"
  END="$ARG2"
  BLOCK_LABEL="${START}-${END}"

else
  echo "Cách dùng:"
  echo "  db"
  echo "  db 1"
  echo "  db 13"
  echo "  db 13 24"
  echo "  db b0"
  echo "  db b1"
  exit 1
fi

if [ "$START" -lt 1 ]; then
  START=1
fi

if [ "$END" -gt "$TOTAL_LINES" ]; then
  END="$TOTAL_LINES"
fi

if [ "$START" -gt "$TOTAL_LINES" ]; then
  echo "Câu bắt đầu vượt quá tổng số câu."
  echo "Tổng số câu hiện có: $TOTAL_LINES"
  exit 1
fi

clear
echo "🙏 TỤNG CHÚ ĐẠI BI"
echo "File: $DATA_FILE"
echo "Từ câu: $START → $END"
echo "Block: $BLOCK_LABEL"
echo "⏳ Tự động sau ${DELAY}s | Phím bất kỳ: câu kế | q/ESC: thoát"
echo "----------------------------------------"

grep -E '^[[:space:]]*[0-9]+\.' "$DATA_FILE" |
awk -v s="$START" -v e="$END" '
{
  line=$0
  gsub(/^[[:space:]]*/, "", line)
  num=line
  sub(/\..*$/, "", num)
  if (num >= s && num <= e) print line
}
' |
while IFS= read -r line; do
  echo "$line"

  read -rsn1 -t "$DELAY" key

  if [ "$key" = "q" ]; then
    echo
    echo "🙏 Dừng tụng."
    echo "Nam Mô Đại Bi Quán Thế Âm Bồ Tát."
    exit 0
  fi

  if [ "$key" = $'\e' ]; then
    echo
    echo "🙏 Dừng tụng."
    echo "Nam Mô Đại Bi Quán Thế Âm Bồ Tát."
    exit 0
  fi
done

echo
echo "🙏 Hết đoạn."
echo "Nam Mô Đại Bi Quán Thế Âm Bồ Tát."