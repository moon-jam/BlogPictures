#!/usr/bin/env bash
#
# webpclip 一鍵設定：檢查相依、設定權限、由範本產生 gitignored 的 webpclip.config、
# 選配建立 ~/.local/bin/webpclip symlink，並引導 Raycast 設定。
#
# 用法：
#   ./setup.sh           只做檢查 + 產生設定檔
#   ./setup.sh --link    額外建立 ~/.local/bin/webpclip symlink（終端機任意目錄可用）

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

LINK=0
for arg in "$@"; do
  case "$arg" in
    --link) LINK=1 ;;
    *) echo "未知參數：$arg" >&2 ;;
  esac
done

echo "▶ webpclip setup"
echo "  repo: $REPO_DIR"
echo ""

# 1) 相依檢查
missing=""
for t in cwebp gif2webp pngpaste; do
  command -v "$t" >/dev/null 2>&1 || missing="$missing $t"
done
if [ -n "$missing" ]; then
  echo "⚠ 缺少相依套件:$missing"
  echo "  請執行：brew install webp pngpaste"
else
  echo "✓ 相依套件齊全（cwebp / gif2webp / pngpaste）"
fi

# 2) 執行權限
chmod +x "$REPO_DIR/bin/webpclip" "$REPO_DIR/setup.sh"
echo "✓ 已設定執行權限"

# 3) 由範本產生 gitignored 的 webpclip.config
if [ -f "$REPO_DIR/webpclip.config" ]; then
  echo "✓ webpclip.config 已存在，保留現有設定"
else
  sed "s|__REPO_DIR__|$REPO_DIR|" "$REPO_DIR/webpclip.config.template" > "$REPO_DIR/webpclip.config"
  echo "✓ 已由範本產生 webpclip.config（gitignored，不會推上 GitHub）"
fi

# 確保 .gitignore 有忽略實際設定檔
if ! grep -qxF '/webpclip.config' "$REPO_DIR/.gitignore" 2>/dev/null; then
  echo '/webpclip.config' >> "$REPO_DIR/.gitignore"
  echo "✓ 已將 /webpclip.config 加入 .gitignore"
fi

# 4) 選配 symlink
if [ "$LINK" = "1" ]; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$REPO_DIR/bin/webpclip" "$HOME/.local/bin/webpclip"
  echo "✓ 已建立 symlink：~/.local/bin/webpclip（請確認 ~/.local/bin 在 \$PATH）"
else
  echo "ℹ 想在終端機任意處用 'webpclip'：重跑 ./setup.sh --link"
fi

# 5) Raycast 引導（無法程式化自動加目錄，需手動一次）
echo ""
echo "▶ Raycast 設定（一次性手動）："
echo "  1. 開啟 Raycast → Settings (⌘,) → Extensions → Script Commands"
echo "  2. 點 Add Script Directory，選擇此目錄：$REPO_DIR/bin"
echo "  完成後即可用 Raycast 觸發「Upload Clipboard Image → BlogPictures」"
open -a Raycast >/dev/null 2>&1 || true

echo ""
echo "✅ setup 完成"
