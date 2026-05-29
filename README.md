# BlogPictures

複製圖片，用 `webpclip` 轉成 WebP 上傳，push 後 GitHub Actions 會自動更新瀏覽頁。

瀏覽頁：https://moon-jam.github.io/BlogPictures/ 可搜尋、預覽，並複製連結 / Markdown / HTML。

## webpclip

[`bin/webpclip`](bin/webpclip) 把剪貼簿的圖片或 GIF 轉成 `.webp`、commit 並 push，
再讓你複製成連結、Markdown 或 HTML。從 Raycast 或終端機都能用。

### 安裝

```bash
brew install webp pngpaste
git clone git@github.com:moon-jam/BlogPictures.git
cd BlogPictures
./setup.sh            # 加 --link 可在終端機任意處輸入 webpclip
```

接上 Raycast：Settings → Extensions → Script Commands → Add Script Directory → 選 `bin/`。

### 用法

1. 複製圖片（截圖），或在 Finder 複製圖片 / GIF 檔案。
2. 從 Raycast 觸發，或在終端機輸入 `webpclip`。
3. 確認檔名（留空用時間戳）與品質。
4. 自動轉檔、push，再選擇複製連結 / Markdown / HTML。

支援 PNG、JPG、GIF、WebP 等；GIF 需複製檔案本身才能保留動畫。

### 設定

編輯 `webpclip.config`（`setup.sh` 產生，已被 gitignore）：

| 變數 | 預設 | 說明 |
| --- | --- | --- |
| `WEBP_LOSSLESS` | `false` | `true` 為無損，畫質完美但檔案較大 |
| `WEBP_QUALITY` | `85` | 品質 0–100，每次上傳可調整 |

## 結構

| 路徑 | 用途 |
| --- | --- |
| `bin/webpclip` | 上傳工具 |
| `setup.sh` | 安裝設定 |
| `docs/index.html` | 網頁瀏覽介面 |
| `scripts/build-manifest.mjs` | 產生索引 |
| `.github/workflows/pages.yml` | CI 部署 Pages |
