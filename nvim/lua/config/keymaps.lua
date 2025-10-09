-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local opts = { noremap = true, silent = true }
local keymap = vim.keymap
-- discipline, custom plugin inspired by `craftzdog-max/devaslife`
-------------------------------------------------------
--               Discipline
-------------------------------------------------------
local discipline = require("utilities.discipline")
discipline.strict()
-------------------------------------------------------
--              END Discipline
-------------------------------------------------------
-------------------------------------------------------
--              Todo-Comments
-------------------------------------------------------
keymap.set("n", "<leader>tct", ":TodoTelescope <cr>", { desc = "[TODO] TodoTelescope find" })
keymap.set("n", "<leader>tcq", ":TodoQuickFix <cr>", { desc = "[TODO] TodoQuickFix fix" })
keymap.set("n", "<leader>tcl", ":TodoLocList <cr>", { desc = "[TODO] TodoLocList show all" })
keymap.set("n", "<leader>tcf", ":Trouble todo <cr>", { desc = "[TODO] use Troubles filtering show all" })
-------------------------------------------------------
--              END Todo-Comments
-------------------------------------------------------
-------------------------------------------------------
--              Trouble
-------------------------------------------------------
keymap.set("n", "<leader>ttd", ":Trouble diagnostics <cr>", { desc = "[TROUBLE] Diagnostics" })
keymap.set(
  "n",
  "<leader>ttx",
  ":Trouble diagnostics toggle filter.bug=0<cr>",
  { desc = "[TROUBLE] Buffer Diagnostics" }
)
keymap.set("n", "<leader>ttf", ":Trouble symbols toggle focus=false<cr>", { desc = "[TROUBLE] Symbols" })
keymap.set(
  "n",
  "<leader>ttl",
  ":Trouble lsp toggle focus=false win.position=right <cr>",
  { desc = "[TROUBLE] LSP Definitions/references/..." }
)
keymap.set("n", "<leader>ttL", ":Trouble loclist toggle <cr>", { desc = "[TROUBLE] Location List" })
keymap.set("n", "<leader>ttQ", ":Trouble qflist toggle <cr>", { desc = "[TROUBLE] QuickFix List" })

-------------------------------------------------------
--              END Trouble
-------------------------------------------------------
-------------------------------------------------------
--               Telescope
-------------------------------------------------------
local telescopeBuiltin = require("telescope.builtin")
local telescope = require("telescope")
keymap.set("n", "<leader>fx", telescopeBuiltin.find_files, { desc = "Telescope find files" })
keymap.set("n", "<leader>fg", telescopeBuiltin.live_grep, { desc = "Telescope live grep" })
keymap.set("n", "<leader>fb", telescopeBuiltin.buffers, { desc = "Telescope buffers" })
keymap.set("n", "<leader>fh", telescopeBuiltin.help_tags, { desc = "Telescope help tags" })
keymap.set("n", "<leader>fi", telescopeBuiltin.resume, { desc = "Telescope resume" })
keymap.set("n", "<leader>fj", telescopeBuiltin.diagnostics, { desc = "Telescope diagnostics" })
keymap.set("n", "<leader>fk", telescopeBuiltin.treesitter, { desc = "Telescope treesitter" })
keymap.set("n", "<leader>fI", telescopeBuiltin.lsp_definitions, { desc = "Telescope Got to LSP Implementation" })
keymap.set("n", "<leader>fd", telescopeBuiltin.lsp_type_definitions, { desc = "Telescope Got to Type Definition" })
keymap.set("n", "<leader>fl", function()
  local function telescope_buffer_dir()
    return vim.fn.expand("%:p:h")
  end
  telescope.extensions.file_browser.file_browser({
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    previewer = false,
    initial_mode = "normal",
    layout_config = { height = 40 },
  })
end, { desc = "Telescope files in current directory" })
telescope.load_extension("frecency")
keymap.set("n", "<leader>faf", ":Telescop frecency <cr>", { desc = "[Frec] Frecency Files" })
keymap.set(
  "n",
  "<leader>ff",
  ":Telescope frecency workspace=CWD path_display={'smart'} <CR>",
  { desc = "[Frec] Frecrency" }
)
-------------------------------------------------------
--              END Telescope
-------------------------------------------------------

-------------------------------------------------------
--               Print Current Directory
-------------------------------------------------------
-- print full working directory
keymap.set("n", "<leader>mpd", function()
  local filepath = vim.fn.expand("%:p")
  if filepath == "" then
    print("no file currently open")
  else
    -- Replace home directory with ~
    local home = vim.fn.expand("~")
    local display_path = filepath:gsub("^" .. home:gsub("([%(%)%.%+%-%*%?%[%]%^%$%%])", "%%%1"), "~")
    vim.fn.setreg("+", display_path)
    print("Copied to clipboard: " .. display_path)
  end
end, { desc = "[Dir] Copy current file fullpath (pwd)" })

-- print relative path
keymap.set("n", "<leader>mpr", function()
  local filepath = vim.fn.expand("%:.")
  if filepath == "" then
    print("no file currently open")
  else
    vim.fn.setreg("+", filepath)
    print("Copied to clipboard", filepath)
  end
end, { desc = "[Dir] Copy current file relative path" })

-- print current file name
keymap.set("n", "<leader>mpf", function()
  local filepath = vim.fn.expand("%:t")
  if filepath == "" then
    print("no file currently open")
  else
    vim.fn.setreg("+", filepath)
    print("Copied to clipboard", filepath)
  end
end, { desc = "[Dir] Copy current file name" })
-------------------------------------------------------
--                  NeoGen
-------------------------------------------------------
vim.api.nvim_set_keymap("n", "<leader>ng", ":lua require('neogen').generate()<CR>", opts)

-------------------------------------------------------
--         Increment / Decrement
-------------------------------------------------------
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")
-------------------------------------------------------
--              New Tab
-------------------------------------------------------
keymap.set("n", "te", ":tabedit", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-------------------------------------------------------
--              Split Window
-------------------------------------------------------
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-------------------------------------------------------
--              Move Windows
-------------------------------------------------------
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-------------------------------------------------------
--              Resize Window
-------------------------------------------------------
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")
-------------------------------------------------------
--              Diagnostics
-------------------------------------------------------
keymap.set("n", "<C-j>", function()
  vim.diagnostic.jump({ buffer = 0, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Get next diagnostics error" })

-------------------------------------------------------
--         Open HTML Files in Browser
-------------------------------------------------------
keymap.set("n", "<leader>O", function()
  vim.ui.open(vim.fn.expand("%"))
end, { desc = "Open in Browser" })
-------------------------------------------------------
--         Strikethrough Command
-------------------------------------------------------
keymap.set("n", "<leader>ts", function()
  local line = vim.fn.getline(".")
  -- get line without leading/trailing spaces
  local trimmed = line:match("^%s*(.-)%s*$")
  if trimmed == "" then
    return
  end
  -- check if already has strikethrough
  if trimmed:match("^~.*~$") then
    -- remove strikethrough
    local content = trimmed:match("^~(.*)~$")
    local indent = line:match("^(%s*)")
    vim.fn.setline(".", indent .. content)
  else
    -- add strikethrough
    local indent = line:match("^(%s*)")
    vim.fn.setline(".", indent .. "~" .. trimmed .. "~")
  end
end, { desc = "[Text strikethrough] toggle strikethrough line" })
-------------------------------------------------------
--         END Strikethrough Command
-------------------------------------------------------
-------------------------------------------------------
--               IncRename
-------------------------------------------------------
keymap.set("n", "<leader>rn", ":IncRename ")

-- ############################################################################
--                          Markdown
-- ############################################################################
local wk = require("which-key")
-------------------------------------------------------------------------------
--                       Markdown Headings Local Function
-------------------------------------------------------------------------------
-- Function to fold all headings of a specific level
local function fold_headings_of_level(level)
  -- Move to the top of the file without adding to jumplist
  vim.cmd("keepjumps normal! gg")
  -- Get the total number of lines
  local total_lines = vim.fn.line("$")
  for line = 1, total_lines do
    -- Get the content of the current line
    local line_content = vim.fn.getline(line)
    -- "^" -> Ensures the match is at the start of the line
    -- string.rep("#", level) -> Creates a string with 'level' number of "#" characters
    -- "%s" -> Matches any whitespace character after the "#" characters
    -- So this will match `## `, `### `, `#### ` for example, which are markdown headings
    if line_content:match("^" .. string.rep("#", level) .. "%s") then
      -- Move the cursor to the current line without adding to jumplist
      vim.cmd(string.format("keepjumps call cursor(%d, 1)", line))
      -- Check if the current line has a fold level > 0
      local current_foldlevel = vim.fn.foldlevel(line)
      if current_foldlevel > 0 then
        -- Fold the heading if it matches the level
        if vim.fn.foldclosed(line) == -1 then
          vim.cmd("normal! za")
        end
        -- else
        --   vim.notify("No fold at line " .. line, vim.log.levels.WARN)
      end
    end
  end
end

--- Folds markdown headings based on specified levels.
--- This function first saves the current view (cursor position, scroll, etc.),
--- then iterates through the provided `levels` table, applying folding to all
--- headings that match each specified level using `fold_headings_of_level`.
--- After folding, it clears any active search highlighting and restores the
--- saved view to bring the user back to their original position.
---@param levels table A table of numbers representing the heading levels to fold (e.g., `{1, 2, 3}` to fold H1, H2, and H3).
local function fold_markdown_headings(levels)
  -- I save the view to know where to jump back after folding
  local saved_view = vim.fn.winsaveview()
  for _, level in ipairs(levels) do
    fold_headings_of_level(level)
  end
  vim.cmd("nohlsearch")
  -- Restore the view to jump to where I was
  vim.fn.winrestview(saved_view)
end
-------------------------------------------------------------------------------
--               END Markdown Headings Local Function
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--               Markdown Folding Keymaps
-------------------------------------------------------------------------------
wk.add({
  mode = { "n", "v" }, -- Applies to normal and visual modes for these groups
  { "<leader>m", group = "[P]markdown" }, -- Main markdown group
  { "<leader>mf", group = "[P]Fold Markdown" }, -- Subgroup for folding actions (e.g., <leader>mfj, <leader>mfk)
  { "<leader>mh", group = "[P]Headings Adjust" }, -- For mthf etc.
  -- Add other leader-prefixed groups here as needed, e.g., for links (<leader>ml), spell (<leader>ms)
})

-- Add group for direct 'z' commands related to folding
wk.add({
  mode = { "n" },
  { "z", group = "[P]Folds" }, -- A group for all 'z' commands (e.g., zj, zk)
})

-- Add specific standalone keymaps to which-key
wk.add({
  mode = { "n" },
  { "<leader>mT", desc = "Show current, next, and same-level Markdown headings" },
  { "<leader>mthf", desc = "mthf - add dashes to headings" },
  { "<CR>", desc = "[P]Toggle fold (Current)" }, -- Explicitly add CR
})

wk.add({
  mode = { "n", "v", "i" }, -- For the <M-:> mapping
  { "<M-:>", desc = "[P]Paste Github link" },
})
keymap.set("n", "<leader>mfj", function()
  vim.cmd("silent update")
  vim.cmd("edit!")
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2, 1 })
  vim.cmd("normal! zz")
end, { desc = "[P]Fold all headings level 1 or above" })

keymap.set("n", "<leader>mfk", function()
  vim.cmd("silent update")
  vim.cmd("edit!")
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2 })
  vim.cmd("normal! zz")
end, { desc = "[P]Fold all headings level 2 or above" })

keymap.set("n", "<leader>mfl", function()
  vim.cmd("silent update")
  vim.cmd("edit!")
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3 })
  vim.cmd("normal! zz")
end, { desc = "[P]Fold all headings level 3 or above" })

keymap.set("n", "<leader>mf;", function() -- Changed to <leader>mf; to match your current keymap
  vim.cmd("silent update")
  vim.cmd("edit!")
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4 })
  vim.cmd("normal! zz")
end, { desc = "[P]Fold all headings level 4 or above" })

keymap.set("n", "<leader>mfu", function()
  vim.cmd("silent update")
  vim.cmd("edit!")
  vim.cmd("normal! zR")
  vim.cmd("normal! zz")
end, { desc = "[P]Unfold all headings" })

keymap.set("n", "<leader>mfi", function()
  vim.cmd("silent update")
  vim.cmd("normal gk")
  vim.cmd("normal! za")
  vim.cmd("normal! zz")
end, { desc = "[P]Fold the heading cursor currently on" })

-- Toggle fold keymap - consider if you want this under <leader>mf or direct
keymap.set("n", "<leader>mfc", function() -- Example: <leader>mfc for "fold Current"
  local line = vim.fn.line(".")
  local foldlevel = vim.fn.foldlevel(line)
  if foldlevel == 0 then
    vim.notify("No fold found", vim.log.levels.INFO)
  else
    vim.cmd("normal! za")
    vim.cmd("normal! zz")
  end
end, { desc = "[P]Toggle fold" })
-------------------------------------------------------------------------------
--               END Markdown Folding Keymaps
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--                  Markdown Headings section
-------------------------------------------------------------------------------
local function get_markdown_headings()
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
  -- Collect and sort all headings
  local headings = {}
  for id, node in query:iter_captures(tree:root(), 0) do
    local start_line = node:start() + 1 -- Convert to 1-based
    table.insert(headings, { line = start_line, level = id })
  end
  table.sort(headings, function(a, b)
    return a.line < b.line
  end)
  -- Find current heading and track its index
  local current_heading, current_idx, next_heading, next_same_heading
  for idx, h in ipairs(headings) do
    if h.line <= cursor_line then
      current_heading = h
      current_idx = idx
    elseif not next_heading then
      next_heading = h -- First heading after cursor
    end
  end
  -- Find next same-level heading if current exists
  if current_heading then
    -- Look for next same-level after current index
    for i = current_idx + 1, #headings do
      local h = headings[i]
      if h.level == current_heading.level then
        next_same_heading = h
        break
      end
    end
  end
  -- Return all values (nil if not found)
  return current_heading and current_heading.line or nil,
    current_heading and current_heading.level or nil,
    next_heading and next_heading.line or nil,
    next_heading and next_heading.level or nil,
    next_same_heading and next_same_heading.line or nil,
    next_same_heading and next_same_heading.level or nil
end
-- Print details of current markdown heading, next heading and next same level heading
vim.keymap.set("n", "<leader>mT", function()
  local cl, clvl, nl, nlvl, nsl, nslvl = get_markdown_headings()
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
end, { desc = "Show current, next, and same-level Markdown headings" })

-------------------------------------------------------------------------------
--                       END Markdown Headings section
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--                           Folding section
-------------------------------------------------------------------------------

-- Checks each line to see if it matches a markdown heading (#, ##, etc.):
-- It’s called implicitly by Neovim’s folding engine by vim.opt_local.foldexpr
if not _G.markdown_foldexpr then
  function _G.markdown_foldexpr()
    local lnum = vim.v.lnum
    local line = vim.fn.getline(lnum)
    local heading = line:match("^(#+)%s")
    if heading then
      local level = #heading
      if level == 1 then
        -- Special handling for H1
        if lnum == 1 then
          return ">1"
        else
          local frontmatter_end = vim.b.frontmatter_end
          if frontmatter_end and (lnum == frontmatter_end + 1) then
            return ">1"
          end
        end
      elseif level >= 2 and level <= 6 then
        -- Regular handling for H2-H6
        return ">" .. level
      end
    end
    return "="
  end
end

local function set_markdown_folding()
  vim.opt_local.foldmethod = "expr"
  vim.opt_local.foldexpr = "v:lua.markdown_foldexpr()"
  vim.opt_local.foldlevel = 99

  -- Detect frontmatter closing line
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

-- Use autocommand to apply only to markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = set_markdown_folding,
})

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 1 or above
vim.keymap.set("n", "zj", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfj", function()
  -- Reloads the file to refresh folds, otheriise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2, 1 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 1 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 2 or above
-- I know, it reads like "madafaka" but "k" for me means "2"
vim.keymap.set("n", "zk", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfk", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 2 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 3 or above
vim.keymap.set("n", "zl", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfl", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 3 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 4 or above
vim.keymap.set("n", "z;", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mf;", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 4 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Use <CR> to fold when in normal mode
-- To see help about folds use `:help fold`
vim.keymap.set("n", "<CR>", function()
  -- Get the current line number
  local line = vim.fn.line(".")
  -- Get the fold level of the current line
  local foldlevel = vim.fn.foldlevel(line)
  if foldlevel == 0 then
    vim.notify("No fold found", vim.log.levels.INFO)
  else
    vim.cmd("normal! za")
    vim.cmd("normal! zz") -- center the cursor line on screen
  end
end, { desc = "[P]Toggle fold" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for unfolding markdown headings of level 2 or above
-- Changed all the markdown folding and unfolding keymaps from <leader>mfj to
-- zj, zk, zl, z; and zu respectively lamw25wmal
vim.keymap.set("n", "zu", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfu", function()
  -- Reloads the file to reflect the changes
  vim.cmd("edit!")
  vim.cmd("normal! zR") -- Unfold all headings
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Unfold all headings level 2 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- gk jummps to the markdown heading above and then folds it
-- zi by default toggles folding, but I don't need it lamw25wmal
vim.keymap.set("n", "zi", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- Difference between normal and normal!
  -- - `normal` executes the command and respects any mappings that might be defined.
  -- - `normal!` executes the command in a "raw" mode, ignoring any mappings.
  vim.cmd("normal gk")
  -- This is to fold the line under the cursor
  vim.cmd("normal! za")
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold the heading cursor currently on" })

-------------------------------------------------------------------------------
--                         End Folding section
-------------------------------------------------------------------------------
-- paset a github link and add it in this format
vim.keymap.set({ "n", "v", "i" }, "<M-:>", function()
  -- Insert the text in the desired format
  vim.cmd('normal! a[](){:target="_blank"} ')
  vim.cmd("normal! F(pv2F/lyF[p")
  -- Leave me in normal mode or command mode
  vim.cmd("stopinsert")
end, { desc = "[P]Paste Github link" })
-- Markdown, adds dashes to headings
keymap.set("n", "<leader>mthf", function()
  local line = vim.api.nvim_get_current_line()
  local new_line = line:gsub("^(#+)%s+(.*)", function(hashes, text)
    return hashes .. " " .. text:gsub("%s+", "-")
  end)
  vim.api.nvim_set_current_line(new_line)
end, { noremap = true, silent = true, desc = "mthf - add dashes to headings" })

-- ############################################################################
--                          END Markdown
-- ############################################################################

-- ############################################################################
--                          Obsidian
-- ############################################################################
-------------------------------------------------------------------------------
--                         Obsidian Keymaps
-------------------------------------------------------------------------------
-- These commands below are tested and fully working in Ubuntu, MacOS, and Win
-- apply template `notes.md` to new notes using `<leader>on`
keymap.set("n", "<leader>on", ":ObsidianTemplate notes<CR> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<CR>")
-- apply template `todo.md` to new notes using: `<leader>todo`
keymap.set("n", "<leader>todo", ":ObsidianTemplate todo<CR> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<CR>")
-- strip date from note title and replace dashes with spaces
keymap.set("n", "<leader>of", ":s/\\(# \\)[^_]*_/\\1/ | s/-/ /g<cr>")
-- strip date, ignore `# Todo` e.g `# Todo: My New Note`
keymap.set("n", "<leader>otf", ":s/\\(# TODO: \\)[^_]*_\\(.*\\)/\\1\\2/ | s/-/ /g<cr>")

-------------------------------------------------------------------------------
--                         MacOS section
-------------------------------------------------------------------------------
-- OK: Move current file to zettelkasten folder
-- ODD: Delete current file in buffer
-- add keymap to move file in current buffer to zettelkasten folder
keymap.set("n", "<leader>ok", function()
  local dest = vim.fn.expand("~") .. "/Google Drive/My Drive/obsidian-work/zettelkasten/"
  local source = vim.fn.expand("%:p")
  -- local cmd = string.format(":!mv '%s' \"%s\"<cr>:bd<cr>", source, dest)
  vim.fn.system({ "mv", source, dest })
  vim.cmd("bd")
end)
-- delete file in current buffer MacOs
keymap.set("n", "<leader>odd", ":!rm '%:p'<cr>:bd<cr>")
-------------------------------------------------------------------------------
--                         END MacOS section
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--                         Windows section
-------------------------------------------------------------------------------
-- WOK: Move current file to zettelkasten folder
-- WOD: Delete current file in buffer

-- add keymap to move file in current buffer to zettelkasten folder
keymap.set("n", "<leader>wok", function()
  local current_file = vim.fn.expand("%:p")
  local zettelkasten_folder_expanded = vim.fn.expand("G:/My Drive/obsidian-work/zettelkasten")
  local filename = vim.fn.fnamemodify(current_file, ":t") -- Get the filename without the path
  local destination_path = zettelkasten_folder_expanded .. "\\" .. filename

  if vim.fn.isdirectory(zettelkasten_folder_expanded) == 0 then
    vim.notify("Zettelkasten folder does not exist: " .. zettelkasten_folder_expanded, vim.log.levels.ERROR)
    return
  end
  -- Rename/Move the file
  local status = vim.fn.rename(current_file, destination_path)
  if status == 0 then
    print("File moved successfully to: " .. destination_path)
    vim.cmd(":bd") -- Close the current buffer after moving the file
  else
    print("Error moving file, Status: " .. status)
  end
end, { desc = "Move current file to zettelkasten folder (PowerShell)" })
-- delete file in current buffer windows
keymap.set("n", "<leader>wod", function()
  local buffer_functions = require("utilities.delete_current_buffer_win")
  buffer_functions.del_buffer_win()
end, { desc = "Delete current buffer from system" })
-------------------------------------------------------------------------------
--                         END Windows section
-------------------------------------------------------------------------------
-- ############################################################################
--                          END Obsidian
-- ############################################################################
