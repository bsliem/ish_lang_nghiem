#!/usr/bin/env bash
# ==========================================
# ln_lang_nghiem.bash (iSH READY + AUTO 3s)
# Usage:
#   ln 13             # 13 -> 24 (auto block 12)
#   ln 13 27          # 13 -> 27 (giữ kiểu cũ)
#   ln 0*             # 1  -> 12   (block 0)
#   ln 1*             # 13 -> 24   (block 1)
#   ln 2*             # 25 -> 36   (block 2)
#   ln 3*             # 37 -> 48   (block 3)
#   ln 0* 1* 2*       # gộp nhiều block, hiển thị LIỀN MẠCH (vd 1→36)
#   ln 0*:2*          # range block: block 0 tới 2 (vd 1→36)
#   lnk "tát đát"     # liệt kê match -> chọn -> tụng tới hết block 12
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

# ---- Portable path: lang_nghiem.md nằm cùng thư mục script ----
_LN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LN_FILE="${LN_FILE:-"$_LN_DIR/lang_nghiem.md"}"

# ---- TTY fallback ----
_LN_TTY="/dev/tty"
[[ -r "$_LN_TTY" && -w "$_LN_TTY" ]] || _LN_TTY=""

# ---- Auto-next seconds (default 3) ----
LN_TIMEOUT="${LN_TIMEOUT:-3}"

# ANSI
_reset=$'\033[0m'
_bold=$'\033[1m'
_red=$'\033[31m'
_green=$'\033[32m'
_white=$'\033[37m'
_yellow=$'\033[33m'
_gray=$'\033[90m'

# Phiên âm: 12 câu / vòng -> 3 đỏ, 3 xanh, 3 trắng, 3 vàng
_ln_color_main() {
  local n="$1"
  local r=$(( (n - 1) % 12 ))
  if   (( r < 3 )); then echo "$_red"
  elif (( r < 6 )); then echo "$_green"
  elif (( r < 9 )); then echo "$_white"
  else                  echo "$_yellow"
  fi
}

# Hán: 12 câu / vòng -> 3 trắng, 3 vàng, 3 đỏ, 3 xanh
_ln_color_han() {
  local n="$1"
  local r=$(( (n - 1) % 12 ))
  if   (( r < 3 )); then echo "$_white"
  elif (( r < 6 )); then echo "$_yellow"
  elif (( r < 9 )); then echo "$_red"
  else                  echo "$_green"
  fi
}

# ---- Read 1 key with timeout (auto-next) ----
_ln_read_key() {
  local key=""
  local timeout="${LN_TIMEOUT}"

  if [[ -n "$_LN_TTY" ]]; then
    stty -echo < "$_LN_TTY" 2>/dev/null || true
    IFS= read -r -n 1 -t "$timeout" key < "$_LN_TTY" 2>/dev/null || true
    stty echo < "$_LN_TTY" 2>/dev/null || true
  else
    stty -echo 2>/dev/null || true
    IFS= read -r -n 1 -t "$timeout" key 2>/dev/null || true
    stty echo 2>/dev/null || true
  fi

  printf "%s" "$key"
}

# ==========================================
# 🌈 Hào quang kết thúc
# - "Hết đoạn." bình thường
# - "Nam Mô A Di Đà Phật." in đậm, mỗi chữ 1 màu
# Cross-platform
# ==========================================
_ln_halo_end() {
  echo
  echo "🙏 Hết đoạn."

  local reset=$'\033[0m'
  local bold=$'\033[1m'
  local delay="${LN_HALO_DELAY:-0.15}"

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
# ln: tụng theo số
# - ln N          -> N → bội 12 kế tiếp (vd 2→12, 13→24)
# - ln A B        -> A → B (giữ kiểu cũ)
# - ln K*         -> block K (0* = 1→12; 1* = 13→24; 2* = 25→36; ...)
# - ln 0* 1* 2*   -> gộp nhiều block và tụng LIỀN MẠCH (vd 1→36)
# - ln 0*:2*      -> range block K*:M* (vd 1→36)
# ==========================================
ln() {
  [[ -f "$LN_FILE" ]] || { echo "❌ Không thấy file: $LN_FILE"; return 1; }

  # đảm bảo stty luôn được bật lại
  trap 'stty echo < /dev/tty 2>/dev/null || true' EXIT

  # ---- Range block: ln K*:M* ----
  if [[ "${1:-}" =~ ^([0-9]+)\*:([0-9]+)\*$ ]]; then
    local b1="${BASH_REMATCH[1]}" b2="${BASH_REMATCH[2]}"
    (( b2 < b1 )) && { local t="$b1"; b1="$b2"; b2="$t"; }
    ln "$(( b1*12 + 1 ))" "$(( (b2+1)*12 ))"
    return 0
  fi

  # ranges: mảng các đoạn "start:end"
  local ranges=()

  # ---- Multi-block: ln 0* 1* 2* (LIỀN MẠCH) ----
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
    # ---- Normal: ln N / ln A B / ln K* ----
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

  # ---- Clamp theo số dòng ----
  local total
  total="$(wc -l < "$LN_FILE" 2>/dev/null)"
  [[ "$total" =~ ^[0-9]+$ ]] || total=0

  local fixed_ranges=() r rs re
  for r in "${ranges[@]}"; do
    rs="${r%%:*}"; re="${r##*:}"
    (( total > 0 && re > total )) && re="$total"
    (( total > 0 && rs > total )) && continue
    fixed_ranges+=( "${rs}:${re}" )
  done
  ranges=( "${fixed_ranges[@]}" )
  (( ${#ranges[@]} == 0 )) && { echo "❌ Không có đoạn hợp lệ để tụng."; return 1; }

  # ---- Header ----
  clear
  echo "📿 TỤNG KINH / CHÚ LĂNG NGHIÊM"
  echo "File: $LN_FILE"
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
  echo "⏳ Tự động sau ${LN_TIMEOUT}s | Phím bất kỳ: câu kế | q/ESC: thoát"
  echo "----------------------------------------"

  local i raw main han key c_main c_han stop=0

  for r in "${ranges[@]}"; do
    local start="${r%%:*}"
    local end="${r##*:}"

    for (( i=start; i<=end; i++ )); do
      raw="$(sed -n "${i}p" "$LN_FILE")"

      if [[ -z "${raw//[[:space:]]/}" ]]; then
        echo "${_gray}${i}.${_reset} ${_gray}(trống)${_reset}"
      else
        main="${raw%%#*}"
        han=""
        [[ "$raw" == *"#"* ]] && han="${raw#*#}"
        main="$(echo "$main" | sed -E 's/^[[:space:]]*[0-9]+[.)][[:space:]]*//')"

        c_main="$(_ln_color_main "$i")"
        c_han="$(_ln_color_han "$i")"

        printf "%s%d.%s %s%s%s%s" \
          "$_gray" "$i" "$_reset" \
          "$_bold" "$c_main" "$main" "$_reset"

        if [[ -n "${han//[[:space:]]/}" ]]; then
          printf " %s#%s %s%s%s%s" \
            "$_gray" "$_reset" \
            "$_bold" "$c_han" "$han" "$_reset"
        fi
        printf "\n"
      fi

      key="$(_ln_read_key)"
      if [[ "$key" == $'\e' || "$key" == "q" || "$key" == "Q" ]]; then
        stop=1
        break
      fi
    done
    (( stop == 1 )) && break
  done

  _ln_halo_end
}

# ==========================================
# lnk: tìm keyword -> liệt kê match -> chọn -> tụng tới hết block 12
# ==========================================
lnk() {
  local kw="$*"
  [[ -n "${kw//[[:space:]]/}" ]] || { echo '❌ Nhập từ khoá. Ví dụ: lnk "tát đát"'; return 1; }
  [[ -f "$LN_FILE" ]] || { echo "❌ Không thấy file: $LN_FILE"; return 1; }

  local matches
  matches="$(grep -in -- "$kw" "$LN_FILE" 2>/dev/null | head -n 200)"
  [[ -n "$matches" ]] || { echo "❌ Không tìm thấy: $kw"; return 1; }

  echo "🔎 Tìm thấy các câu có: \"$kw\""
  echo "----------------------------------------"
  echo "$matches" | while IFS=: read -r n line; do
    local before="${line%%#*}"
    before="$(echo "$before" | sed -E 's/^[[:space:]]*[0-9]+[.)][[:space:]]*//')"
    printf "%s%d%s  %s\n" "$_gray" "$n" "$_reset" "$before"
  done

  echo "----------------------------------------"
  echo "Nhập số câu muốn tụng. Enter = câu đầu tiên. q = thoát"
  printf "> "

  local pick
  if [[ -n "$_LN_TTY" ]]; then
    IFS= read -r pick < "$_LN_TTY" 2>/dev/null || pick=""
  else
    IFS= read -r pick 2>/dev/null || pick=""
  fi

  [[ "$pick" == "q" || "$pick" == "Q" ]] && return 0

  local start
  if [[ -z "${pick//[[:space:]]/}" ]]; then
    start="$(echo "$matches" | head -n 1 | cut -d: -f1)"
  else
    [[ "$pick" =~ ^[0-9]+$ ]] || { echo "❌ Phải nhập số."; return 1; }
    start="$pick"
  fi

  ln "$start" $(( ((start - 1) / 12 + 1) * 12 ))
}

# ==========================================
# Dispatcher
# Cho phép chạy trực tiếp:
#   bash ln_lang_nghiem.bash 13
#   bash ln_lang_nghiem.bash 0*
#   bash ln_lang_nghiem.bash lnk "tát đát"
# ==========================================
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  case "${1:-}" in
    k|lnk|search)
      shift
      lnk "$@"
      ;;
    *)
      ln "$@"
      ;;
  esac
fi
