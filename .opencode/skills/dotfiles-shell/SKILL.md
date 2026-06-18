---
name: dotfiles-shell
description: |
  Shell configuration for Zsh and PowerShell in ~/.config/.dotfiles.
  Use when the user asks about shell setup, zshrc, PowerShell profile, shell aliases,
  shell functions, Antidote plugins, Oh-My-Posh themes, prompts, or Obsidian shell
  scripts (odn/og/on/or/bko).
---

# Shell Configuration

## Zsh (`zsh/`)

**Active config:** `zsh/.zshrc` — uses **Antidote** plugin manager (not Oh My Zsh).

### Plugin Manager: Antidote

Sourced from `$(brew --prefix)/opt/antidote/share/antidote/antidote.zsh`
Uses static cache at `~/.zsh_plugins.zsh` generated from `.zsh_plugins.txt`.

**Plugins loaded** (via `zsh/plugins/.zsh_plugins.txt`):
- `Aloxaf/fzf-tab` — fzf-driven completion menu
- `zsh-users/zsh-completions` — extra completions
- `ohmyzsh/ohmyzsh path:plugins/git` — git aliases
- `ohmyzsh/ohmyzsh path:plugins/web-search` — terminal web search
- `ohmyzsh/ohmyzsh path:plugins/colored-man-pages` — colored man
- `zsh-users/zsh-autosuggestions` — fish-like suggestions
- `zsh-users/zsh-syntax-highlighting` — syntax highlighting

### Custom Functions (`zsh/functions/`)

**Directory navigation (`dir-utils.zsh`):** 15 shortcuts via named functions:
`dot`, `conf`, `zshd`, `vimd`, `oo`, `pers`, `brook`, `xmd`, `mono [site]`,
`webd`, `jsd`, `nex`, `reactd`, `safer`, `strap`, `umbd`

**eza trees (`eza-utils.zsh`):** `lt`, `lt-dirs-exclude`, `lt-exclude`,
`ltclean`, `ltproject`, `ltnext [scope]`, `ltdirs`

**Obsidian functions:**
- `bko` — Backup vault to `~/backups/obsidian-work/` (keeps last 8)
- `odn [task]` — Create/open daily note in Neovim
- `og` — Organize zettelkasten notes by frontmatter
- `on "Title"` — Create inbox note with template
- `or` — Open all inbox notes in Neovim

**Utilities (`utils.zsh`):**
- `ltree [level] [path]` — eza tree at depth
- `gprompt [file]` — Generate work prompt from template
- `serlogin` / `serdev` — Sitecore serialization commands
- `aero-active` — Aerospace window focus via fzf
- `ff` / `fw` — fzf file/word search
- `y` — Yazi wrapper (cd on exit)
- `tx` — Open Tuxedo todos

### Key Aliases

| Alias | Command |
|---|---|
| `v` | `nvim` |
| `ls` | `lsd` |
| `cat` | `bat --paging=never` |
| `grep` | `rg --color=auto` |
| `gc`/`gp`/`gs`/`gd` | git commit/push/status/diff |
| `gl` | `git log --oneline --graph --all` |
| `gpl` | `git pull` |
| `gto`/`gtob` | `git switch` / `git switch -c` |
| `gfetch` | `git fetch` |

### Prompt

**Starship** with custom `starship.toml`:
```
$os $directory $custom $git_branch $git_status $nodejs $lua
$character
```
- XMCloud badge shown when `sitecore.json` is detected
- FZF theme: Tokyo Night
- BAT theme: TwoDark

### Alternate Configs

- `zsh/omarchy/.zshrc` — stripped Oh My Zsh variant
- `zsh/ubuntu/.zshrc` — Ubuntu OMZ variant (jonathan theme, eza/batcat)
- `zsh/.zshrc-old` — legacy Powerlevel10k OMZ config

---

## PowerShell (`powershell/`)

**Entry point:** `powershell/viktor_profile.ps1`

### Modules

- **posh-git** — Git status in prompt
- **oh-my-posh** — Prompt theming (zash.omp.json active by default)
- **Terminal-Icons** — File icons in `ls`
- **PSReadLine** — Emacs mode, history predictions, ListView
- **PSFzf** — Ctrl+f (files), Ctrl+r (history)

### Utility Scripts

**`utils.ps1`:**
- Global aliases: `v`/`vim` → `nvim`, `ll` → `ls`, `g` → `git`
- 18 directory navigation functions (same shortcuts as zsh)
- Git helpers: `g`, `gst`, `gco`, `gbr`, `gsync`, `gpushu`, `gpushf`,
  `gbfrommain`, `gbfromdev`, `gfinish`
- `gprompt` — work prompt generator
- `tux`/`todo` — Tuxedo wrapper with argument completion

**`eza-utils.ps1`:** `l`, `l-all`, `lt`, `lt-dirs-only`, `lt-dirs-exclude`, `lt-exclude`

**Obsidian functions:**
- `odn [task]` — daily note with task tracking
- `og` — zettelkasten organizer
- `on "Title"` — inbox note creator
- `or` — inbox opener

### Oh-My-Posh Themes (`powershell/themes/`)

13 themes available. Default: `zash.omp.json` (minimal plain-text prompt).
Themes can be toggled by setting `$UseCustomTheme` in the profile.

---

## Tmux/PSMux

**macOS/Linux:** `tmux/.tmux.conf` — prefix `C-a`, vi pane nav, Catppuccin-style colors
**Windows:** `psmux/.psmux.conf` — same bindings, PowerShell 7 as default shell

Key bindings (both):
- `C-a h/j/k/l` — select pane
- `M-h/j/k/l` — resize pane
- `C-a v` / `C-a -` — vertical/horizontal split
- `C-a [` — copy mode (vi keys)
- `C-a r` — reload config
