#!/usr/bin/env bash

# >>> COLOR FOR c >>>
_C_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$_C_DIR/colorize_c.bash"
# <<< COLOR FOR c <<<


# >>> RANDOM COW COLOR >>>
_cow_reset=$'\033[0m'
_cow_colors=(
  $'\033[91m'
  $'\033[92m'
  $'\033[93m'
  $'\033[94m'
  $'\033[95m'
  $'\033[96m'
)

_cow_random_color() {
  local n=${#_cow_colors[@]}
  local idx=$(( RANDOM % n ))
  printf '%s' "${_cow_colors[$idx]}"
}
# <<< RANDOM COW COLOR <<<


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


# =====================================================
# SMART WORD-WRAP cho Mac / iSH / Windows Git Bash
# - tự nhận chiều rộng Terminal
# - không cắt ngang từ
# - chừa mép phải 4 cột
# =====================================================

_c_term_cols() {
  local cols=''

  if [[ -r /dev/tty ]]; then
    cols="$(stty size < /dev/tty 2>/dev/null | awk '{print $2}')"
  fi

  [[ "$cols" =~ ^[0-9]+$ ]] || cols="${COLUMNS:-80}"
  [[ "$cols" =~ ^[0-9]+$ ]] || cols=80

  # chừa mép phải để Terminal không wrap cứng
  cols=$(( cols - 4 ))

  (( cols < 32 )) && cols=32

  printf '%s' "$cols"
}


_c_wrap_quote() {
  local text="$1"
  local width="$2"

  local word line=''
  local -a words=()

  read -r -a words <<< "$text"

  for word in "${words[@]}"; do

    if [[ -z "$line" ]]; then
      line="$word"

    elif (( ${#line} + 1 + ${#word} <= width )); then
      line="$line $word"

    else
      printf '%s\n' "$line"
      line="$word"
    fi

  done

  [[ -n "$line" ]] && printf '%s\n' "$line"
}


_c_print_quote() {
  local cols width
  local head rest
  local han_nghia sanskrit devanagari han_am english
  local num viet
  local line wrapped
  local -a qlines=()
  local i last

  cols="$(_c_term_cols)"
  width=$(( cols - 4 ))
  (( width < 24 )) && width=24

  # ========================================
  # Tách phần trước và sau dấu #
  # ========================================
  if [[ "$QUOTE" == *"#"* ]]; then
    head="${QUOTE%%#*}"
    rest="${QUOTE#*#}"
  else
    head="$QUOTE"
    rest=""
  fi

  head="$(_cc_trim "$head")"
  rest="$(_cc_trim "$rest")"

  # ========================================
  # Tách số câu + Hán-Việt
  # ========================================
  if [[ "$head" =~ ^([0-9]+)\.[[:space:]]*(.*)$ ]]; then
    num="${BASH_REMATCH[1]}"
    viet="${BASH_REMATCH[2]}"
  else
    num=""
    viet="$head"
  fi

  viet="$(_cc_trim "$viet")"

  # ========================================
  # Tách metadata + English
  # ========================================
  IFS='|' read -r \
    han_nghia \
    sanskrit \
    devanagari \
    han_am \
    english <<< "$rest"

  han_nghia="$(_cc_trim "${han_nghia:-}")"
  sanskrit="$(_cc_trim "${sanskrit:-}")"
  devanagari="$(_cc_trim "${devanagari:-}")"
  han_am="$(_cc_trim "${han_am:-}")"
  english="$(_cc_trim "${english:-}")"

  # ========================================
  # DÒNG 1: < số + Hán-Việt
  # ========================================
  printf "%s<%s " "$_cc_gray" "$_cc_reset"

  if [[ -n "$num" ]]; then
    printf "%s%s.%s " \
      "$_cc_gray" "$num" "$_cc_reset"
  fi

  printf "%s%s%s%s\n" \
    "$_cc_bold" "$_cc_green" "$viet" "$_cc_reset"

  # ========================================
  # DÒNG 2: metadata có màu
  # ========================================
  printf "  %s#%s" "$_cc_gray" "$_cc_reset"

  if [[ -n "$han_nghia" ]]; then
    printf " %s%s%s%s" \
      "$_cc_bold" "$_cc_purple" "$han_nghia" "$_cc_reset"
  fi

  if [[ -n "$sanskrit" ]]; then
    printf " %s|%s %s%s%s%s" \
      "$_cc_gray" "$_cc_reset" \
      "$_cc_bold" "$_cc_red" "$sanskrit" "$_cc_reset"
  fi

  if [[ -n "$devanagari" ]]; then
    printf " %s|%s %s%s%s%s" \
      "$_cc_gray" "$_cc_reset" \
      "$_cc_bold" "$_cc_yellow" "$devanagari" "$_cc_reset"
  fi

  if [[ -n "$han_am" ]]; then
    printf " %s|%s %s%s%s%s" \
      "$_cc_gray" "$_cc_reset" \
      "$_cc_bold" "$_cc_cyan" "$han_am" "$_cc_reset"
  fi

  printf "\n"

  # ========================================
  # English: wrap riêng, màu trắng
  # KHÔNG dùng process substitution
  # ========================================
  if [[ -n "$english" ]]; then
    qlines=()

    wrapped="$(_c_wrap_quote "$english" "$width")"

    while IFS= read -r line; do
      [[ -n "$line" ]] && qlines+=("$line")
    done <<< "$wrapped"

    last=$(( ${#qlines[@]} - 1 ))

    for (( i=0; i<=last; i++ )); do
      printf "  %s%s%s" \
        "$_cc_english" "${qlines[$i]}" "$_cc_reset"

      if (( i == last )); then
        printf " %s>%s" "$_cc_gray" "$_cc_reset"
      fi

      printf "\n"
    done
  else
    printf "  %s>%s\n" "$_cc_gray" "$_cc_reset"
  fi
}

# Bò ASCII tự chế, không dùng cowsay ngoài
echo " ______________________________"
_c_print_quote
echo " ------------------------------"
cow_color="$(_cow_random_color)"
printf "%s" "$cow_color"
echo "        \\   ^__^"
echo "         \\  (oo)\\_______"
echo "            (__)\\       )\\/\\"
echo "                ||----w |"
echo "                ||     ||"
printf "%s" "$_cow_reset"
echo "                ||     ||"
