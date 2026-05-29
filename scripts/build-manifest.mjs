#!/usr/bin/env node
// 掃描倉庫內的圖片/影片，產生 docs/images.json（給 gallery 頁面讀，不靠 GitHub API）。
// 本機可手動跑：node scripts/build-manifest.mjs
// CI 會在部署 Pages 前自動執行。

import { readdirSync, statSync, writeFileSync, mkdirSync } from "node:fs";
import { join, relative, sep } from "node:path";

const ROOT = process.cwd();
const OUT_DIR = join(ROOT, "docs");
const OUT = join(OUT_DIR, "images.json");

const IMG = new Set(["png", "jpg", "jpeg", "gif", "webp", "svg", "bmp", "avif"]);
const VID = new Set(["mp4", "mov", "webm", "m4v"]);
// 不掃描這些頂層目錄（沒有要展示的素材）
const SKIP_TOP = new Set([".git", ".github", "docs", "bin", "scripts", "node_modules"]);

const ext = (p) => { const i = p.lastIndexOf("."); return i >= 0 ? p.slice(i + 1).toLowerCase() : ""; };
const kind = (e) => (IMG.has(e) ? "image" : VID.has(e) ? "video" : null);

const out = [];
function walk(dir) {
  for (const name of readdirSync(dir)) {
    const full = join(dir, name);
    const rel = relative(ROOT, full);
    if (SKIP_TOP.has(rel.split(sep)[0])) continue;
    const st = statSync(full);
    if (st.isDirectory()) { walk(full); continue; }
    const k = kind(ext(name));
    if (k) out.push({ path: rel.split(sep).join("/"), type: k, size: st.size });
  }
}

walk(ROOT);
out.sort((a, b) => a.path.localeCompare(b.path));
mkdirSync(OUT_DIR, { recursive: true });
writeFileSync(OUT, JSON.stringify(out));
console.log(`wrote ${out.length} entries to docs/images.json`);
