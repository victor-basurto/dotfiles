# My Dotfiles

Welcome to my dotfiles repository! This collection of configuration files helps me maintain a consistent and efficient development environment across my favorite operating systems: **Ubuntu**, **macOS**, and **Windows**.

## Overview

This repository is organized to clearly delineate configurations specific to each operating system, as well as those that are cross-platform compatible. My goal is to provide a seamless experience, whether I'm on my Ubuntu (Linux), MacOS, or Windows.

## Structure

```
├── eza
│ ├── theme-catppuccin.yml
│ └── theme.yml
├── nvim
│ ├── lua
│ │ ├── config
│ │ │ ├── autocmds.lua
│ │ │ ├── keymaps.lua
│ │ │ ├── lazy.lua
│ │ │ └── options.lua
│ │ ├── plugins
│ │ │ ├── alpha-nvim.lua
│ │ │ ├── catppuccin.lua
│ │ │ ├── conform.lua
│ │ │ ├── example.lua
│ │ │ ├── git-nvim.lua
│ │ │ ├── hipatterns.lua
│ │ │ ├── lsp.lua
│ │ │ ├── lualine.lua
│ │ │ ├── markdown.lua
│ │ │ ├── mason-workaround.lua
│ │ │ ├── mason.lua
│ │ │ ├── mini-surround.lua
│ │ │ ├── multicursor.lua
│ │ │ ├── navic.lua
│ │ │ ├── noice.lua
│ │ │ ├── none-ls.lua
│ │ │ ├── obsidian.lua
│ │ │ ├── telescope.lua
│ │ │ ├── terminal.lua
│ │ │ ├── treesitter.lua
│ │ │ ├── ts-comments.lua
│ │ │ └── ui.lua
│ │ └── utilities
│ │ ├── delete_current_buffer_win.lua
│ │ └── discipline.lua
│ ├── .gitignore
│ ├── init.lua
│ ├── lazy-lock.json
│ ├── lazyvim.json
│ ├── LICENSE
│ ├── README.md
│ └── stylua.toml
├── powershell
│ ├── .gitignore
│ ├── on_obsidian_util.ps1
│ ├── README.md
│ ├── utils.ps1
│ └── viktor_profile.ps1
├── zsh
│ └── functions
│ ├── custom-dirs.zsh
│ ├── on.zsh
│ └── utils.zsh
├── .gitignore
├── .p10k.zsh
└── config
```

---

## System-Specific Configurations

### 🐧 **Ubuntu &** 🍎 **macOS**

The following configurations are primarily designed for and tested on Ubuntu and macOS.

- **`zsh/`**: Contains my **Zsh** shell configurations.
  - **`functions/`**: Custom Zsh functions to enhance productivity.
    - `custom-dirs.zsh`: Defines custom directory aliases and shortcuts for quick navigation.
    - `on.zsh`: Utility functions for activating specific project environments or tasks. **This file also includes utilities for creating new Obsidian notes directly from the terminal (iTerm, Ghostty, etc.), mirroring the functionality of `powershell/on_obsidian_util.ps1`.**
    - `utils.zsh`: General-purpose utility functions for common shell operations.
- **`.p10k.zsh`**: Configuration for the **Powerlevel10k Zsh theme**, providing a highly customizable and aesthetically pleasing prompt. This file tailors the prompt's appearance, information display, and overall behavior.
- **`config/`**: Configuration files for **Ghostty**, my preferred GPU-accelerated terminal emulator, ensuring a smooth and responsive terminal experience.

---

### 🪟 **Windows**

These configurations are specifically for optimizing my workflow on Windows.

- **`powershell/`**: My custom **PowerShell** profiles and scripts.
  - `on_obsidian_util.ps1`: Utility script for interacting with Obsidian, specifically designed for creating new notes directly from the PowerShell terminal.
  - `utils.ps1`: General utility functions and aliases for PowerShell.
  - `viktor_profile.ps1`: My main PowerShell profile, containing aliases, functions, and environment settings.

---

## Cross-Platform Configurations (Ubuntu, macOS, & Windows)

These configurations are designed to work seamlessly across all three operating systems, providing a consistent experience for core tools.

- **`eza/`**: Configuration files for **`eza`**, a modern, feature-rich `ls` replacement.
  - `theme-catppuccin.yml`: Defines the Catppuccin color scheme for `eza`, providing a visually appealing and consistent look.
  - `theme.yml`: The primary theme configuration for `eza` (TokyoNight as primary theme).
- **`nvim/`**: My **Neovim** configuration, providing a powerful and highly customized text editing environment. This setup uses a modular approach with `lua` for configuration.
  - **`lua/`**: Contains the core Lua configurations for Neovim.
    - **`config/`**: Fundamental Neovim settings.
      - `autocmds.lua`: Defines automatic commands for various events (e.g., file type specific settings, saving).
      - `keymaps.lua`: Custom keybindings to enhance navigation and editing efficiency.
      - `lazy.lua`: Configuration for `lazy.nvim`, my plugin manager, ensuring efficient and declarative plugin loading.
      - `options.lua`: General Neovim options for behavior, appearance, and performance.
    - **`plugins/`**: Individual plugin configurations. This directory contains a wide array of plugins for features like:
      - `alpha-nvim.lua`: A startup screen for Neovim.
      - `catppuccin.lua`: The Catppuccin color scheme integration for Neovim.
      - `conform.lua`: Integrates various formatters into Neovim.
      - `example.lua`: an example or template plugin configuration.
      - `git-nvim.lua`: Git integration within Neovim.
      - `hipatterns.lua`: Highlights patterns in text.
      - `lsp.lua`: Language Server Protocol (LSP) client configuration for intelligent code completion, diagnostics, and more.
      - `lualine.lua`: Configuration for `lualine.nvim`, a fast and highly customizable statusline.
      - `markdown.lua`: Enhanced Markdown support.
      - `mason-workaround.lua`: Workaround for `mason.nvim`.
      - `mason.lua`: Configuration for `mason.nvim`, a universal package manager for language servers, formatters, and linters.
      - `mini-surround.lua`: Text object surrounding utilities.
      - `multicursor.lua`: Multi-cursor editing capabilities.
      - `navic.lua`: Displays current function/context in statusline.
      - `noice.lua`: Enhanced Neovim messages and popups.
      - `none-ls.lua`: Integrates various linters and formatters without requiring a dedicated LSP server.
      - `obsidian.lua`: Integration with Obsidian for note-taking.
      - `telescope.lua`: Configuration for `telescope.nvim`, a highly extensible fuzzy finder.
      - `terminal.lua`: Terminal integration within Neovim.
      - `treesitter.lua`: Configuration for `nvim-treesitter`, providing syntax highlighting and structural editing.
      - `ts-comments.lua`: Enhanced comment toggling with Tree-sitter.
      - `ui.lua`: General UI enhancements and configurations.
    - **`utilities/`**: Helper scripts or functions for Neovim.
      - `delete_current_buffer_win.lua`: A utility to delete the current buffer and close its window.
      - `discipline.lua`: (Potentially a plugin or script related to focus or workflow discipline within Neovim).
  - `init.lua`: The main entry point for the Neovim configuration.
  - `lazyvim.json`: Configuration related to LazyVim, a starter template for Neovim.
  - `stylua.toml`: Configuration for `stylua`, a Lua formatter.

---

## Installation

**(Coming Soon: Detailed installation instructions for each OS)**

Symlink for relevant dotfiles to your home directory or the appropriate configuration locations.The operating system differences when creating symlinks, especially on Windows.

## Contributing

Feel free to fork this repository and adapt these dotfiles to your own needs. If you have suggestions for improvements or find issues, please open an issue or submit a pull request.
