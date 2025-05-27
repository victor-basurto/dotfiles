# My Personal PowerShell Configuration

This repository contains my personal PowerShell profile script, designed to enhance productivity and streamline my command-line workflow. It includes custom aliases, quick directory navigation functions, and integrations with popular tools like Posh-Git, Oh-My-Posh, Terminal-Icons, PSReadLine, and fzf.

This configuration is tailored to my specific needs and development environment, but you might find some useful ideas for your own setup!

## Quick Directory Navigation (Custom Functions)

I've set up several handy functions to quickly jump to frequently used directories. Just type the `Keyword` in your PowerShell terminal and press Enter.

| Keyword  | Description                           | Target Path                         |
| -------- | ------------------------------------- | ----------------------------------- |
| `oo`     | Obsidian-work vault                   | `~\\obsidian-work`                  |
| `vimdir` | nvim configuration directory          | `~\\AppData\\Local\\nvim`           |
| `psdir`  | PowerShell configuration directory    | `~\\.config\\powershell`            |
| `webdir` | Brookfield websites project directory | `~\\projects\\brookfield\\websites` |
| `xmdir`  | XMCloud project directory             | `~\\projects\\brookfield\\sitecore` |

You can also run the `list-dirs` function in your terminal to see this list at any time.

## Other Aliases

I've created several aliases for common commands to make typing faster:

- `vim`: Aliases `nvim` (NeoVim)

- `ll`: Aliases `ls` (list directory contents, often used for `Get-ChildItem`)

- `g`: Aliases `git`

- `grep`: Aliases `findstr` (Windows equivalent for searching text in files)

- `tig`: Aliases `C:\Program Files\Git\usr\bin\tig.exe` (a text-mode interface for Git)

- `less`: Aliases `C:\Program Files\Git\usr\bin\less.exe` (a file pager)

## PSReadLine & fzf Configuration

- **PSReadLine**: Configured with `Emacs` edit mode, no bell, `Ctrl+d` for deleting characters, and history-based prediction with a `ListView` style.

- **fzf**: Integrated for fuzzy finding with `Ctrl+f` for provider and `Ctrl+r` for reverse history search.

## How to Use (for your reference)

To use this configuration, you would typically:

1. Save the PowerShell script (e.g., as `Microsoft.PowerShell_profile.ps1`) in your PowerShell profile directory (you can find this by typing `$PROFILE` in PowerShell).

2. Ensure you have `posh-git`, `oh-my-posh`, `Terminal-Icons`, and `PSFzf` modules installed.

3. Place your `zeus.omp.json` theme file (or your own `<file-name>.omp.json` file) in the same directory as your profile script.

4. Restart your PowerShell terminal.

Feel free to adapt any part of this script to your own preferences!
