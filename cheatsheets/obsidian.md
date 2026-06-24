# Obsidian Shell Workflow Cheatsheet

Custom Zsh functions for managing daily logs, inbox reviewing, Zettelkasten organization, and automated background backups directly from the terminal prompt.

---

## 📅 Daily Notes (`odn`)

Creates or opens a time-stamped work note structured inside your daily log directory hierarchy.

### Usage

- `odn` — Create/open today's note (initializes standard template if missing).
- `odn "Some task descriptive text"` — Open today's note and immediately append a standard Markdown task checklist item inside the file.

### Structure & Generation Path

- **Target Directory:** `$OBSIDIAN_VAULT/daily/YYYY/mmm/` (e.g., `.../daily/2026/jun/`)
- **Filename Format:** `YYYY-MM-DD_weekday.md` (e.g., `2026-06-23_tuesday.md`)
- **Terminal Output:** Generates an ASCII status summary block in your stdout tracking total, done, and undone checklist items upon exit.

---

## 📥 Note Creation & Inbox Processing (`on` / `or`)

Quickly generates isolated ideas or processes pending thoughts sitting in your incoming scratch space (`inbox/`).

### Usage

- `on "My New Note Title"` — Validates title input, auto-slugs spaces to dashes, touches the file, and runs non-interactive `nvim` setups to inject the designated Neovim template.
- `or` — Drops into the vault root, scans the `inbox/` directory via Zsh glob qualifiers (`*(.-N)`), and launches them directly into separate Neovim buffers for rapid processing. If the inbox is empty, it opens Neovim directly at the vault root.

### Automation Pipeline (`on`)

1. Transforms `"testing note"` ➔ `YYYY-MM-DD_testing-note.md`.
2. Capitalizes title segments for markdown headers (`# Testing Note`).
3. Invokes `nvim` command line switches to trigger the execution sequence (`-c "Obsidian template notes"`) and updates the layout text seamlessly.

---

## 🗂 Zettelkasten Organizer (`og`)

Scans flat metadata storage collections and distributes them recursively into domain-specific structured target paths.

### Usage

- `og` — Processes all elements found matching recursive paths within `zettelkasten/` mapping routines.

### Routing Logic (Frontmatter Parsing)

The function reads internal frontmatter metadata blocks via GNU `ggrep` strings to dynamically shift file placement targets:

| Frontmatter Key Pair                                       | Expected Resulting Directory Path      |
| :--------------------------------------------------------- | :------------------------------------- |
| `target_folder: sitecore`                                  | `$VAULT_DIR/notes/sitecore/`           |
| `target_folder: front-end`<br>`target_subfolder: tailwind` | `$VAULT_DIR/notes/front-end/tailwind/` |

> ⚠️ **System Dependencies:** Requires GNU Grep (`ggrep`) for Perl-Compatible Regular Expressions (`-P`). Install via Homebrew on macOS (`brew install grep`). Notes without a defined `target_folder` are safely skipped.

---

## 💾 Vault Backups (`bko`)

Creates point-in-time, timestamped snapshots of your primary knowledge directory workspace.

### Usage

- `bko` — Executes a full recursive background copy into your local archive file paths.

### Backup Specifications

- **Storage Location:** `~/backups/obsidian-work/backup-YYYY-MM-DD_HH-MM-SS/`
- **Output Metrics:** Logs exact operations to `~/backups/obsidian-backup.log` while showing human-readable workspace size changes (`du -sh`) and precise file counts inside your terminal stdout.
- **Rotation Engine:** Evaluates active history states. If matching archives exceed **8 total records**, it automatically cleans up the oldest iterations to optimize storage footprint.

---

## 🧭 Master Quick Reference

| No. | Title        | Description                                                                                                                                         |
| :-- | :----------- | :-------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | `bko`        | **Full Vault Backup:** Backs up the entire vault to local storage with automated 8-file rotation. Requires no parameters                            |
| 2   | `odn`        | **Daily Note Tool:** Opens/creates today's daily note layout. <br>•Smoothly initializes or opens today's note natively.                             |
| 3   | `on <title>` | **Inbox Note Generation:** Creates a unique `YYYY-MM-DD` note file.                                                                                 |
| 4   | `or`         | **Inbox Review Runner:** Opens all files inside `inbox` in Neovim Buffers                                                                           |
| 5   | `og`         | **Zettelkasten Organizer:** Runs frontmatter evaluation. If a file does not define a `target_folder` key, logs warning and skips the file entirely. |
