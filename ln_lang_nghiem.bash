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
#   lnc1              # Đệ nhất hội: 1 → 187
#   lnc2              # Đệ nhị hội : 188 → 232
#   lnc3              # Đệ tam hội : 233 → 363
#   lnc4              # Đệ tứ hội  : 364 → 434
#   lnc5              # Đệ ngũ hội : 435 → 554
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
_LN_TTY=""
if [[ -t 0 && -r /dev/tty && -w /dev/tty ]]; then
  _LN_TTY="/dev/tty"
fi

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

# Phiên âm: 12 câu / vòng -> 4 đỏ, 4 xanh, 4 vàng
_ln_color_main() {
  local n="$1"
  local r=$(( (n - 1) % 12 ))
  if   (( r < 4 )); then echo "$_red"
  elif (( r < 8 )); then echo "$_green"
  else                  echo "$_yellow"
  fi
}

# Hán: 12 câu / vòng -> 4 trắng, 4 đỏ, 4 xanh
_ln_color_han() {
  local n="$1"
  local r=$(( (n - 1) % 12 ))
  if   (( r < 4 )); then echo "$_white"
  elif (( r < 8 )); then echo "$_red"
  else                  echo "$_green"
  fi
}

# ---- Read 1 key with timeout (auto-next) ----

# ==========================================
# Word-wrap cho Mac Terminal + iSH
# ==========================================
_ln_term_cols() {
  local cols=''

  if [[ -n "$_LN_TTY" ]]; then
    cols="$(stty size < "$_LN_TTY" 2>/dev/null | awk '{print $2}')"
  fi

  [[ "$cols" =~ ^[0-9]+$ ]] || cols="${COLUMNS:-80}"
  [[ "$cols" =~ ^[0-9]+$ ]] || cols=80

  cols=$(( cols - 4 ))
  (( cols < 28 )) && cols=28

  printf "%s" "$cols"
}

_ln_print_line() {
  local n="$1"
  local main="$2"
  local han="$3"
  local c_main="$4"
  local c_han="$5"

  local cols prefix indent width
  local word line
  local -a words

  cols="$(_ln_term_cols)"

  prefix="${n}. "
  printf -v indent '%*s' "${#prefix}" ''

  width=$(( cols - ${#prefix} ))
  (( width < 16 )) && width=16

  printf "%s%d.%s " "$_gray" "$n" "$_reset"

  line=''
  words=()
  read -r -a words <<< "$main"

  for word in "${words[@]}"; do
    if [[ -z "$line" ]]; then
      line="$word"
    elif (( ${#line} + 1 + ${#word} <= width )); then
      line="$line $word"
    else
      printf "%s%s%s%s\n" "$_bold" "$c_main" "$line" "$_reset"
      printf "%s" "$indent"
      line="$word"
    fi
  done

  [[ -n "$line" ]] && printf "%s%s%s%s" \
    "$_bold" "$c_main" "$line" "$_reset"

  if [[ -n "${han//[[:space:]]/}" ]]; then
    local used=$(( ${#line} + 3 + ${#han} ))

    if (( used <= width )); then
      printf " %s#%s %s%s%s%s\n" \
        "$_gray" "$_reset" \
        "$_bold" "$c_han" "$han" "$_reset"
    else
      printf "\n"
      printf "%s%s#%s " "$indent" "$_gray" "$_reset"

      local han_width=$(( width - 2 ))
      (( han_width < 10 )) && han_width=10

      line=''
      words=()
      read -r -a words <<< "$han"

      for word in "${words[@]}"; do
        if [[ -z "$line" ]]; then
          line="$word"
        elif (( ${#line} + 1 + ${#word} <= han_width )); then
          line="$line $word"
        else
          printf "%s%s%s%s\n" "$_bold" "$c_han" "$line" "$_reset"
          printf "%s  " "$indent"
          line="$word"
        fi
      done

      [[ -n "$line" ]] && printf "%s%s%s%s\n" \
        "$_bold" "$c_han" "$line" "$_reset"
    fi
  else
    printf "\n"
  fi
}

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
  trap 'if [[ -t 0 ]]; then stty echo 2>/dev/null || true; fi' EXIT

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

  # ---- Header compact ----
  if (( ${#ranges[@]} == 1 )); then
    local rs="${ranges[0]%%:*}"
    local re="${ranges[0]##*:}"
    local b_start=$(( (rs - 1) / 12 ))
    local b_end=$(( (re - 1) / 12 ))
    if (( b_start == b_end )); then
      echo "${rs}→${re} | B${b_start}"
    else
      echo "${rs}→${re} | B${b_start}→B${b_end}"
    fi
  else
    local summary=""
    local block_summary=""
    local r rs re bs be
    for r in "${ranges[@]}"; do
      rs="${r%%:*}"
      re="${r##*:}"
      bs=$(( (rs - 1) / 12 ))
      be=$(( (re - 1) / 12 ))
      [[ -n "$summary" ]] && summary="${summary}, "
      summary="${summary}${rs}→${re}"
      [[ -n "$block_summary" ]] && block_summary="${block_summary}, "
      if (( bs == be )); then
        block_summary="${block_summary}B${bs}"
      else
        block_summary="${block_summary}B${bs}→B${be}"
      fi
    done
    echo "${summary} | ${block_summary}"
  fi
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

        _ln_print_line "$i" "$main" "$han" "$c_main" "$c_han"
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


# >>> lnN 4-line shortcuts >>>
# ==========================================
# lnN: shortcut tụng 4 câu liên tiếp
#
# Ví dụ:
#   ln4    -> câu 4 → 7
#   ln9    -> câu 9 → 12
#   ln100  -> câu 100 → 103
#
# Lệnh cũ KHÔNG đổi:
#   ln 4   -> câu 4 → 12
#
# Cài shortcut:
#   bash ln_lang_nghiem.bash install-ln4
# ==========================================

_ln_four() {
  local start="${1:-}"

  [[ "$start" =~ ^[0-9]+$ ]] || {
    echo "❌ Cần số câu bắt đầu."
    echo "Ví dụ: ln4 | ln9 | ln100"
    return 1
  }

  local end=$(( start + 3 ))
  ln "$start" "$end"
}


_ln_install_shortcuts() {
  local bin_dir="$HOME/.local/bin"
  local script_path="$_LN_DIR/ln_lang_nghiem.bash"
  local n target

  mkdir -p "$bin_dir"

  for (( n=1; n<=554; n++ )); do
    target="$bin_dir/ln$n"

    cat > "$target" <<EOF
#!/usr/bin/env bash
exec bash "$script_path" four "$n"
EOF

    chmod +x "$target"
  done

  echo
  echo "✅ Đã tạo ln1 ... ln554"
  echo "📁 $bin_dir"
  echo
  echo "Ví dụ:"
  echo "  ln4    -> 4 → 7"
  echo "  ln9    -> 9 → 12"
  echo "  ln100  -> 100 → 103"
  echo
  echo 'PATH cần có: export PATH="$HOME/.local/bin:$PATH"'
}

# <<< lnN 4-line shortcuts <<<

# >>> lnc1 ... lnc5 : 5 hội Chú Lăng Nghiêm >>>
# ==========================================
# lnc1 -> Đệ nhất hội :   1 → 187
# lnc2 -> Đệ nhị hội  : 188 → 232
# lnc3 -> Đệ tam hội  : 233 → 363
# lnc4 -> Đệ tứ hội   : 364 → 434
# lnc5 -> Đệ ngũ hội  : 435 → 554
#
# Dùng chính hàm ln() để thừa hưởng toàn bộ format.
# ==========================================

_ln_assembly() {
  local hoi="${1:-}"

  case "$hoi" in
    1)
      ln 1 187
      ;;
    2)
      ln 188 232
      ;;
    3)
      ln 233 363
      ;;
    4)
      ln 364 434
      ;;
    5)
      ln 435 554
      ;;
    *)
      echo "❌ Hội phải từ 1 đến 5."
      echo "Ví dụ: lnc1 | lnc2 | lnc3 | lnc4 | lnc5"
      return 1
      ;;
  esac
}


_ln_install_assemblies() {
  local bin_dir="$HOME/.local/bin"
  local script_path="$_LN_DIR/ln_lang_nghiem.bash"
  local n target

  mkdir -p "$bin_dir"

  for n in 1 2 3 4 5; do
    target="$bin_dir/lnc$n"

    cat > "$target" <<EOF
#!/usr/bin/env bash
exec bash "$script_path" assembly "$n"
EOF

    chmod +x "$target"
  done

  echo
  echo "✅ Đã tạo lnc1 ... lnc5"
  echo "📁 $bin_dir"
  echo
  echo "  lnc1  -> 1 → 187   | Đệ nhất hội"
  echo "  lnc2  -> 188 → 232 | Đệ nhị hội"
  echo "  lnc3  -> 233 → 363 | Đệ tam hội"
  echo "  lnc4  -> 364 → 434 | Đệ tứ hội"
  echo "  lnc5  -> 435 → 554 | Đệ ngũ hội"
}

# <<< lnc1 ... lnc5 : 5 hội Chú Lăng Nghiêm <<<


# ==========================================
# Dispatcher
# Cho phép chạy trực tiếp:
#   bash ln_lang_nghiem.bash 13
#   bash ln_lang_nghiem.bash 0*
#   bash ln_lang_nghiem.bash lnk "tát đát"
# ==========================================
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  case "${1:-}" in

    # cài lnc1 ... lnc5
    install-lnc|install-assemblies)
      _ln_install_assemblies
      ;;

    # lnc1 ... lnc5 -> tụng trọn từng hội
    assembly|lnc)
      shift
      _ln_assembly "$@"
      ;;


    # cài ln1 ... ln554
    install-ln4|install-shortcuts)
      _ln_install_shortcuts
      ;;

    # lnN -> tụng 4 câu
    four)
      shift
      _ln_four "$@"
      ;;

    # tìm keyword
    k|lnk|search)
      shift
      lnk "$@"
      ;;

    # toàn bộ cú pháp ln cũ giữ nguyên
    *)
      ln "$@"
      ;;
  esac
fi
