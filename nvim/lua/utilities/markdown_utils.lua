-- /lua/utilities/markdown_utils.lua
local M = {}
-------------------------------------------------------------------------------
--                       Markdown Headings Local Function
-------------------------------------------------------------------------------

--- Folds all headings of a specific level in the current buffer.
--- Iterates through every line in the file, and for any line that matches
--- a markdown heading of the given level (e.g. "## " for level 2), it moves
--- the cursor there and closes the fold if one exists and is currently open.
--- Uses keepjumps to avoid polluting the jumplist.
---@param level number The heading level to fold (1-6), where 1 = H1, 2 = H2, etc.
function M.fold_headings_of_level(level)
  vim.cmd("keepjumps normal! gg")
  local total_lines = vim.fn.line("$")
  for line = 1, total_lines do
    local line_content = vim.fn.getline(line)
    if line_content:match("^" .. string.rep("#", level) .. "%s") then
      vim.cmd(string.format("keepjumps call cursor(%d, 1)", line))
      local current_foldlevel = vim.fn.foldlevel(line)
      if current_foldlevel > 0 then
        if vim.fn.foldclosed(line) == -1 then
          vim.cmd("normal! za")
        end
      end
    end
  end
end

--- Folds markdown headings based on specified levels.
--- Saves the current view (cursor position, scroll, etc.), then iterates
--- through the provided `levels` table and folds all headings at each level
--- using `fold_headings_of_level`. Clears search highlighting and restores
--- the original view afterward so the cursor returns to where it started.
---@param levels table A table of heading levels to fold (e.g. `{6,5,4,3,2,1}`).
function M.fold_markdown_headings(levels)
  local saved_view = vim.fn.winsaveview()
  for _, level in ipairs(levels) do
    M.fold_headings_of_level(level)
  end
  vim.cmd("nohlsearch")
  vim.fn.winrestview(saved_view)
end

-------------------------------------------------------------------------------
--                  Markdown Headings section
-------------------------------------------------------------------------------

--- Returns line numbers and levels for the current, next, and next same-level headings.
--- Uses treesitter to parse the markdown AST and locate all ATX headings (H1-H6).
--- "Current" is the heading whose section the cursor is inside. "Next" is the
--- immediately following heading regardless of level. "Next same-level" is the
--- next heading that shares the same level as the current one.
---@return number|nil cl   Line number of the current heading
---@return number|nil clvl Level of the current heading (1-6)
---@return number|nil nl   Line number of the next heading
---@return number|nil nlvl Level of the next heading (1-6)
---@return number|nil nsl  Line number of the next same-level heading
---@return number|nil nslvl Level of the next same-level heading (1-6)
function M.get_markdown_headings()
  local cursor_line = vim.fn.line(".")
  local parser = vim.treesitter.get_parser(0, "markdown")
  if not parser then
    vim.notify("Markdown parser not available", vim.log.levels.ERROR)
    return nil, nil, nil, nil, nil, nil
  end
  local tree = parser:parse()[1]
  local query = vim.treesitter.query.parse(
    "markdown",
    [[
    (atx_heading (atx_h1_marker) @h1)
    (atx_heading (atx_h2_marker) @h2)
    (atx_heading (atx_h3_marker) @h3)
    (atx_heading (atx_h4_marker) @h4)
    (atx_heading (atx_h5_marker) @h5)
    (atx_heading (atx_h6_marker) @h6)
  ]]
  )
  local headings = {}
  for id, node in query:iter_captures(tree:root(), 0) do
    local start_line = node:start() + 1
    table.insert(headings, { line = start_line, level = id })
  end
  table.sort(headings, function(a, b)
    return a.line < b.line
  end)
  local current_heading, current_idx, next_heading, next_same_heading
  for idx, h in ipairs(headings) do
    if h.line <= cursor_line then
      current_heading = h
      current_idx = idx
    elseif not next_heading then
      next_heading = h
    end
  end
  if current_heading then
    for i = current_idx + 1, #headings do
      local h = headings[i]
      if h.level == current_heading.level then
        next_same_heading = h
        break
      end
    end
  end
  return current_heading and current_heading.line or nil,
    current_heading and current_heading.level or nil,
    next_heading and next_heading.line or nil,
    next_heading and next_heading.level or nil,
    next_same_heading and next_same_heading.line or nil,
    next_same_heading and next_same_heading.level or nil
end

-------------------------------------------------------------------------------
--                           Folding section
-------------------------------------------------------------------------------

--- Fold expression used by Neovim's folding engine for markdown buffers.
--- Assigned via `foldexpr=v:lua.markdown_foldexpr()` in `set_markdown_folding`.
--- Returns a fold level string for each line: ">N" opens a fold of depth N,
--- "=" continues the previous fold level. H1 is treated specially — it only
--- opens a fold when it appears at line 1 or immediately after frontmatter.
--- Registered as a global to satisfy the string-based foldexpr requirement.
if not _G.markdown_foldexpr then
  function _G.markdown_foldexpr()
    local lnum = vim.v.lnum
    local line = vim.fn.getline(lnum)
    local heading = line:match("^(#+)%s")
    if heading then
      local level = #heading
      if level == 1 then
        if lnum == 1 then
          return ">1"
        else
          local frontmatter_end = vim.b.frontmatter_end
          if frontmatter_end and (lnum == frontmatter_end + 1) then
            return ">1"
          end
        end
      elseif level >= 2 and level <= 6 then
        return ">" .. level
      end
    end
    return "="
  end
end

--- Configures buffer-local folding settings for markdown files.
--- Sets foldmethod to "expr" using `markdown_foldexpr`, and foldlevel to 99
--- so all folds start open. Also scans the buffer for YAML frontmatter
--- (delimited by "---") and stores the closing line number in `vim.b.frontmatter_end`
--- so the fold expression can handle H1 headings that follow frontmatter correctly.
function M.set_markdown_folding()
  vim.opt_local.foldmethod = "expr"
  vim.opt_local.foldexpr = "v:lua.markdown_foldexpr()"
  vim.opt_local.foldlevel = 99

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local found_first = false
  local frontmatter_end = nil
  for i, line in ipairs(lines) do
    if line == "---" then
      if not found_first then
        found_first = true
      else
        frontmatter_end = i
        break
      end
    end
  end
  vim.b.frontmatter_end = frontmatter_end
end

-------------------------------------------------------------------------------
--                         Keymap Callbacks
-------------------------------------------------------------------------------

--- Displays a notification showing the current, next, and next same-level
--- heading relative to the cursor. Each heading is shown with its level (H1-H6)
--- and line number. Shows "Not in a section" if the cursor is before any heading.
function M.show_markdown_headings()
  local cl, clvl, nl, nlvl, nsl, nslvl = M.get_markdown_headings()
  local message_parts = {}
  if cl then
    table.insert(message_parts, string.format("Current: H%d (line %d)", clvl, cl))
  else
    table.insert(message_parts, "Not in a section")
  end
  if nl then
    table.insert(message_parts, string.format("Next: H%d (line %d)", nlvl, nl))
  end
  if nsl then
    table.insert(message_parts, string.format("Next H%d: line %d", nslvl, nsl))
  end
  vim.notify(table.concat(message_parts, " | "), vim.log.levels.INFO)
end

--- Toggles markdown strikethrough (`~text~`) on the current line.
--- If the line is already wrapped in tildes, removes them. Otherwise wraps
--- the trimmed line content in tildes, preserving any leading indentation.
--- Does nothing if the line is empty or whitespace only.
function M.toggle_strikethrough()
  local line = vim.fn.getline(".")
  local trimmed = line:match("^%s*(.-)%s*$")
  if trimmed == "" then
    return
  end
  local indent = line:match("^(%s*)")
  if trimmed:match("^~.*~$") then
    local content = trimmed:match("^~(.*)~$")
    vim.fn.setline(".", indent .. content)
  else
    vim.fn.setline(".", indent .. "~" .. trimmed .. "~")
  end
end

--- Toggles the fold under the cursor, bound to `<CR>` in normal mode.
--- Centers the screen after opening or closing. Notifies if no fold exists
--- at the current line.
function M.toggle_fold_cr()
  local line = vim.fn.line(".")
  local foldlevel = vim.fn.foldlevel(line)
  if foldlevel == 0 then
    vim.notify("No fold found", vim.log.levels.INFO)
  else
    vim.cmd("normal! za")
    vim.cmd("normal! zz")
  end
end

--- Replaces spaces in the text portion of a markdown heading with dashes.
--- Only affects lines that start with one or more `#` characters followed by
--- a space. The hashes and leading structure are preserved; only the heading
--- text itself has its spaces converted (e.g. `## My Heading` → `## My-Heading`).
function M.dashes_to_heading()
  local line = vim.api.nvim_get_current_line()
  local new_line = line:gsub("^(#+)%s+(.*)", function(hashes, text)
    return hashes .. " " .. text:gsub("%s+", "-")
  end)
  vim.api.nvim_set_current_line(new_line)
end

--- Saves the buffer, reloads it, unfolds everything, folds headings at the
--- specified levels, then centers the screen. Intended as the handler for
--- the `<leader>mf1`–`<leader>mf4` keymaps, each passing a different level set.
---@param levels table Heading levels to fold, e.g. `{6,5,4,3,2,1}` for level 1+.
function M.fold_headings_cmd(levels)
  vim.cmd("silent update")
  vim.cmd("edit!")
  vim.cmd("normal! zR")
  M.fold_markdown_headings(levels)
  vim.cmd("normal! zz")
end

--- Saves the buffer, reloads it, and unfolds all folds (`zR`), then centers
--- the screen. Useful for resetting fold state to fully expanded.
function M.unfold_all()
  vim.cmd("silent update")
  vim.cmd("edit!")
  vim.cmd("normal! zR")
  vim.cmd("normal! zz")
end

--- Folds the markdown heading the cursor is currently inside.
--- Moves up one line with `gk` first to land on the heading marker itself
--- before closing the fold, then centers the screen.
function M.fold_current_heading()
  vim.cmd("silent update")
  vim.cmd("normal gk")
  vim.cmd("normal! za")
  vim.cmd("normal! zz")
end

--- Toggles the fold at the current cursor line and centers the screen.
--- Notifies if no fold exists at the current line. Similar to `toggle_fold_cr`
--- but intended for the explicit `<leader>mft` keymap rather than `<CR>`.
function M.toggle_fold()
  local line = vim.fn.line(".")
  local foldlevel = vim.fn.foldlevel(line)
  if foldlevel == 0 then
    vim.notify("No fold found", vim.log.levels.INFO)
  else
    vim.cmd("normal! za")
    vim.cmd("normal! zz")
  end
end

-------------------------------------------------------
--     Clipboard Regex to Select all Checkboxes
--             in Markdown Files
-------------------------------------------------------

--- Copies a vim substitution regex to the system clipboard that matches
--- unchecked markdown checkboxes (`- [ ] `). Paste into the command line
--- to use as the start of a bulk substitution on checkbox items.
function M.copy_checkbox_regex()
  local chkbx_cmd = [[%s/\v^\s*-\s\[\s\]\s/]]
  vim.fn.setreg("+", chkbx_cmd)
  print("Copied regex: " .. chkbx_cmd)
end

return M
