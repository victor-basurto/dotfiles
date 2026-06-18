---
name: dotfiles
description: |
  Overview of the .dotfiles repository at ~/.config/.dotfiles.
  Use when the user asks about the dotfiles repo structure, what tools are configured,
  how things are organized, or general questions about their development environment setup.
---

# Dotfiles Overview

This repository at `~/.config/.dotfiles` manages all personal development environment
configurations across macOS, Ubuntu, and Windows. It is organized into tool-specific
directories at the top level.

## Directory Layout

| Directory | Contents |
|---|---|
| `alacritty/` | `alacritty.toml` — terminal config (Catppuccin Frappe, pwsh, UbuntuSansMono Nerd Font) |
| `aerospace/` | `.aerospace.toml` — macOS tiling WM (i3-like) config |
| `eza/` | `theme.yml`, `theme-catppuccin.yml` — eza color themes |
| `ghostty/` | `config` — Ghostty terminal (Catppuccin Frappe, Monaco font, 0.93 opacity) |
| `git/` | `.gitconfig` — global Git config with extensive aliases |
| `kitty/` | `kitty.conf`, `current-theme.conf` — Kitty terminal (BlexMono Nerd Font, Catppuccin Frappe) |
| `lazygit/` | `config.yml` — Lazygit theme & keybindings (Catppuccin Frappe) |
| `nvim/` | Full Neovim config via LazyVim (see dotfiles-nvim skill) |
| `obsidian/` | `hubs/`, `templates/` — Obsidian vault support files |
| `opencode/` | `tui.json` — OpenCode TUI config (Catppuccin theme) |
| `powershell/` | Profile, utils, Obsidian helpers, Oh-My-Posh themes (see dotfiles-shell skill) |
| `prompt-generator/` | Work prompt templates |
| `psmux/` | `.psmux.conf` — Windows tmux/psmux config |
| `themes/` | Misc theme files (gitui) |
| `tmux/` | `.tmux.conf` — tmux config (prefix C-a, Catppuccin-style colors) |
| `tuxedo/` | `config.toml` — Tuxedo todo app config (Nord theme) |
| `wezterm/` | `.wezterm.lua` — WezTerm config (Catppuccin Frappe, JetBrainsMono) |
| `yazi/` | `yazi.toml`, `theme.toml`, `keymap.toml` — Yazi file manager |
| `zsh/` | `.zshrc`, `functions/`, `plugins/` — Zsh via Antidote (see dotfiles-shell skill) |

## Consistent Theming

Nearly every tool uses **Catppuccin Frappe** colors:
- Terminals: alacritty, ghostty, kitty, wezterm
- CLI tools: lazygit, eza (dedicated theme file)
- Neovim: Catppuccin (macchiato flavour with transparent bg)
- TUI: opencode (catppuccin), tuxedo (Nord — only exception)

## Cross-Platform

Shell scripts (zsh functions, PowerShell scripts) handle macOS/Linux/Windows paths
correctly, especially for Obsidian vaults (Google Drive), .NET SDK locations, and
file operations.

## Related Skills

- `dotfiles-nvim` — Neovim config details (keymaps, plugins, LSP, Obsidian)
- `dotfiles-shell` — Zsh and PowerShell configs, aliases, functions
- `dotfiles-tools` — Terminal emulators, tmux, git, lazygit, eza, yazi, aerospace
