---
name: dotfiles-nvim
description: |
  Neovim configuration in ~/.config/.dotfiles/nvim.
  Use when the user asks about Neovim setup, keymaps, plugins, LSP, formatting,
  markdown editing, Obsidian integration, Treesitter, or any nvim-related changes.
  Covers the full config: lazy.nvim, LazyVim, 30+ plugin specs, and keymaps.
---

# Neovim Configuration

**Location:** `~/.config/.dotfiles/nvim/`

## Architecture

Uses **lazy.nvim** (folke) as plugin manager with **LazyVim** as the base
distribution. Plugins are configured as individual spec files under `lua/plugins/`.

```
nvim/
├── init.lua                       -- Entry point
├── lazy-lock.json                 -- 78 locked plugins
├── lazyvim.json                   -- LazyVim extras registry
├── stylua.toml
├── lua/
│   ├── config/
│   │   ├── lazy.lua               -- Lazy.nvim bootstrap + LazyVim import
│   │   ├── options.lua            -- Editor options
│   │   ├── keymaps.lua            -- 752 lines of keymaps
│   │   └── autocmds.lua           -- Autocommands
│   ├── plugins/                   -- 30 plugin spec files
│   │   ├── ai-code.lua            -- OpenCode.nvim integration
│   │   ├── alpha-nvim.lua         -- Dashboard (disabled — Snacks handles it)
│   │   ├── blink.lua              -- Blink.cmp completion (v2.x)
│   │   ├── conform.lua            -- Formatting (stylua, prettier, markdownlint)
│   │   ├── fzf-lua.lua            -- Disabled (Snacks picker replaces it)
│   │   ├── git-nvim.lua           -- Fugitive + gitsigns
│   │   ├── hipatterns.lua         -- Mini.hipatterns (Tailwind CSS colors)
│   │   ├── lualine.lua            -- Custom statusline
│   │   ├── luasnip.lua            -- Snippets (friendly-snippets + custom markdown)
│   │   ├── markdown.lua           -- Markdown preview, render, TOC, folding
│   │   ├── mason.lua              -- LSP/formatter/linter installer
│   │   ├── mini-surround.lua      -- Mini.surround (gsa/gsd/gsf/gsr)
│   │   ├── multicursor.lua        -- Multicursors
│   │   ├── navic.lua              -- Navic code context
│   │   ├── noice.lua              -- Noice UI (cmdline popup, notifications)
│   │   ├── none-ls.lua            -- None-ls (eslint diagnostics)
│   │   ├── nvim-dap.lua           -- DAP (JS/TS debugging)
│   │   ├── obsidian.lua           -- Obsidian.nvim vault integration
│   │   ├── snacks.lua             -- Snacks.nvim (picker, dashboard, image rendering)
│   │   ├── snips.lua              -- nvim-cmp config (disabled — Blink wins)
│   │   ├── sticky.lua             -- Fusen.nvim sticky annotations
│   │   ├── telescope.lua          -- Telescope (disabled — Snacks picker)
│   │   ├── terminal.lua           -- Terminal integration
│   │   ├── themes.lua             -- Catppuccin (macchiato, transparent)
│   │   ├── treesitter.lua         -- Treesitter (28 parsers, textobjects)
│   │   ├── ts-comments.lua        -- Treesitter-based commenting
│   │   └── ui.lua                 -- Bufferline, colorful-menu, etc.
│   └── utilities/                 -- Helper Lua modules
│       ├── discipline.lua         -- Repeated-keys nag
│       ├── lsp_utils.lua          -- LSP helpers
│       ├── markdown_utils.lua     -- Markdown folding engine
│       ├── obsidian_utils.lua     -- Cross-platform Obsidian vault paths
│       ├── odn.lua                -- Obsidian daily note integration
│       └── utils.lua              -- General utilities
```

## Picker: Snacks.nvim (replaces Telescope + fzf-lua + alpha-nvim)

- Vertical layout (85%w x 95%h, preview top, list bottom)
- Keymaps: `<leader>ff` (files), `<leader>fg` (grep), `<leader>fb` (buffers), etc.
- Dashboard with ASCII art, GitHub notifications, issues/PRs panels, git status widget
- Image rendering (png, jpg, gif, bmp, webp, pdf) with Obsidian vault path resolution
- LazyGit integration via `<leader>glg`

## Completion: Blink.cmp (v2.x)

- Sources: lazydev, lsp, path, snippets, buffer
- Snippets triggered by `;` prefix
- Fuzzy implementation: `"lua"` (avoids .dll issues on Windows)
- Ghost text, signature help, cmdline completion

## LSP (via mason.nvim v2)

**Installed servers:** astro, bashls, cssls, eslint, graphql, html, jsonls, lua_ls,
powershell_es, prismals, sqlls, ts_ls, vimls, lemminx, yamlls, omnisharp

**Key customizations:**
- **omnisharp:** Full Roslyn analyzers, decompilation, editorconfig, cross-platform .NET SDK detection
- **lua_ls:** LazyVim library paths, inlay hints (param names, array indices)
- **ts_ls:** Inlay hints (param names, function types, variable types)
- **jsonls:** Custom schemas for Sitecore config files (sitecore.json, *.module.json)
- **powershell_es:** Mason-managed PowerShell Editor Services
- **marksman:** Only loaded outside Obsidian vaults

## Formatting (conform.nvim)

- `stylua` → Lua, `prettier` → JS/TS/CSS/SCSS/JSON/YAML
- Markdown: `prettier` + `markdownlint-cli2` + `markdown-toc` (conditional)
- Linting: `eslint_d` via `nvim-lint` for JS/TS on write/save
- Keymap: `<leader>ccf`

## Treesitter

28 parsers installed (astro, bash, css, c_sharp, razor, go, graphql, html, http,
javascript, json, json5, lua, markdown, markdown_inline, powershell, prisma, regex,
scss, sql, tsx, typescript, vim, vimdoc, xml, yaml, git-related)

Textobjects: `af`/`if` (function), `ac`/`ic` (class)

## Markdown Power-User Setup

- **render-markdown.nvim:** Heading icons (6 levels), borders, code block styling,
  auto-strikethrough for `[x]` checkboxes, custom H1-H6 background colors
- **markdown-preview.nvim:** Browser preview (`<leader>mrt`)
- **markdown-toc.nvim:** Dual TOC formats — browser-compatible (`<leader>motoC`)
  and Obsidian wikilinks (`<leader>motoc`)
- **Custom folding:** Treesitter-based markdown folding by heading level
  (`zj`/`zk`/`zl`/`z;` for fold levels, `zu` to unfold all)
- **Snippets:** Markdown code blocks, link templates, TODO items, JSDoc, callouts

## Obsidian Integration

Full vault workflow via `obsidian.nvim`:
- Workspaces: `ObsidianWork` and `ObsidianWorkArchive`
- Custom frontmatter: id, aliases, tags, date, links, target_folder, target_subfolder, urls
- Note ID format: `YYYY-MM-DD-title`
- Picker: Snacks
- Footer with backlinks/properties/words/chars
- Cross-platform vault path detection (macOS/Windows)

## Keymaps (notable)

| Keymap | Action |
|---|---|
| `<leader>ff` | Find files (Snacks) |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `K` | LSP hover |
| `gd` / `gr` | LSP definition / references |
| `<leader>rn` | Incremental rename |
| `<leader>ccf` | Format file |
| `<leader>glg` | Open LazyGit |
| `<leader>motoC` | Insert browser TOC |
| `<leader>motoc` | Insert Obsidian TOC |
| `<leader>oin` | Insert notes template |
| `<leader>oit` | Insert todo template |
| `<leader>oBl` | Show backlinks |
| `<leader>ok` | Move file to zettelkasten |
| `<leader>oa` | OpenCode ask with @this |
| `<leader>os` | OpenCode select |

## JavaScript/TypeScript Debugging (nvim-dap)

- Supports: pwa-node (launch file), pwa-chrome, pwa-msedge (with URL prompt)
- DAP UI auto-opens on attach/launch, closes on terminate

## AI Coding: OpenCode.nvim

- Keymaps: `<leader>oa` (ask with `@this`), `<leader>os` (select),
  `go` (operator), `goo` (line), `S-C-u`/`S-C-d` (scroll)
