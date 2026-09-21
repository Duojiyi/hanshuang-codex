# 寒霜破甲工具（免费版）

独立项目，不再依赖外面的任何文件夹。界面基于 PI-Desktop 的设计系统
（`src/styles/` 下的 tokens / ui-kit / settings 等样式表原样移植），
功能由 `electron/main.cjs` 调用同级目录的 PowerShell 脚本完成。

## 这个版本是什么

六个破甲目标（Codex / ZCode / Cursor / Claude / WorkBuddy / DeepSeek Harness），
每个目标提供各自的全版本列表。

版本标记已经固定在 `variant.json`（`"variant": "free"`），不需要传参。

各目标的注入位置：

| 目标 | 脚本 | 注入位置 |
|---|---|---|
| Codex | `install.ps1` | `~/.codex/config.toml` → model_instructions_file |
| ZCode | `install-zcode.ps1` | `AGENTS.md` + 全局记忆 + 系统提示词 |
| Cursor | `install-cursor.ps1` | Cursor 全局规则（User Rules） |
| Claude | `install-claude.ps1` | `~/.claude/CLAUDE.md` + skills |
| WorkBuddy | `install-workbuddy.ps1` | 云记忆 memoryBlock + MEMORY.md + 技能库 |
| DeepSeek Harness | `install-dsh.ps1` | `~/.dsh/AGENTS.md`（DSH 全局记忆）+ `~/.dsh/skills` |

DeepSeek Harness 用 Claude Code 版提示词（`寒霜v4-claude.md` / `寒霜v3.md`），
因为 DSH 的 `AGENTS.md` 与 Claude Code 的 `CLAUDE.md` 是同一套 Markdown 记忆规范。
备份落在 `~/.dsh/managed-prompts/`，卸载即还原（含原 `AGENTS.md` 全文）。

## 开发

```bash
npm install
npm run dev            # 起 Vite 开发服务器
npm run build          # 只构建渲染层到 dist/
npx electron .         # 跑起来（默认加载 dist/）
HS_DEV=1 npx electron .  # 连开发服务器
```

截图验收（开发用）：`HS_CAPTURE=<输出目录> npx electron .` 会逐页截图后自动退出。

## 打包

```bash
npm run dist
```

产物落在本文件夹的 `release/`：`寒霜破甲工具-安装版-<版本>.exe`

打包流程里有两处自定义：

- `scripts/make-icon.py` → 从 `build/icon.png` 生成 512/256 图标
- `scripts/make-ico.py` → 生成多尺寸 `.ico`
- `scripts/after-pack.js` → electron-builder 打完应用目录后，用 rcedit 把图标和版本信息写进 exe

最后一步是必需的：electron-builder 自带的 `signAndEditExecutable` 在 Windows 上要先解压
winCodeSign 压缩包，包里含 macOS 符号链接，普通权限创建不了会直接中断构建，所以关掉它、
改由 afterPack 钩子自己调 rcedit。

## 换图标

替换 `build/icon.png`（512×512 方形 PNG）后重新 `npm run dist` 即可。

## 目录

```
electron/     主进程、preload、PowerShell 调度、压缩守护、WorkBuddy 记忆守护
src/          渲染层（React）
  data/       目标与版本文案
  pages/      破甲详情页 / Skills 管理 / 使用教程 / 个人中心
  styles/     PI-Desktop 的样式表 + app.css
  assets/     界面用的字标图
scripts/      构建与图标脚本
build/        图标源文件（png / ico）
install*.ps1  安装脚本（打包时随 extraResources 进包）
codex-skills* 技能库（打包时进包）
```
