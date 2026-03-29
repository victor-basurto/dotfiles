.dotfiles/README.md#L1-400
# My Dotfiles

This repository contains my personal configuration for terminals, shells, editors and small utilities across macOS, Ubuntu and Windows. It's organized so someone can quickly inspect what is included, where configuration files live, and how to get the Neovim setup up-and-running.

This README documents:
- What each top-level folder contains
- Important config file locations
- Detailed Neovim feature list and the plugin/config mappings
- Quick install/usage notes and recommendations

--- 

Table of Contents
- Overview
- Top-level entries & purpose
- Neovim — features, plugins, and files
- Other tools (alacritty, kitty, wezterm, tmux, eza, lazygit, yazi, ghostty)
- Shells & dotfiles (zsh, powershell)
- Prompt generator & themes
- Installation / bootstrap notes
- Contributing & troubleshooting

---

Overview
========
This repo is intended to be opinionated and practical — a set of working defaults I use every day. The Neovim configuration is modular (Lua), uses lazy.nvim as the plugin manager (via LazyVim as a base), and includes sensible plugins for editing, navigation, LSP, formatting, and UI polish.

Top-level entries & purpose
===========================
- `alacritty/`
  - `alacritty.toml` — Alacritty config (shell program, font, window, keybindings, colors).
- `eza/`
  - `theme.yml`, `theme-catppuccin.yml` — Color themes for `eza` (ls replacement).
- `ghostty/`
  - `config` — Ghostty terminal settings (theme, font, blur, opacity).
- `git/`
  - `.gitconfig` — Global Git settings, aliases, color config and helpful aliases & workflows.
- `kitty/`
  - `kitty.conf` — Kitty terminal configuration.
  - `current-theme.conf` — Catppuccin-Frappe theme for kitty.
- `lazygit/`
  - `config.yml` — Lazygit UI theme and custom keybindings.
- `nvim/`
  - `init.lua` — Entry point, bootstraps `lazy.nvim`.
  - `lua/config/` — options, keymaps, autocmds, lazy bootstrap.
  - `lua/plugins/` — per-plugin configuration files (alpha, telescope, treesitter, etc.).
  - `lua/utilities/` — helper Lua functions used by the config.
  - `lazy-lock.json`, `lazyvim.json`, `stylua.toml` — lock/config files.
- `powershell/`
  - PowerShell profile scripts and utilities (`viktor_profile.ps1`, `utils.ps1`, obsidian helpers).
- `prompt-generator/`
  - Templates to help generate task or PR prompts.
- `themes/`
  - Misc themes (gitui theme file).
- `tmux/`
  - `.tmux.conf` — tmux config: keybindings (prefix C-a), panes, status bar, mouse and history.
- `wezterm/`
  - `.wezterm.lua` — WezTerm config: colorscheme, font fallback, keybinds and leader.
- `yazi/`
  - `yazi.toml`, theme/keymap — File manager integration config.
- `opencode/`
  - `tui.json` — OpenCode TUI configuration (theme: catppuccin).
- `zsh/`
  - `.zshrc`, `functions/`, `plugins/` — zsh configuration, plugins via Antidote, fzf-tab, zoxide, starship and assorted helper functions.

Neovim — features, plugins, and config file locations
=====================================================

Primary files
- `nvim/init.lua` — the single-line entry that loads `lua/config/lazy.lua` and triggers plugin manager bootstrap.
- `nvim/lua/config/lazy.lua` — lazy.nvim bootstrap + main plugin spec (imports LazyVim, language extras, and local `plugins`).
- `nvim/lua/config/options.lua` — editor options (tabsize, clipboard integration, UI defaults).
- `nvim/lua/config/keymaps.lua` — custom key mappings (leader mappings and common bindings).
- `nvim/lua/config/autocmds.lua` — autocmds used across the config.

Per-plugin files (location: `nvim/lua/plugins/*.lua`)
- `alpha-nvim.lua` — startup dashboard (custom ASCII header).
- `telescope.lua` — extensive Telescope configuration:
  - layout_strategy horizontal, prompt at top, wrap_results, ascending sorting.
  - file_browser extension configured (dropdown theme, custom key bindings).
  - ui-select extension loaded.
  - frecency extension available (tagged as a dependency).
- `treesitter.lua`
  - `ensure_installed` includes: astro, bash, comment, css, git_* files, go, graphql, html, http, javascript, json, json5, lua, markdown, markdown_inline, powershell, prisma, regex, scss, sql, tsx, typescript, vim, vimdoc, xml, yaml, ...
  - highlight and indent enabled; textobjects select with `af/if` and `ac/ic`.
- `lsp.lua`
  - The config currently returns empty to let LazyVim defaults handle LSP. (A commented section shows how to add `nvim-lspconfig` and per-server configuration).
- `mason.lua` / `mason` integration
  - mason is installed to manage LSP servers, DAP servers, linters, and formatters.
- `conform.lua` / `none-ls.lua`
  - conform/none-ls integration for formatters and linters (Unified formatting).
- `telescope.lua`, `lualine.lua`, `noice.lua`, `luasnip.lua`, `markdown.lua`, `alpha-nvim.lua`, `treesitter.lua`, `themes.lua`, etc.
- `markdown.lua`
  - plugins: `markdown-preview.nvim`, `render-markdown.nvim`, `markdown-toc.nvim`
  - features: Markdown rendering, automatic strikethrough for completed checklist items via an autocmd, TOC generation helpers and keymaps.
- `luasnip.lua`
  - LuaSnip configured with friendly-snippets; custom snippets provided for markdown code blocks, links, TODOs, and JSDoc templates.
- `lualine.lua`
  - Custom lualine with mode indicator, filesize, filename, diagnostics, LSP client name, git branch and diffs.
- `noice.lua`
  - `noice.nvim` is loaded with LSP overrides and presets tailored for a cleaner message UI and popup behavior.

Key mappings & ergonomics
- Leader (via LazyVim conventions) — typically `<leader>` is available for many mappings.
- Common custom mappings (examples):
  - `<leader>ff` — Telescope find files
  - `<leader>fg` — Telescope live grep
  - `<leader>fb` — Telescope buffers
  - `<leader>fh` — Telescope help tags
  - `<leader>o` — Focus NeoTree (file explorer)
  - `<leader>ng` — NeoGen code generation command
  - Markdown TOC:
    - `<leader>mtoc` — Insert markdown TOC (browser-compatible)
    - `<leader>motoc` — Insert markdown TOC (Obsidian wikilink style)
- Filetype hacks: `.tsx` BufRead/BufNewFile autocmd sets `filetype=typescriptreact`.
- `treesitter` textobjects allow `af`, `if`, `ac`, `ic` selections for structural editing.

Notable behaviors & custom automations
- Markdown checklist autocmd automatically applies strikethrough highlighting to lines that contain `[x] `.
- `render-markdown.nvim` configured with heading icons, borders and anti-conceal for a better rendered preview.
- Telescope file-browser hijack and custom key bindings for paging and navigation.
- Alpha dashboard with a custom ASCII header.

How to install and bootstrap Neovim config
1. Clone or copy this repo.
2. Place `nvim` folder at `~/.config/nvim` (or create symlink to this repo's `nvim`).
3. Start Neovim — the `lazy.nvim` bootstrap in `lua/config/lazy.lua` clones `lazy.nvim` if missing (stable branch). The plugin manager will load configured plugins.
4. Use `:Lazy` to open the lazy UI, or `:Lazy sync` to install/update plugins.
5. Install `mason` tools (LSP servers / linters / formatters) as needed via `:Mason` UI or via the CLI.

Recommended extras
- Nerd fonts (e.g., FiraCode Nerd Font, ZedMono, JetBrainsMono Nerd) for ligatures and icons in statuslines and telescope.
- `ripgrep` (`rg`) and `bat` for integration with Telescope, fzf-tab and previews.
- `delta` for git diffs (configured as pager in `lazygit` and `git` settings).
- `fzf`, `zoxide`, and `starship` for shell experience.

Other tools — quick details
================================

alacritty/alacritty.toml
- Uses PowerShell as default shell on Windows (`pwsh.exe`), Catppuccin Frappe colors, font set to `UbuntuSansMono Nerd Font Mono`, window blur, transparency and custom keybindings to spawn, copy/paste and a few leader-like bindings.

ghostty/config
- Catppuccin Frappe theme selected, background opacity and blur configured, preferred font family noted.

kitty/
- `kitty.conf` — full configuration with fonts, features and comments. `current-theme.conf` contains a Catppuccin-Frappe theme that matches other terminal components.

wezterm/.wezterm.lua
- Leader `CTRL+a` configured, keybindings for pane splits and navigation, ctrl+alt number and F1-F8 to switch tabs, `Catppuccin Frappe` color scheme selected, font fallback with emoji/fonts and opacity set.

tmux/.tmux.conf
- Prefix set to `C-a` (Ctrl-a), mouse on, vi-style navigation between panes, alt+hjkl to resize panes, status bar custom colors & layout, history-limit increased, automatic renaming and integrated Yazi passthrough setting.

eza/
- Two theme files for `eza` including Catppuccin colors. `EZA_CONFIG_DIR` is referenced in `.zshrc` so `eza` will pick up those theme files.

lazygit/config.yml
- Theme colors tuned to Catppuccin, keybindings simplified, `difft` custom command bound to `D` in files context, `nvim` as editor, `delta` as pager.

yazi/
- `yazi.toml` configuration to show hidden files and open files in `nvim` by default (`run = 'nvim %*'`).

git/.gitconfig
- Global git config with:
  - `editor = nvim`
  - `autocrlf = input`
  - enhanced pager defaults
  - `rebase = true` for pull
  - many aliases (`s`, `br`, `st`, `ss`, `hist`, `lg`, `startm`, `syncm`, `clean-preview` etc.)
  - credential helper set to `manager` (Windows), includeIf examples for project-specific overrides

zsh/
- `.zshrc` uses Antidote plugin manager, starship prompt, `fzf` integration, `fzf-tab` previews with `bat`/`eza`, `zoxide` integration, `lsd` as `ls`, `bat` as `cat`, and many git-friendly aliases.
- Additional functions are loaded from `functions/` (custom directory shortcuts, yazi wrapper, utilities, obsidian helpers).
- `EZA_CONFIG_DIR` is set to point to the `eza` folder in this repo.

powershell/
- PowerShell profile and helper scripts. Useful Windows-specific aliases and obsidian helper scripts are included, plus PSReadLine and fzf integrations documented in the `powershell/README.md`.

prompt-generator/
- Handy templates for PR / task descriptions and developer-oriented prompts.

themes/
- `gitui` theme file and other theme assets to harmonize colors between tools.

How to use / suggested setup
============================
- Symlink or copy core configs to their expected locations:
  - Neovim: `~/.config/nvim` → symlink to `nvim/` in this repo
  - Alacritty: `~/.config/alacritty/alacritty.toml` → symlink to `alacritty/alacritty.toml`
  - Kitty: `~/.config/kitty/kitty.conf` → symlink to this repo's file
  - WezTerm: `~/.config/wezterm/.wezterm.lua` → symlink to `wezterm/.wezterm.lua`
  - tmux: `~/.tmux.conf` → symlink to `tmux/.tmux.conf`
  - zsh: `~/.zshrc` → symlink to `zsh/.zshrc`
  - PowerShell: copy `powershell/viktor_profile.ps1` to your profile location (Windows)
- Install recommended tools:
  - `rg` (ripgrep), `bat`, `delta`, `fzf`, `zoxide`, Nerd fonts, `git`, `node` (if using markdown-preview plugin), `pnpm` or npm for installing some plugin tools.
- For Neovim:
  - Start `nvim` and let lazy.nvim install plugins automatically.
  - Run `:Mason` to install any LSP servers / formatters you need (or `:Lazy sync`).
  - If a plugin requires an external binary (e.g. `markdown-preview.nvim` may need npm), install as indicated in that plugin's README.

Customization pointers
- Colors: Many configs use Catppuccin Frappe; change to a different variant by setting the theme file for each terminal or Neovim plugin (`themes.lua` can be adjusted).
- LSP: Add servers to the mason UI or the `lsp` plugin file if you want explicit server options (e.g., `pyright`, `tsserver`, `eslint`, `tailwindcss`).
- Lazy-loading: `lua/config/lazy.lua` defaults `lazy = false` for custom plugins — if you want more aggressive lazy-loading, change that default.
- Fonts: Terminal configs include recommended font families. Use a patched Nerd Font for best icon support.

Contributing & troubleshooting
==============================
- If you want to contribute, open a PR with specific changes to a logical subdirectory (e.g., adjust `telescope.lua` or `lualine.lua`).
- For issues with plugins:
  - Run `nvim` and then `:checkhealth`.
  - Use `:Lazy log` or `:Lazy` to inspect plugin install errors.
- If a terminal font/glyphs look broken, verify the active font is a Nerd Font and fallback fonts are installed (`Noto Color Emoji`, etc.).

License & credits
=================
- The repository includes public plugins licensed individually (MIT, Apache, etc.). My personal config files are provided as-is (use or adapt at your own risk).

Files summary (quick map)
- Neovim: `nvim/init.lua`, `nvim/lua/config/*`, `nvim/lua/plugins/*`, `nvim/lua/utilities/*`
- Alacritty: `alacritty/alacritty.toml`
- WezTerm: `wezterm/.wezterm.lua`
- Kitty: `kitty/kitty.conf`, `kitty/current-theme.conf`
- tmux: `tmux/.tmux.conf`
- Git: `git/.gitconfig`
- Lazygit: `lazygit/config.yml`
- Eza: `eza/theme*.yml`
- Ghostty: `ghostty/config`
- Yazi: `yazi/yazi.toml`, `yazi/theme.toml`
- Zsh: `zsh/.zshrc`, `zsh/functions/*`
- PowerShell: `powershell/*.ps1`
- Prompt templates: `prompt-generator/templates/*`
- Theme examples: `themes/*`
