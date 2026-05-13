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
#   db b6       -> block 6: câu 73 đến 84
# =====================================================

# ---------- màu sắc ----------
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"

WHITE="\033[37m"
BRIGHT_WHITE="\033[97m"
BRIGHT_GREEN="\033[92m"
BRIGHT_YELLOW="\033[93m"
BRIGHT_BLUE="\033[94m"
BRIGHT_MAGENTA="\033[95m"
BRIGHT_CYAN="\033[96m"
GRAY="\033[90m"

# ---------- nhận diện repo ----------
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

# ---------- xử lý tham số ----------
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
  echo "  db b6"
  exit 1
fi

# ---------- giới hạn ----------
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

# ---------- header ----------
clear
printf "${BRIGHT_MAGENTA}${BOLD}🙏 TỤNG CHÚ ĐẠI BI${RESET}\n"
printf "${DIM}File:${RESET} ${BRIGHT_CYAN}%s${RESET}\n" "$DATA_FILE"
printf "${DIM}Từ câu:${RESET} ${BRIGHT_YELLOW}%s → %s${RESET}\n" "$START" "$END"
printf "${DIM}Block:${RESET} ${BRIGHT_GREEN}%s${RESET}\n" "$BLOCK_LABEL"
printf "${DIM}⏳ Tự động sau ${DELAY}s | Phím bất kỳ: câu kế | q/ESC: thoát${RESET}\n"
printf "${BRIGHT_BLUE}--------------------------------------------------${RESET}\n"

# ---------- tụng từng câu ----------
grep -E '^[[:space:]]*[0-9]+\.' "$DATA_FILE" |
awk -v s="$START" -v e="$END" '
{
  idx++
  line=$0
  gsub(/^[[:space:]]*/, "", line)
  sub(/^[0-9]+\.[[:space:]]*/, "", line)

  if (idx >= s && idx <= e) {
    printf "%02d|%s\n", idx, line
  }
}
' |
while IFS='|' read -r num content; do

  viet="$content"
  han=""
  is_block_start=0

  case "$content" in
    *"#"*)
      viet="${content%%#*}"
      han="${content#*#}"
      ;;
  esac

  viet="$(echo "$viet" | sed 's/[[:space:]]*$//')"
  han="$(echo "$han" | sed 's/^[[:space:]]*//')"

  # Nếu có dấu % đầu dòng thì chỉ xem là bắt đầu block
  if echo "$viet" | grep -q '^%'; then
    is_block_start=1
    viet="$(echo "$viet" | sed 's/^%//')"
  fi

  if [ "$is_block_start" -eq 1 ]; then
    printf "\n${BRIGHT_BLUE}--------------------------------------------------${RESET}\n"
  fi

  # Số câu vàng, tiếng Việt trắng, chữ Hán tím
  printf "${BRIGHT_YELLOW}%s.${RESET} ${BRIGHT_WHITE}%s${RESET}" "$num" "$viet"

  if [ -n "$han" ]; then
    printf " ${GRAY}#${RESET} ${BRIGHT_MAGENTA}%s${RESET}" "$han"
  fi

  printf "\n"

  key=""
  if [ -r /dev/tty ]; then
    read -rsn1 -t "$DELAY" key < /dev/tty
  else
    sleep "$DELAY"
  fi

  if [ "$key" = "q" ]; then
    echo
    printf "${BRIGHT_MAGENTA}🙏 Dừng tụng.${RESET}\n"
    printf "${BRIGHT_CYAN}Nam Mô Đại Bi Quán Thế Âm Bồ Tát.${RESET}\n"
    exit 0
  fi

  if [ "$key" = $'\e' ]; then
    echo
    printf "${BRIGHT_MAGENTA}🙏 Dừng tụng.${RESET}\n"
    printf "${BRIGHT_CYAN}Nam Mô Đại Bi Quán Thế Âm Bồ Tát.${RESET}\n"
    exit 0
  fi
done

echo
printf "${BRIGHT_BLUE}--------------------------------------------------${RESET}\n"
printf "${BRIGHT_MAGENTA}${BOLD}🙏 Hết đoạn.${RESET}\n"
printf "${BRIGHT_CYAN}${BOLD}Nam Mô Đại Bi Quán Thế Âm Bồ Tát.${RESET}\n"