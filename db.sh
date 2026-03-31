#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load functions chú Đại Bi
source "$BASE_DIR/db_dai_bi.bash"

# Nếu không truyền tham số thì vẫn chạy được
ARGS=("$@")

# Tên lệnh được gọi
CMD="$(basename "$0")"

# Mặc định gọi hàm db
db "${ARGS[@]}"