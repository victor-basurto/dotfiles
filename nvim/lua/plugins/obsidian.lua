local obsidian_path

if vim.fn.has("mac") == 1 then
  obsidian_path = vim.fn.expand("~/Google Drive/My Drive/obsidian-work")
elseif vim.fn.has("win32") == 1 then
  obsidian_path = "G:/My Drive/obsidian-work"
else
  obsidian_path = vim.fn.expand("~/.config/obsidian-vault")
end

local uv = vim.uv or vim.loop
obsidian_path = uv.fs_realpath(obsidian_path) or obsidian_path
obsidian_path = obsidian_path:gsub("\\", "/"):gsub("/$", "")
obsidian_path = obsidian_path:gsub("G:/My Drive", "G:/My Drive")
obsidian_path = obsidian_path:gsub("\\\\", "/"):gsub("/$", "")

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cond = function()
    local cwd = vim.fn.getcwd()
    if vim.fn.has("win32") == 1 then
      cwd = cwd:gsub("\\", "/"):gsub("/$", "")
    end
    if vim.fn.has("win32") == 1 then
      return string.find(cwd:lower(), obsidian_path:lower(), 1, true) == 1
    else
      return string.find(cwd, obsidian_path, 1, true) == 1
    end
  end,
  opts = {
    workspaces = {
      {
        name = "ObsidianWork",
        path = obsidian_path,
      },
    },
    log_level = vim.log.levels.INFO,
    legacy_commands = false,

    -- New API for note locations
    notes_subdir = "inbox",
    new_notes_location = "notes_subdir",

    -- Matching the new Link API
    link = {
      style = "wiki",
      format = "shortest",
    },
    preferred_link_style = "wiki",

    -- Frontmatter updates
    frontmatter = {
      enabled = true,
      -- Using the new functional approach but keeping your logic
      func = function(note)
        if note.title then
          note:add_alias(note.title)
        end
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,
      sort = { "id", "aliases", "tags" },
    },

    backlinks = {
      parse_headers = true,
    },

    -- Note ID logic: Integrated your Zettelkasten structure into the new spec
    note_id_func = function(title)
      local date_string = tostring(os.date("%Y-%m-%d"))
      local new_date_formatted = string.gsub(date_string, "/", "-")
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "-"):gsub(new_date_formatted, ""):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(new_date_formatted) .. "-" .. suffix
    end,

    -- Preserving your specific requirements
    attachments = {
      folder = "assets",
      img_name_func = function()
        return string.format("Pasted image %s", os.date("%Y%m%d%H%M%S"))
      end,
      confirm_img_paste = true,
    },

    daily_notes = {
      enabled = true,
      folder = "notes",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      default_tags = { "daily-notes" },
      template = "notes.md",
    },

    completion = (function()
      local has_nvim_cmp, _ = pcall(require, "cmp")
      local has_blink = pcall(require, "blink.cmp")
      return {
        nvim_cmp = has_nvim_cmp and not has_blink,
        blink = has_blink,
        min_chars = 3,
        match_case = true,
        create_new = true,
      }
    end)(),

    templates = {
      enabled = true,
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      substitutions = {},
    },

    -- Updated key to lowercase 'statusline'
    statusline = {
      enabled = false,
      format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars",
    },
    ---@class obsidian.config.FooterOpts
    ---
    ---@field enabled? boolean
    ---@field format? string
    ---@field hl_group? string
    ---@field separator? string|false Set false to disable separator; set an empty string to insert a blank line separator.
    footer = {
      enabled = true,
      format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars",
      hl_group = "Comment",
      separator = string.rep("-", 80),
    },

    ui = {
      enable = false, -- As per your current file
      ignore_conceal_warn = false,
      update_debounce = 200,
      max_file_length = 5000,
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianImportant = { bold = true, fg = "#d73128" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },

    picker = {
      name = "fzf-lua",
      note_mappings = {
        new = "<C-x>",
        insert_link = "<C-l>",
      },
      tag_mappings = {
        tag_note = "<C-x>",
        insert_tag = "<C-l>",
      },
    },

    search = {
      sort_by = "modified",
      sort_reversed = true,
      max_lines = 1000,
    },

    callbacks = {
      enter_note = function(_, note)
        if note == nil then
          return
        end
        vim.keymap.set("n", "<leader>cho", "<cmd>Obsidian toggle_checkbox<cr>", {
          buffer = note.bufnr,
          desc = "Toggle checkbox",
        })
        -- Using string require inside function to prevent early load issues
        vim.keymap.set("n", "<Tab>", function()
          require("obsidian.api").nav_link("next")
        end, { buffer = note.bufnr, desc = "Go to next link" })

        vim.keymap.set("n", "<S-Tab>", function()
          require("obsidian.api").nav_link("prev")
        end, { buffer = note.bufnr, desc = "Go to previous link" })
      end,
    },

    open = {
      use_advanced_uri = false,
      func = vim.ui.open,
      schemes = { "https", "http", "file", "mailto" },
    },

    exclude_dirs = { ".git", "node_modules", "dist", "build" },
  },
}
