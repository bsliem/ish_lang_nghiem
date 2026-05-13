#!/usr/bin/env bash

# =====================================================
# gp.sh
# Git pull --rebase --autostash + add + commit + push
# Dùng chung cho MacBook, Windows Git Bash, iSH iPhone
#
# Usage:
#   gp
#   gp "message"
#
# Device default:
#   ip-1 = iPhone 14 Pro Max
#   ip-2 = iPhone XS
#   mac = MacBook
#   win = Windows
# =====================================================

set -u

# ---- Kiểm tra đang ở trong git repo ----
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "❌ Không ở trong Git repository."
  echo "Hãy cd vào thư mục repo trước."
  exit 1
fi

REPO_ROOT="$(git rev-parse --show-toplevel)"
REPO_NAME="$(basename "$REPO_ROOT")"

# ---- Lấy tên thiết bị ----
DEVICE_FILE="$HOME/.ish_device_name"

if [ -f "$DEVICE_FILE" ]; then
  DEVICE_NAME="$(cat "$DEVICE_FILE" | tr -d '\n\r')"
else
  case "$(uname -s)" in
    Darwin*)
      DEVICE_NAME="mac"
      ;;
    MINGW*|MSYS*|CYGWIN*)
      DEVICE_NAME="win"
      ;;
    Linux*)
      if grep -qi "alpine" /etc/os-release 2>/dev/null; then
        DEVICE_NAME="ish"
      else
        DEVICE_NAME="linux"
      fi
      ;;
    *)
      DEVICE_NAME="unknown"
      ;;
  esac
fi

# ---- Message ----
if [ "$#" -eq 0 ]; then
  MSG="update all from $DEVICE_NAME"
else
  MSG="$*"
fi

echo "========================================"
echo "🚀 GP - Git nhanh"
echo "Repo    : $REPO_NAME"
echo "Device  : $DEVICE_NAME"
echo "Message : $MSG"
echo "========================================"
echo

cd "$REPO_ROOT" || exit 1

BRANCH="$(git branch --show-current 2>/dev/null)"
echo "🌿 Branch: $BRANCH"
echo

# ---- Hiện trạng thái ban đầu ----
echo "📌 Git status trước khi chạy:"
git status --short
echo

# ---- Pull rebase trước ----
echo "🔄 Step 1: git pull --rebase --autostash"
git pull --rebase --autostash

if [ $? -ne 0 ]; then
  echo
  echo "❌ Lỗi khi pull --rebase."
  echo "Kiểm tra:"
  echo "  git status"
  echo
  echo "Nếu muốn hủy rebase:"
  echo "  git rebase --abort"
  exit 1
fi

echo

# ---- Add toàn bộ ----
echo "➕ Step 2: git add -A"
git add -A
echo

# ---- Commit nếu có thay đổi ----
if git diff --cached --quiet; then
  echo "✅ Không có thay đổi mới để commit."
else
  echo "📝 Step 3: git commit"
  git commit -m "$MSG"

  if [ $? -ne 0 ]; then
    echo
    echo "❌ Commit lỗi."
    echo "Kiểm tra:"
    echo "  git status"
    exit 1
  fi
fi

echo

# ---- Pull rebase lần cuối ----
echo "🔄 Step 4: git pull --rebase --autostash lần cuối"
git pull --rebase --autostash

if [ $? -ne 0 ]; then
  echo
  echo "❌ Lỗi khi pull --rebase lần cuối."
  echo "Kiểm tra:"
  echo "  git status"
  exit 1
fi

echo

# ---- Push ----
echo "⬆️ Step 5: git push"
git push

if [ $? -ne 0 ]; then
  echo
  echo "❌ Push lỗi."
  echo "Thử kiểm tra:"
  echo "  git status"
  echo "  git pull --rebase --autostash"
  echo "  git push"
  exit 1
fi

echo
echo "✅ Xong: pull rebase + add + commit + push"
echo "🙏 Nam Mô A Di Đà Phật."