# 💤 LazyVim

## This Repo will be archived soon and replaced by the new DOTFILES repository

## Neovim Configuration Overview

This Neovim configuration enhances the editing experience with a selection of powerful plugins and custom key mappings.

### Key Mappings

These custom key mappings provide quick access to frequently used functions:

- **File Navigation:**
  - `\<leader>ff`: Opens Telescope to find files within the project.
  - `\<leader>fg`: Opens Telescope to live grep (search) for text within the project.
  - `\<leader>fb`: Opens Telescope to switch between open buffers.
  - `\<leader>fh`: Opens Telescope to search Neovim's help tags.
- **NeoTree (File Explorer):**
  - `\<leader>o`: Focuses the NeoTree file explorer, bringing it into focus.
- **NeoGen (Code Generation):**
  - `\<leader>ng`: Generates code snippets or boilerplate using NeoGen.

### Plugins

The following plugins are utilized to provide extended functionality:

- `alpha-nvim`: A fast and customizable startup screen.
- `catppuccin`: A warm and cozy color scheme.
- `conform`: A unified interface for code formatting.
- `lsp`: Configures Neovim's built-in Language Server Protocol (LSP) client for features like autocompletion and code navigation. (Note: This likely refers to `nvim-lspconfig` or a similar LSP configuration setup)
- `lualine`: A highly configurable and performant status line.
- `mason`: A package manager for installing LSP servers, DAP servers, linters, and formatters.
- `mini-surround`: Provides functionality for adding, deleting, and changing surrounding characters/tags.
- `navic`: Displays the code context (e.g., class, function) in the status line.
- `neo-tree`: A modern and feature-rich file explorer.
- `non-ls`: A plugin to configure non-LSP sources for formatting, linting, etc. (e.g., ESLint, Prettier).
- `telescope`: A highly extensible fuzzy finder.
- `treesitter`: Provides advanced syntax highlighting and code parsing.
- `ts-comments`: Provides functionality for toggling and manipulating comments in TypeScript and other languages.

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.
