#!/usr/bin/env bash

# ==========================================================
# colorize_c.bash
# CHỈ dùng cho command c
#
# Hán-Việt    xanh lá
# Hán nghĩa   tím
# Sanskrit    đỏ
# Devanagari  vàng
# Hán âm      cyan
# English     xám
# ==========================================================

reset=$'\033[0m'
bold=$'\033[1m'

gray=$'\033[90m'
green=$'\033[92m'
purple=$'\033[95m'
red=$'\033[91m'
yellow=$'\033[93m'
cyan=$'\033[96m'
english_color=$'\033[38;5;250m'


trim() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf "%s" "$s"
}


color_line() {

  local raw="$1"
  local prefix="" suffix=""
  local num content viet rest
  local han_nghia sanskrit devanagari han_am english

  # --------------------------------------------
  # c đôi khi bọc dòng bằng:
  # < 553. ..... >
  # --------------------------------------------

  if [[ "$raw" =~ ^[[:space:]]*\<[[:space:]]* ]]; then
    prefix="< "
    raw="${raw#*<}"
    raw="${raw#"${raw%%[![:space:]]*}"}"
  fi

  if [[ "$raw" =~ [[:space:]]\>[[:space:]]*$ ]]; then
    suffix=" >"
    raw="${raw%>}"
    raw="${raw%"${raw##*[![:space:]]}"}"
  fi


  # Chỉ tô màu dòng bắt đầu bằng số câu
  if [[ ! "$raw" =~ ^[[:space:]]*([0-9]+)\.[[:space:]]* ]]; then
    printf "%s\n" "$1"
    return
  fi

  num="${BASH_REMATCH[1]}"

  content="${raw#*.}"
  content="$(trim "$content")"


  # Nếu không có # thì giữ nguyên
  if [[ "$content" != *"#"* ]]; then
    printf "%s\n" "$1"
    return
  fi


  # --------------------------------------------
  # Hán-Việt
  # --------------------------------------------

  viet="${content%%#*}"
  viet="$(trim "$viet")"

  rest="${content#*#}"


  # --------------------------------------------
  #
  # Hán nghĩa | Sanskrit | Devanagari | Hán âm | English
  # --------------------------------------------

  IFS='|' read -r \
    han_nghia \
    sanskrit \
    devanagari \
    han_am \
    english <<< "$rest"

  han_nghia="$(trim "${han_nghia:-}")"
  sanskrit="$(trim "${sanskrit:-}")"
  devanagari="$(trim "${devanagari:-}")"
  han_am="$(trim "${han_am:-}")"
  english="$(trim "${english:-}")"


  # --------------------------------------------
  # PRINT
  # --------------------------------------------

  [[ -n "$prefix" ]] && printf "%s%s%s" "$gray" "$prefix" "$reset"

  printf "%s%s.%s " \
    "$gray" "$num" "$reset"


  # Hán-Việt = GREEN
  printf "%s%s%s%s" \
    "$bold" "$green" "$viet" "$reset"


  # Hán nghĩa = PURPLE
  if [[ -n "$han_nghia" ]]; then
    printf " %s#%s %s%s%s%s" \
      "$gray" "$reset" \
      "$bold" "$purple" "$han_nghia" "$reset"
  fi


  # Sanskrit = RED
  if [[ -n "$sanskrit" ]]; then
    printf " %s|%s %s%s%s%s" \
      "$gray" "$reset" \
      "$bold" "$red" "$sanskrit" "$reset"
  fi


  # Devanagari = YELLOW
  if [[ -n "$devanagari" ]]; then
    printf " %s|%s %s%s%s%s" \
      "$gray" "$reset" \
      "$bold" "$yellow" "$devanagari" "$reset"
  fi


  # Hán âm = CYAN
  if [[ -n "$han_am" ]]; then
    printf " %s|%s %s%s%s%s" \
      "$gray" "$reset" \
      "$bold" "$cyan" "$han_am" "$reset"
  fi


  # English = GRAY
  if [[ -n "$english" ]]; then
    printf " %s|%s %s%s%s" \
      "$gray" "$reset" \
      "$english_color" "$english" "$reset"
  fi


  [[ -n "$suffix" ]] && printf "%s%s%s" "$gray" "$suffix" "$reset"

  printf "\n"
}


# ==========================================================
# FILTER STDIN
# ==========================================================

while IFS= read -r line || [[ -n "$line" ]]; do
  color_line "$line"
done
