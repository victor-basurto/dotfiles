# 🐚 ZSH & Environment Cheatsheet

---

## 📁 Custom Directory Shortcuts (`dir-utils`)

_Type the keyword directly to jump to the path._

| Keyword     | Destination Path                            | Description                           |
| :---------- | :------------------------------------------ | :------------------------------------ |
| `list-dirs` | —                                           | Lists all shortcuts with descriptions |
| `dot`       | `~/.config/.dotfiles`                       | Dotfiles Repository                   |
| `conf`      | `~/.config`                                 | Base Config Directory                 |
| `vimd`      | `~/.config/nvim`                            | Neovim Configuration                  |
| `zshd`      | `~/.config/.dotfiles/zsh/functions/`        | ZSH Custom Functions                  |
| `safer`     | `~/projects/safer-projects`                 | Safer Projects                        |
| `pers`      | `~/projects/personal-projects`              | Personal Projects                     |
| `jsd`       | `~/projects/js-projects`                    | JavaScript Projects                   |
| `reactd`    | `~/projects/react-projects`                 | React Projects                        |
| `nex`       | `~/projects/nextjs-projects`                | Next.js Projects                      |
| `strap`     | `~/projects/react-projects/strapi-projects` | Strapi CMS Projects                   |
| `umbd`      | `~/projects/umbraco`                        | Umbraco Projects                      |

### 🏢 Brookfield Work Shortcuts

| Keyword       | Destination Path                                     | Description                                        |
| :------------ | :--------------------------------------------------- | :------------------------------------------------- |
| `brook`       | `~/projects/brookfield`                              | Main Brookfield Root                               |
| `webd`        | `~/projects/brookfield/websites`                     | Websites Folder                                    |
| `xmd`         | `~/projects/brookfield/xmcloud`                      | XM Cloud Projects                                  |
| `mono`        | `~/projects/brookfield/xmcloud/brookfield-monorepo/` | Monorepo Root                                      |
| `mono <site>` | `.../sites/<site>`                                   | Jump straight to a site directory (Tab-completed!) |

---

## 🔎 Interactive Terminal Utils (`fzf`, `rg`, `fd`)

| Command | Trigger Tool         | Action                                                 |
| :------ | :------------------- | :----------------------------------------------------- |
| `ff`    | `fd` + `fzf` + `bat` | Fuzzy search files; open selection in Neovim           |
| `fw`    | `rg` + `fzf` + `bat` | Fuzzy search text inside files; jump to line in Neovim |
| `y`     | `yazi`               | File manager; updates terminal `$PWD` on exit          |
| `cheat` | `fd` + `fzf` + `bat` | Fuzzy find and read dotfile cheatsheets                |

---

## 🖥️ Window Management & Productivity

### 🚀 AeroSpace

- `aero-active` : List active windows in `fzf` layout, press `Enter` to refocus window.
- `space` : Open AeroSpace App.
- `space-x` : Force quit AeroSpace instance.

### 📝 Tuxedo (CLI Todo)

- `tx <file>` : Open standard tuxedo task file inside your Todo folder.

---

## ⚙️ Core System Shortcuts & Git Essentials

### 🔧 Base Aliases

- `v` ➡️ `nvim`
- `ls` / `l` / `ll` / `la` ➡️ Managed via `lsd` for icon-rich layouts
- `cat` ➡️ `bat --paging=never` (syntax highlighting)

### 🌿 Git Fast-Tracks

- `gs` ➡️ `git status`
- `ga` / `gaa` ➡️ `git add` / `git add .`
- `gc "<msg>"` ➡️ Commit with message
- `gp` / `gpl` ➡️ Push / Pull changes
- `gto` / `gtob` ➡️ Switch branch / Switch to new branch
- `gl` ➡️ Full visual graph layout log (`--all`)
- `glog` ➡️ Current branch visual graph log

---

## 💡 Keyboard Shortcuts (ZLE Bindings)

- `Ctrl + x` then `Ctrl + e` ➡️ Pull current command line into a full Neovim buffer to edit complex lines.
- `Right Arrow` or `Ctrl + f` ➡️ Accept terminal `zsh-autosuggestions` inline hint.
