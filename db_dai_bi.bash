#!/usr/bin/env bash
# ==========================================
# db_dai_bi.bash (iSH READY + AUTO 3s)
# Tụng Chú Đại Bi theo cấu trúc file dai_bi.md:
#   - Dòng 1: "01. ... # 漢字"
#   - Dòng 2: English
#
# Usage:
#   db 13             # 13 -> 24 (auto block 12)
#   db 13 27          # 13 -> 27
#   db 0*             # block 0: 1  -> 12
#   db 1*             # block 1: 13 -> 24
#   db 2*             # block 2: 25 -> 36
#   db 0* 1* 2*       # gộp nhiều block, hiển thị LIỀN MẠCH (vd 1→36)
#   db 0*:2*          # range block: block 0 tới 2 (vd 1→36)
#   dbk "觀自在"       # tìm keyword -> chọn -> tụng tới hết block 12
#
# Keys while chanting:
#   (no key) 3s = auto next
#   any key  = next immediately
#   q or ESC = quit
# ==========================================

# ---- Require bash (arrays + BASH_REMATCH + [[ ]] ) ----
if [[ -z "${BASH_VERSION:-}" ]]; then
  echo "❌ Script này cần bash. Trên iSH hãy chạy: apk add bash && bash"
  return 1 2>/dev/null || exit 1
fi

# ---- Portable path: dai_bi.md nằm cùng thư mục script ----
_DB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB_FILE="${DB_FILE:-"$_DB_DIR/dai_bi.md"}"

# ---- TTY fallback ----
_DB_TTY="/dev/tty"
[[ -r "$_DB_TTY" && -w "$_DB_TTY" ]] || _DB_TTY=""

# ---- Auto-next seconds (default 3) ----
DB_TIMEOUT="${DB_TIMEOUT:-3}"

# ANSI
_reset=$'\033[0m'
_bold=$'\033[1m'
_red=$'\033[31m'
_green=$'\033[32m'
_white=$'\033[37m'
_yellow=$'\033[33m'
_gray=$'\033[90m'
_cyan=$'\033[36m'

# Main: 12 câu / vòng -> 3 đỏ, 3 xanh, 3 trắng, 3 vàng
_db_color_main() {
  local n="$1"
  local r=$(( (n - 1) % 12 ))
  if   (( r < 3 )); then echo "$_red"
  elif (( r < 6 )); then echo "$_green"
  elif (( r < 9 )); then echo "$_white"
  else                  echo "$_yellow"
  fi
}

# Hán: 12 câu / vòng -> 3 trắng, 3 vàng, 3 đỏ, 3 xanh
_db_color_han() {
  local n="$1"
  local r=$(( (n - 1) % 12 ))
  if   (( r < 3 )); then echo "$_white"
  elif (( r < 6 )); then echo "$_yellow"
  elif (( r < 9 )); then echo "$_red"
  else                  echo "$_green"
  fi
}

# English: màu riêng (khác với main/han)
_db_color_eng() {
  echo "$_cyan"
}

# ---- Read 1 key with timeout (auto-next) ----
_db_read_key() {
  local key=""
  local timeout="${DB_TIMEOUT}"

  if [[ -n "$_DB_TTY" ]]; then
    stty -echo < "$_DB_TTY" 2>/dev/null || true
    IFS= read -r -n 1 -t "$timeout" key < "$_DB_TTY" 2>/dev/null || true
    stty echo < "$_DB_TTY" 2>/dev/null || true
  else
    stty -echo 2>/dev/null || true
    IFS= read -r -n 1 -t "$timeout" key 2>/dev/null || true
    stty echo 2>/dev/null || true
  fi

  printf "%s" "$key"
}

# ---- Halo end ----
_db_halo_end() {
  echo
  echo "🙏 Hết đoạn."

  local reset=$'\033[0m'
  local bold=$'\033[1m'
  local delay="${DB_HALO_DELAY:-0.15}"

  local colors=(
    $'\033[31m'  # đỏ
    $'\033[33m'  # vàng
    $'\033[32m'  # xanh lá
    $'\033[36m'  # cyan
    $'\033[34m'  # xanh dương
    $'\033[35m'  # tím
  )

  local words=("Nam" "Mô" "A" "Di" "Đà" "Phật.")
  local i=0 c

  for w in "${words[@]}"; do
    c="${colors[$(( i % ${#colors[@]} ))]}"
    printf "%s%s%s%s " "$bold" "$c" "$w" "$reset"
    sleep "$delay" 2>/dev/null || true
    i=$((i+1))
  done
  echo
}

# ==========================================
# Parse dai_bi.md -> MAIN[i], HAN[i], ENG[i]
# - i chạy từ 1..N (đúng số câu tụng)
# - File format:
#   "01. ... # 漢字"
#   "English..."
# ==========================================
declare -a _DB_MAIN _DB_HAN _DB_ENG
_DB_N=0
_DB_LOADED=0

_db_load() {
  [[ -f "$DB_FILE" ]] || { echo "❌ Không thấy file: $DB_FILE"; return 1; }
  (( _DB_LOADED == 1 )) && return 0

  local line next main han eng n
  _DB_N=0

  # regex để tránh brace expansion gây lỗi
  local re_num='^[[:space:]]*([0-9]{1,3})[.)][[:space:]]*(.*)$'

  while IFS= read -r line || [[ -n "$line" ]]; do
    # match: 01. .... hoặc 01) ....
    if [[ $line =~ $re_num ]]; then
      n="${BASH_REMATCH[1]}"
      main="${BASH_REMATCH[2]}"
      han=""

      if [[ "$main" == *"#"* ]]; then
        han="${main#*#}"
        main="${main%%#*}"
      fi

      # trim
      main="$(echo "$main" | sed -E 's/^[[:space:]]+|[[:space:]]+$//g')"
      han="$(echo "$han"   | sed -E 's/^[[:space:]]+|[[:space:]]+$//g')"

      # lấy English dòng kế tiếp (nếu có)
      IFS= read -r next || next=""
      eng="$(echo "$next" | sed -E 's/^[[:space:]]+|[[:space:]]+$//g')"

      _DB_N=$(( _DB_N + 1 ))
      _DB_MAIN[_DB_N]="$main"
      _DB_HAN[_DB_N]="$han"
      _DB_ENG[_DB_N]="$eng"
    fi
  done < "$DB_FILE"

  _DB_LOADED=1
  (( _DB_N > 0 )) || { echo "❌ File không có dòng dạng '01. ...'"; return 1; }
  return 0
}

# ==========================================
# db: tụng theo số (theo CÂU, không theo dòng)
# - db N          -> N → bội 12 kế tiếp
# - db A B        -> A → B
# - db K*         -> block K (0* = 1→12; 1* = 13→24; ...)
# - db 0* 1* 2*   -> gộp nhiều block LIỀN MẠCH
# - db 0*:2*      -> range block
# ==========================================
db() {
  _db_load || return 1

  trap 'stty echo < /dev/tty 2>/dev/null || true' EXIT

  # ---- Range block: db K*:M* ----
  if [[ "${1:-}" =~ ^([0-9]+)\*:([0-9]+)\*$ ]]; then
    local b1="${BASH_REMATCH[1]}" b2="${BASH_REMATCH[2]}"
    (( b2 < b1 )) && { local t="$b1"; b1="$b2"; b2="$t"; }
    db "$(( b1*12 + 1 ))" "$(( (b2+1)*12 ))"
    return 0
  fi

  local ranges=()

  # ---- Multi-block: db 0* 1* 2* ----
  local all_block_mode=true
  if (( $# == 0 )); then
    all_block_mode=false
  else
    for arg in "$@"; do
      [[ "$arg" =~ ^[0-9]+\*$ ]] || { all_block_mode=false; break; }
    done
  fi

  if [[ "$all_block_mode" == true ]]; then
    local blocks_sorted
    blocks_sorted="$(printf "%s\n" "$@" | sed 's/\*$//' | sort -n | uniq)"

    local first=1 cur_s=0 cur_e=0 b s e
    while IFS= read -r b; do
      [[ -n "$b" ]] || continue
      s=$(( b * 12 + 1 ))
      e=$(( s + 11 ))

      if (( first == 1 )); then
        cur_s=$s; cur_e=$e; first=0
      else
        if (( s <= cur_e + 1 )); then
          (( e > cur_e )) && cur_e=$e
        else
          ranges+=( "${cur_s}:${cur_e}" )
          cur_s=$s; cur_e=$e
        fi
      fi
    done <<< "$blocks_sorted"
    (( first == 0 )) && ranges+=( "${cur_s}:${cur_e}" )

  else
    local start="${1:-1}"
    local end="${2:-0}"

    if [[ "$start" =~ ^([0-9]+)\*$ ]]; then
      local block="${BASH_REMATCH[1]}"
      start=$(( block * 12 + 1 ))
      end=$(( start + 11 ))
    fi

    [[ "$start" =~ ^[0-9]+$ ]] || { echo "❌ start phải là số hoặc dạng K* (vd 0*, 1*, 2*)"; return 1; }
    [[ "$end"   =~ ^[0-9]+$ ]] || { echo "❌ end phải là số"; return 1; }

    if (( end == 0 )); then
      end=$(( ((start - 1) / 12 + 1) * 12 ))
    fi

    (( end < start )) && { local t="$start"; start="$end"; end="$t"; }
    ranges+=( "${start}:${end}" )
  fi

  # ---- Clamp theo số CÂU ----
  local fixed_ranges=() r rs re
  for r in "${ranges[@]}"; do
    rs="${r%%:*}"; re="${r##*:}"
    (( re > _DB_N )) && re="$_DB_N"
    (( rs > _DB_N )) && continue
    fixed_ranges+=( "${rs}:${re}" )
  done
  ranges=( "${fixed_ranges[@]}" )
  (( ${#ranges[@]} == 0 )) && { echo "❌ Không có đoạn hợp lệ để tụng."; return 1; }

  # ---- Header ----
  clear
  echo "🙏 TỤNG CHÚ ĐẠI BI"
  echo "File: $DB_FILE"
  if (( ${#ranges[@]} == 1 )); then
    local rs="${ranges[0]%%:*}"
    local re="${ranges[0]##*:}"
    echo "Từ câu: $rs → $re"
    local b_start=$(( (rs - 1) / 12 ))
    local b_end=$(( (re - 1) / 12 ))
    if (( b_start == b_end )); then
      echo "Block: ${b_start}*12"
    else
      echo "Block: ${b_start}*12 → ${b_end}*12"
    fi
  else
    echo "Đoạn tụng:"
    for r in "${ranges[@]}"; do
      echo "  - ${r%%:*} → ${r##*:}"
    done
  fi
  echo "⏳ Tự động sau ${DB_TIMEOUT}s | Phím bất kỳ: câu kế | q/ESC: thoát"
  echo "----------------------------------------"

  local i main han eng key c_main c_han c_eng stop=0

  for r in "${ranges[@]}"; do
    local start="${r%%:*}"
    local end="${r##*:}"

    for (( i=start; i<=end; i++ )); do
      main="${_DB_MAIN[i]}"
      han="${_DB_HAN[i]}"
      eng="${_DB_ENG[i]}"

      c_main="$(_db_color_main "$i")"
      c_han="$(_db_color_han "$i")"
      c_eng="$(_db_color_eng)"

      # Line 1: main + han
      printf "%s%02d.%s %s%s%s%s" \
        "$_gray" "$i" "$_reset" \
        "$_bold" "$c_main" "$main" "$_reset"

      if [[ -n "${han//[[:space:]]/}" ]]; then
        printf " %s#%s %s%s%s%s" \
          "$_gray" "$_reset" \
          "$_bold" "$c_han" "$han" "$_reset"
      fi
      printf "\n"

      # Line 2: English (màu khác)
      if [[ -n "${eng//[[:space:]]/}" ]]; then
        printf "%s%s%s\n" "$c_eng" "$eng" "$_reset"
      else
        printf "%s%s%s\n" "$_gray" "(no English)" "$_reset"
      fi

      key="$(_db_read_key)"
      if [[ "$key" == $'\e' || "$key" == "q" || "$key" == "Q" ]]; then
        stop=1
        break
      fi
    done
    (( stop == 1 )) && break
  done

  _db_halo_end
}

# ==========================================
# dbk: tìm keyword -> liệt kê match -> chọn -> tụng tới hết block 12
# - search trong main + han + english
# ==========================================
dbk() {
  _db_load || return 1

  local kw="$*"
  [[ -n "${kw//[[:space:]]/}" ]] || { echo '❌ Nhập từ khoá. Ví dụ: dbk "觀自在"'; return 1; }

  local hits=()
  local i hay

  for (( i=1; i<=_DB_N; i++ )); do
    hay="${_DB_MAIN[i]} # ${_DB_HAN[i]} ${_DB_ENG[i]}"
    if echo "$hay" | grep -qi -- "$kw"; then
      hits+=( "$i" )
    fi
  done

  (( ${#hits[@]} > 0 )) || { echo "❌ Không tìm thấy: $kw"; return 1; }

  echo "🔎 Tìm thấy các câu có: \"$kw\""
  echo "----------------------------------------"
  local n
  for n in "${hits[@]}"; do
    printf "%s%02d%s  %s\n" "$_gray" "$n" "$_reset" "${_DB_MAIN[n]}"
  done

  echo "----------------------------------------"
  echo "Nhập số câu muốn tụng. Enter = câu đầu tiên. q = thoát"
  printf "> "

  local pick
  if [[ -n "$_DB_TTY" ]]; then
    IFS= read -r pick < "$_DB_TTY" 2>/dev/null || pick=""
  else
    IFS= read -r pick 2>/dev/null || pick=""
  fi

  [[ "$pick" == "q" || "$pick" == "Q" ]] && return 0

  local start
  if [[ -z "${pick//[[:space:]]/}" ]]; then
    start="${hits[0]}"
  else
    [[ "$pick" =~ ^[0-9]+$ ]] || { echo "❌ Phải nhập số."; return 1; }
    start="$pick"
  fi

  db "$start" $(( ((start - 1) / 12 + 1) * 12 ))
}

# Gợi ý: nếu anh muốn gọi như ln/lnk:
#   alias db='db'
#   alias dbk='dbk'