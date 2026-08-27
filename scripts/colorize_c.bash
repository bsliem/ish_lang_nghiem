#!/usr/bin/env bash

# ==========================================================
# COLORIZER RIÊNG CHO LỆNH c
#
# Hán-Việt    xanh lá
# Hán nghĩa   tím
# Sanskrit    đỏ
# Devanagari  vàng
# Hán âm      cyan
# English     xám sáng
# ==========================================================

_cc_reset=$'\033[0m'
_cc_bold=$'\033[1m'
_cc_gray=$'\033[90m'
_cc_green=$'\033[92m'
_cc_purple=$'\033[95m'
_cc_red=$'\033[91m'
_cc_yellow=$'\033[93m'
_cc_cyan=$'\033[96m'
# dùng ANSI cơ bản để iSH cũng hiển thị ổn
_cc_english=$'\033[37m'

_cc_trim() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf "%s" "$s"
}

_color_mantra_line() {
  local raw="$1"
  local prefix=""
  local suffix=""
  local num=""
  local content=""
  local viet=""
  local rest=""
  local han_nghia=""
  local sanskrit=""
  local devanagari=""
  local han_am=""
  local english=""

  # ------------------------------------------
  # giữ dấu < > của speech bubble
  # ------------------------------------------
  if [[ "$raw" == "< "* ]]; then
    prefix="< "
    raw="${raw#< }"
  fi
  if [[ "$raw" == *" >" ]]; then
    suffix=" >"
    raw="${raw% >}"
  fi

  # ------------------------------------------
  # Chỉ xử lý dòng câu chú
  # ------------------------------------------
  if [[ "$raw" =~ ^[[:space:]]*([0-9]+)\.[[:space:]]*(.*)$ ]]; then
    num="${BASH_REMATCH[1]}"
    content="${BASH_REMATCH[2]}"
  else
    printf "%s\n" "$1"
    return 0
  fi

  # ------------------------------------------
  # Nếu không có # thì in bình thường
  # ------------------------------------------
  if [[ "$content" != *"#"* ]]; then
    printf "%s\n" "$1"
    return 0
  fi

  # Hán-Việt
  viet="${content%%#*}"
  viet="$(_cc_trim "$viet")"
  # sau #
  rest="${content#*#}"

  # Hán nghĩa | Sanskrit | Devanagari | Hán âm | English
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

  # ========================================================
  # PRINT
  # ========================================================
  [[ -n "$prefix" ]] &&
    printf "%s%s%s" "$_cc_gray" "$prefix" "$_cc_reset"
  # số
  printf "%s%s.%s " \
    "$_cc_gray" "$num" "$_cc_reset"
  # Hán-Việt = GREEN
  printf "%s%s%s%s" \
    "$_cc_bold" "$_cc_green" "$viet" "$_cc_reset"
  # Hán nghĩa = PURPLE
  if [[ -n "$han_nghia" ]]; then
    printf " %s#%s %s%s%s%s" \
      "$_cc_gray" "$_cc_reset" \
      "$_cc_bold" "$_cc_purple" "$han_nghia" "$_cc_reset"
  fi
  # Sanskrit = RED
  if [[ -n "$sanskrit" ]]; then
    printf " %s|%s %s%s%s%s" \
      "$_cc_gray" "$_cc_reset" \
      "$_cc_bold" "$_cc_red" "$sanskrit" "$_cc_reset"
  fi
  # Devanagari = YELLOW
  if [[ -n "$devanagari" ]]; then
    printf " %s|%s %s%s%s%s" \
      "$_cc_gray" "$_cc_reset" \
      "$_cc_bold" "$_cc_yellow" "$devanagari" "$_cc_reset"
  fi
  # Hán âm = CYAN
  if [[ -n "$han_am" ]]; then
    printf " %s|%s %s%s%s%s" \
      "$_cc_gray" "$_cc_reset" \
      "$_cc_bold" "$_cc_cyan" "$han_am" "$_cc_reset"
  fi
  # English = WHITE
  if [[ -n "$english" ]]; then
    printf " %s|%s %s%s%s" \
      "$_cc_gray" "$_cc_reset" \
      "$_cc_english" "$english" "$_cc_reset"
  fi
  [[ -n "$suffix" ]] &&
    printf "%s%s%s" "$_cc_gray" "$suffix" "$_cc_reset"
  printf "\n"
}

# ==========================================================
# Nếu chạy trực tiếp -> filter stdin
# Nếu source -> chỉ nạp function
# ==========================================================
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    _color_mantra_line "$line"
  done
fi
