#! /.config/.dotfiles/zsh/functions/daily-notes.zsh
# main note directory: holds all of my daily notes

# TODO: add functionality to open both personal and work vaults
# main_note_dir=~/vaults/work/daily
main_note_dir="$OBSIDIAN_VAULT/daily" # work vault

# ------------------------------------------------------------
# odn — Obsidian Daily Note
#
# Usage:
#   odn              → create/open today's note (no extra content)
#   odn "some text"  → create/open today's note and append text
# ------------------------------------------------------------
function odn() {
  # ── date components ──────────────────────────────────────
  local current_year=$(date +"%Y")
  local current_month_num=$(date +"%m")
  local current_month_abbr=$(date +"%b" | tr '[:upper:]' '[:lower:]')
  local current_day=$(date +"%d")
  local current_weekday=$(date +"%A" | tr '[:upper:]' '[:lower:]')
  local full_date=$(date +"%Y-%m-%d")

  # ── paths ────────────────────────────────────────────────
  local note_dir="${main_note_dir}/${current_year}/${current_month_abbr}"
  local note_name="${full_date}_${current_weekday}"
  local full_path="${note_dir}/${note_name}.md"

  # ── create directory if needed ───────────────────────────
  mkdir -p "${note_dir}"

  # ── write template only if file doesn't exist yet ────────
  if [[ ! -f "${full_path}" ]]; then
    cat > "${full_path}" <<EOF
---
id: ${full_date}_Obsidian-Daily-Notes
aliases:
  - odn
  - daily-logs
tags:
  - daily-notes
date: ${full_date}
hubs:
  - "[[daily-notes]]"
parent:
  - work
urls: []
---
# ${full_date} (${current_weekday})

## WORK DAILY NOTE

## Incomplete Tasks
- [ ] ${current_weekday} initial log

## Completed Tasks

---
📋 Tasks: 0  |  ✅ Done: 0  |  🔲 Undone: 0
EOF
    echo "✓ Created: ${full_path}"
  else
    echo "✓ Note exists: ${full_path}"
  fi

  # ── append optional inline note as a task ────────────────
  if [[ -n "$1" ]]; then
    local tmp=$(mktemp)
    # Target the 'Incomplete Tasks' header specifically to match the PS1 behavior
    awk -v task="- [ ] $1" '
      /^## Incomplete Tasks/ {
        print $0
        print task
        next
      }
      { print }
    ' "${full_path}" > "$tmp" && mv "$tmp" "${full_path}"
    echo "  ↳ Appended task: \"$1\""
  fi

  # ── write summary into file footer ───────────────────────
  _odn_task_summary "${full_path}"

  # ── open in nvim ─────────────────────────────────────────
  nvim -c "lua require('utils.odn').setup()" "${full_path}"
}

# ------------------------------------------------------------
# _odn_task_summary
#   - Counts tasks in the file
#   - Updates the <!-- task-summary --> block at the bottom
#   - Also prints the box to the terminal
# ------------------------------------------------------------
function _odn_task_summary() {
  local file="$1"
  local total done_count undone

  total=$(grep -c '^\- \[.\]' "${file}" 2>/dev/null || echo 0)
  done_count=$(grep -c '^\- \[x\]' "${file}" 2>/dev/null || echo 0)
  undone=$(grep -c '^\- \[ \]' "${file}" 2>/dev/null || echo 0)

  # ── update summary block inside the file ─────────────────
  local summary_line="📋 Tasks: ${total}  |  ✅ Done: ${done_count}  |  🔲 Undone: ${undone}"
  local tmp=$(mktemp)
  awk -v line="${summary_line}" '
    // { print; print line; skip=1; next }
    // { skip=0 }
    !skip { print }
  ' "${file}" > "$tmp" && mv "$tmp" "${file}"

  # ── print summary box to terminal ────────────────────────
  echo ""
  echo "  ┌─────────────────────────────┐"
  printf "  │  📋 Tasks    %-3s             │\n" "${total}"
  printf "  │  ✅ Done     %-3s             │\n" "${done_count}"
  printf "  │  🔲 Undone   %-3s             │\n" "${undone}"
  echo "  └─────────────────────────────┘"
  echo ""
}
