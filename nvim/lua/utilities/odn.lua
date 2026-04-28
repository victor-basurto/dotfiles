-- odn.lua — Obsidian Daily Note helpers for nvim
-- Source: ~/.config/.dotfiles/zsh/functions/odn.lua
--
-- Features:
--   <leader>td  — toggle task under cursor done/undone
--                 moves the line to the correct section
--                 and refreshes the <!-- task-summary --> footer

local M = {}

-- ── update the <!-- task-summary --> footer ───────────────────────────────
local function update_summary()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local total = 0
  local done = 0
  local undone = 0

  for _, line in ipairs(lines) do
    if line:match("^%- %[.%]") then
      total = total + 1
      if line:match("^%- %[x%]") then
        done = done + 1
      elseif line:match("^%- %[ %]") then
        undone = undone + 1
      end
    end
  end

  local summary = string.format("📋 Tasks: %d  |  ✅ Done: %d  |  🔲 Undone: %d", total, done, undone)

  -- find <!-- task-summary --> and replace the line after it
  for i, line in ipairs(lines) do
    if line:match("<!%-%- task%-summary %-%->") then
      vim.api.nvim_buf_set_lines(0, i, i + 1, false, { summary })
      break
    end
  end
end

-- ── toggle task done/undone and move between sections ────────────────────
local function toggle_task_done()
  local lnum = vim.api.nvim_win_get_cursor(0)[1] -- 1-indexed
  local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]

  if not line:match("^%- %[.%]") then
    vim.notify("Not a task line.", vim.log.levels.WARN)
    return
  end

  local all_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- ── mark done → move to ## Completed Tasks ───────────────────────────
  if line:match("^%- %[ %]") then
    local done_line = line:gsub("^%- %[ %]", "- [x]", 1)

    -- remove original line
    table.remove(all_lines, lnum)

    -- find ## Completed Tasks
    local insert_at = nil
    for i, l in ipairs(all_lines) do
      if l:match("^## Completed Tasks") then
        insert_at = i + 1
        -- skip a blank line if present
        if all_lines[insert_at] and all_lines[insert_at]:match("^%s*$") then
          insert_at = insert_at + 1
        end
        break
      end
    end

    if insert_at then
      table.insert(all_lines, insert_at, done_line)
    else
      table.insert(all_lines, done_line)
    end

    vim.notify("✅ Task moved to Completed", vim.log.levels.INFO)

  -- ── mark undone → move to ## Incomplete Tasks ────────────────────────
  elseif line:match("^%- %[x%]") then
    local undone_line = line:gsub("^%- %[x%]", "- [ ]", 1)

    table.remove(all_lines, lnum)

    local insert_at = nil
    for i, l in ipairs(all_lines) do
      if l:match("^## Incomplete Tasks") then
        insert_at = i + 1
        if all_lines[insert_at] and all_lines[insert_at]:match("^%s*$") then
          insert_at = insert_at + 1
        end
        break
      end
    end

    if insert_at then
      table.insert(all_lines, insert_at, undone_line)
    else
      table.insert(all_lines, undone_line)
    end

    vim.notify("🔲 Task moved back to Incomplete", vim.log.levels.INFO)
  end

  -- ── write lines back to buffer ───────────────────────────────────────
  vim.api.nvim_buf_set_lines(0, 0, -1, false, all_lines)

  -- ── refresh summary footer ────────────────────────────────────────────
  update_summary()

  -- ── save silently ─────────────────────────────────────────────────────
  vim.cmd("silent write")
end

-- ── setup: called when the file is opened via odn ────────────────────────
function M.setup()
  -- run summary once on load
  update_summary()

  -- buffer-local keymap: <leader>td
  vim.keymap.set("n", "<leader>td", toggle_task_done, {
    buffer = true,
    desc = "ODN: toggle task done / undone",
    silent = true,
  })

  vim.notify("  odn ready  │  <leader>td → toggle task", vim.log.levels.INFO)
end

return M
