#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load logic
source "$BASE_DIR/add_a_di_da.bash"

# Run
add "$@"