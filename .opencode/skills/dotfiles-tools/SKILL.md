---
name: dotfiles-tools
description: |
  CLI tools and terminal emulator configurations in ~/.config/.dotfiles.
  Use when the user asks about tmux, git config/aliases, lazygit, eza, yazi, aerospace
  (macOS tiling WM), ghostty, kitty, wezterm, alacritty, tuxedo (todo app), or any
  other tool config in the dotfiles.
---

# CLI Tools & Terminal Emulators

## Git (`git/.gitconfig`)

**Key settings:** `nvim` as editor, `autocrlf = input`, `rebase = true` for pull,
`rerere.enabled = true`, `diff.algorithm = histogram`, `merge.conflictstyle = zdiff3`,
`push.autoSetupRemote = true`, credential helper = manager.

**Notable aliases:**

| Alias | Command |
|---|---|
| `s` / `br` / `new` | `switch` / `branch` / `switch -c` |
| `st` / `ss` | `status` / `status -sb` |
| `dw` / `ds` | `diff` / `diff --staged` |
| `lg` / `hist` | `log --graph --oneline --all` / detailed history |
| `syncm` / `sync` | Fetch + rebase onto main / develop |
| `ship` | `sync` + force push |
| `up` | `sync` + `syncf` (two-step sync) |
| `startm` / `start` | Switch to main/develop, pull, create new branch |
| `wip` / `zap` | WIP commit / stash-then-drop |
| `amend` / `amendm` | `commit --amend --no-edit` / with message |
| `pushf` | Force push with lease + if-includes |
| `rib` | `rebase -i origin/develop` |
| `devup` | Switch to develop, fetch --all --prune, pull |
| `clean-preview` / `clean-force` | Dry-run / force clean untracked |
| `unstage` | `restore --staged` |
| `type` / `dump` | `cat-file -t` / `cat-file -p` |

---

## Terminal Emulators

All use **Catppuccin Frappe** theme and a **Nerd Font**.

### Alacritty (`alacritty/alacritty.toml`)
- Shell: `pwsh.exe` (Windows)
- Font: `UbuntuSansMono Nerd Font Mono` 13pt
- Window: transparent, 0.92 opacity, blur
- Leader key sending: `Ctrl+Alt 1-4` → `\u0001` (Ctrl+A for tmux)

### Ghostty (`ghostty/config`)
- Font: `Monaco` 14pt
- Theme: `Catppuccin Frappe`
- 0.93 opacity, 10px blur, hide mouse while typing
- Keymaps (mirrors kitty layout):
  - `Ctrl+n` — new tab
  - `Ctrl+[` / `Ctrl+]` — previous / next tab
  - `Ctrl+w>h/j/k/l` — split navigation (left/down/up/right)
  - `Ctrl+r>h/j/k/l` — resize split (5 cells, vim-direction)
  - `Cmd+d` / `Cmd+Shift+d` — vertical / horizontal split
  - `Cmd+z` — toggle split zoom
  - Note: tab renaming and split reset not available in Ghostty

### Kitty (`kitty/kitty.conf`)
- Font: `BlexMono Nerd Font Mono` 12pt
- Theme: Catppuccin Frappe via `current-theme.conf`
- 0.95 opacity, 9px blur, cursor trail enabled
- Tab bar: powerline style, round
- Keymaps: `Ctrl+n` (new tab), `Ctrl+[`/`]` (prev/next tab),
  `Ctrl+w h/j/k/l` (window nav), `Ctrl+r h/j/k/l` (resize)

### WezTerm (`wezterm/.wezterm.lua`)
- Default program: `pwsh`
- Color scheme: `Catppuccin Frappe`
- Font: `JetBrainsMono Nerd Font` 13pt with emoji fallbacks
- 0.95 opacity
- Leader key: `Ctrl+a`, 1000ms timeout
- Keymaps: `LEADER -/v` (splits), `LEADER h/j/k/l` (pane nav),
  `Alt+h/j/k/l` (resize), `F1-F8` / `Ctrl+Alt 1-8` (tab switch)

---

## Tmux (`tmux/.tmux.conf`)

**Windows variant:** `psmux/.psmux.conf`

- Prefix: `C-a` (unbinds `C-b`)
- Mouse on, base index 1, renumber windows
- History: 10,000 lines
- Vi-style copy mode
- Status: left = session name + window:pane, right = date/time
- Active window: bg `#4527a0`, white bold

**Keymaps:** `C-a h/j/k/l` (select pane), `M-h/j/k/l` (resize by 5),
`C-a v` / `C-a -` (v/h split), `C-a [` (copy mode), `C-a r` (reload)

---

## Lazygit (`lazygit/config.yml`)

Catppuccin Frappe themed. Custom keybindings:
- `c` → commit, `S` → stash, `a` → toggle stage all
- `D` → custom: `difft --color=always`
- `p` → create PR

Pager: `delta`, editor: `nvim`, log: topo-order

---

## Eza (`eza/theme.yml`, `eza/theme-catppuccin.yml`)

Two color themes: one Catppuccin-based, one custom (Tokyo Night-like).
`EZA_CONFIG_DIR` points to this repo's `eza/` directory.

Zsh functions (`eza-utils.zsh`) and PowerShell functions (`eza-utils.ps1`) provide
tree-view wrappers: `lt`, `lt-exclude`, `ltproject`, `ltnext`, etc.

---

## Yazi (`yazi/yazi.toml`, `yazi/theme.toml`, `yazi/keymap.toml`)

- Shows hidden files
- Opens files in `nvim` by default
- Zsh wrapper `y` changes directory on exit

---

## Aerospace (`aerospace/.aerospace.toml`)

macOS tiling window manager (i3-like). Config v2.
- Gaps: 0 (inner and outer)
- Persistent workspaces: 1, 2, 3
- Keymaps: `alt-h/j/k/l` (focus), `alt-shift-h/j/k/l` (move),
  `alt-1..9/a..z` (workspace switch), `alt-shift-1..9/a..z` (move to workspace),
  `alt-slash` (layout toggle), `alt-minus/equal` (resize)

---

## Tuxedo (`tuxedo/config.toml`)

Terminal todo app. Theme: Nord, comfortable density, sort by priority.
Both panels shown, line numbers, status bar, done/future items visible.

Accessed via `tx` (zsh) or `tux`/`todo` (PowerShell).
Requires `$env:TODO_DIR` pointing to a directory with `todo.txt`.
