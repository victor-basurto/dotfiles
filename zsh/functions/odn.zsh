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
  local current_year=$(date +"%Y")
  local current_month_abbr=$(date +"%b" | tr '[:upper:]' '[:lower:]')
  local current_weekday=$(date +"%A" | tr '[:upper:]' '[:lower:]')
  local full_date=$(date +"%Y-%m-%d")

  local note_dir="${main_note_dir}/${current_year}/${current_month_abbr}"
  local note_name="${full_date}_${current_weekday}"
  local full_path="${note_dir}/${note_name}.md"

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
  fi

  if [[ -n "$1" ]]; then
    local tmp=$(mktemp)
    # Appends new tasks safely under the header
    awk -v task="- [ ] $1" '
      /^## Incomplete Tasks/ { print; print task; next }
      { print }
    ' "${full_path}" > "$tmp" && mv "$tmp" "${full_path}"
  fi

  _odn_task_summary "${full_path}"
  nvim -c "lua require('utilities.odn').setup()" "${full_path}"
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

  local summary_line="📋 Tasks: ${total}  |  ✅ Done: ${done_count}  |  🔲 Undone: ${undone}"

  # Replace the stat line in-place — targets the emoji prefix specifically
  perl -i -pe "s/^📋 Tasks:.*\$/${summary_line}/" "${file}"

  echo ""
  echo "  ┌─────────────────────────────┐"
  printf "  │  📋 Tasks    %-3s             │\n" "${total}"
  printf "  │  ✅ Done     %-3s             │\n" "${done_count}"
  printf "  │  🔲 Undone   %-3s             │\n" "${undone}"
  echo "  └─────────────────────────────┘"
  echo ""
}
