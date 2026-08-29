#!/usr/bin/env bash

# ============================================================
# tc_thap_chu.bash
# Thập Tiểu Chú - dùng format của ln_lang_nghiem.bash
# tc1 ... tc10
# ============================================================

_TC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Nạp toàn bộ màu, wrap, timeout, halo của lệnh ln
source "$_TC_DIR/ln_lang_nghiem.bash"

TC_FILE="${TC_FILE:-"$_TC_DIR/thap_chu.md"}"


tc_chant() {
  local wanted="${1:-}"

  [[ "$wanted" =~ ^([1-9]|10)$ ]] || {
    echo "❌ Dùng: tc1 ... tc10"
    return 1
  }

  [[ -f "$TC_FILE" ]] || {
    echo "❌ Không thấy file: $TC_FILE"
    return 1
  }

  local current=0
  local found=0
  local title=""
  local raw body main han
  local n=0 key c_main c_han

  trap 'if [[ -t 0 ]]; then stty echo 2>/dev/null || true; fi' EXIT

  while IFS= read -r raw || [[ -n "$raw" ]]; do

    # Tiêu đề: ### 01. 如意寶輪王陀羅尼
    if [[ "$raw" =~ ^###[[:space:]]*0?([0-9]+)\.[[:space:]]*(.*)$ ]]; then
      current="${BASH_REMATCH[1]}"
      title="${BASH_REMATCH[2]}"

      if (( current > wanted )); then
        break
      fi

      if (( current == wanted )); then
        found=1
        echo "TC${wanted} | ${title}"
        echo "----------------------------------------"
      fi

      continue
    fi

    (( current == wanted )) || continue

    # Chỉ xử lý dòng: 01. ... # ...
    if [[ "$raw" =~ ^[[:space:]]*0*([0-9]+)\.[[:space:]]*(.*)$ ]]; then
      n="${BASH_REMATCH[1]}"
      body="${BASH_REMATCH[2]}"
    else
      continue
    fi

    main="${body%%#*}"
    han=""
    [[ "$body" == *"#"* ]] && han="${body#*#}"

    main="$(printf "%s" "$main" | sed -E 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    han="$(printf "%s" "$han" | sed -E 's/^[[:space:]]*//;s/[[:space:]]*$//')"

    # dùng đúng hệ màu và wrap của ln
    c_main="$(_ln_color_main "$n")"
    c_han="$(_ln_color_han "$n")"

    _ln_print_line "$n" "$main" "$han" "$c_main" "$c_han"

    key="$(_ln_read_key)"

    if [[ "$key" == $'\e' || "$key" == "q" || "$key" == "Q" ]]; then
      break
    fi

  done < "$TC_FILE"

  (( found == 1 )) || {
    echo "❌ Không tìm thấy Tiểu Chú số $wanted"
    return 1
  }

  _ln_halo_end
}


install_tc() {
  local bin_dir="$HOME/.local/bin"
  local script_path="$_TC_DIR/tc_thap_chu.bash"
  local n target

  mkdir -p "$bin_dir"

  for (( n=1; n<=10; n++ )); do
    target="$bin_dir/tc$n"

    cat > "$target" <<EOF
#!/usr/bin/env bash
exec bash "$script_path" "$n"
EOF

    chmod +x "$target"
  done

  echo "✅ Đã tạo tc1 ... tc10"
  echo "📁 $bin_dir"
}


case "${1:-}" in
  install)
    install_tc
    ;;

  1|2|3|4|5|6|7|8|9|10)
    tc_chant "$1"
    ;;

  *)
    echo "Dùng:"
    echo "  tc1 ... tc10"
    echo "  bash tc_thap_chu.bash install"
    ;;
esac
