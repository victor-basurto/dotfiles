local obsidian_path

if vim.fn.has("mac") == 1 then
  -- macOS path
  obsidian_path = vim.fn.expand("~/Google Drive/My Drive/obsidian-work")
elseif vim.fn.has("win32") == 1 then
  -- Windows path
  obsidian_path = "G:/My Drive/obsidian-work"
else
  obsidian_path = vim.fn.expand("~/.config/obsidian-vault") -- Example Linux path
end
-- resolve symlinks (especially for Google Drive on macOS)
local uv = vim.uv or vim.loop
obsidian_path = uv.fs_realpath(obsidian_path) or obsidian_path
return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  cond = function()
    local cwd = vim.fn.getcwd()
    -- Normalize for Windows
    if vim.fn.has("win32") == 1 then
      cwd = cwd:gsub("\\", "/")
    end
    -- Case insensitive check for Windows
    if vim.fn.has("win32") == 1 then
      return string.find(cwd:lower(), obsidian_path:lower(), 1, true) == 1
    else
      return string.find(cwd, obsidian_path, 1, true) == 1
    end
  end,
  opts = {
    -- current working directory for notes.
    workspaces = {
      {
        name = "ObsidianWork",
        path = obsidian_path, -- path to your Obsidian vault
      },
    },
    legacy_commands = false,
    log_level = vim.log.levels.INFO,
    frontmatter = {
      enabled = true,
      sort = { "id", "aliases", "tags" },
    },
    notes_subdir = "inbox",              -- store notes in the `inbox` directory
    new_notes_location = "notes_subdir", -- new notes should be store in the `notes_subdir` -> `inbox`
    preferred_link_style = "wiki",       -- Either 'wiki' or 'markdown'.
    ---@class obsidian.config.BacklinkOpts
    ---
    ---@field parse_headers boolean
    backlinks = {
      parse_headers = true,
    },
    -- store attachments in the `assets` directory.
    attachments = {
      folder = "assets",
      img_name_func = function()
        return string.format("Pasted image %s", os.date("%Y%m%d%H%M%S"))
      end,
      confirm_img_paste = true,
    },
    -- daily notes configuration
    ---@class obsidian.config.DailyNotesOpts
    ---
    ---@field folder? string
    ---@field date_format? string
    ---@field alias_format? string
    ---@field template? string
    ---@field default_tags? string[]
    ---@field workdays_only? boolean
    daily_notes = {
      -- keep daily notes in a separate directory.
      folder = "notes",
      -- date format for the ID of daily notes.
      date_format = "%Y-%m-%d",
      -- date format of the default alias of daily notes.
      alias_format = "%B %-d, %Y",
      -- default tags to add to each new daily note created.
      default_tags = { "daily-notes" },
      -- automatically insert a template from your template directory
      template = "notes.md",
    },

    -- auto completion
    -- completion = {
    --   blink = true,
    --   min_chars = 5,
    -- },
    ---@class obsidian.config.CompletionOpts
    ---
    ---@field nvim_cmp? boolean
    ---@field blink? boolean
    ---@field min_chars? integer
    ---@field match_case? boolean
    ---@field create_new? boolean
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

    callbacks = {
      enter_note = function(_, note)
        if note == nil then
          return
        end
        vim.keymap.set("n", "<leader>cho", "<cmd>Obsidian toggle_checkbox<cr>", {
          buffer = note.bufnr,
          desc = "Toggle checkbox",
        })
        vim.keymap.set("n", "<Tab>", function()
          require("obsidian.api").nav_link("next")
        end, {
          buffer = note.bufnr,
          desc = "Go to next link",
        })
        vim.keymap.set("n", "<S-Tab>", function()
          require("obsidian.api").nav_link("prev")
        end, {
          buffer = note.bufnr,
          desc = "Go to previous link",
        })
      end,
    },

    -- how note IDs are generated given an optional title.
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp, date and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '05-12-2025-my-new-note.md'
      local date_string = tostring(os.date("%Y-%m-%d"))
      local new_date_formatted = string.gsub(date_string, "/", "-")
      local suffix = ""

      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(" ", "-"):gsub(new_date_formatted, ""):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(new_date_formatted) .. "-" .. suffix
    end,

    -- frontmatter data.
    ---@return table
    frontmatter_func = function(note)
      -- Add the title of the note as an alias.
      if note.title then
        note:add_alias(note.title)
      end

      local out = { id = note.id, aliases = note.aliases, tags = note.tags }

      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,

    -- templates configuration
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      substitutions = {},
    },
    ---@class obsidian.config.UICharSpec
    ---@field char string
    ---@field hl_group string

    ---@class obsidian.config.CheckboxSpec : obsidian.config.UICharSpec
    ---@field char string
    ---@field hl_group string

    ---@class obsidian.config.UIStyleSpec
    ---@field hl_group string

    ---@class obsidian.config.UIOpts
    ---
    ---@field enable boolean
    ---@field ignore_conceal_warn boolean
    ---@field update_debounce integer
    ---@field max_file_length integer|?
    ---@field checkboxes table<string, obsidian.config.CheckboxSpec>
    ---@field bullets obsidian.config.UICharSpec|?
    ---@field external_link_icon obsidian.config.UICharSpec
    ---@field reference_text obsidian.config.UIStyleSpec
    ---@field highlight_text obsidian.config.UIStyleSpec
    ---@field tags obsidian.config.UIStyleSpec
    ---@field block_ids obsidian.config.UIStyleSpec
    ---@field hl_groups table<string, table>
    ui = {
      enable = false,
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
    ---@class obsidian.config.PickerNoteMappingOpts
    ---
    ---@field new? string
    ---@field insert_link? string

    ---@class obsidian.config.PickerTagMappingOpts
    ---
    ---@field tag_note? string
    ---@field insert_tag? string

    ---@class obsidian.config.PickerOpts
    ---
    ---@field name obsidian.config.Picker|?
    ---@field note_mappings? obsidian.config.PickerNoteMappingOpts
    ---@field tag_mappings? obsidian.config.PickerTagMappingOpts
    --- picker configuration
    picker = {
      -- 'telescope.nvim' as default picker
      name = "telescope.nvim",
      -- mappings for the picker.
      note_mappings = {
        -- Create a new note from your query.
        new = "<C-x>",
        -- Insert a link to the selected note.
        insert_link = "<C-l>",
      },
      tag_mappings = {
        -- Add tag(s) to current note.
        tag_note = "<C-x>",
        -- Insert a tag at the current location.
        insert_tag = "<C-l>",
      },
    },

    ---@class obsidian.config.SearchOpts
    ---
    ---@field sort_by string
    ---@field sort_reversed boolean
    ---@field max_lines integer
    search = {
      sort_by = "modified",
      sort_reversed = true,
      max_lines = 1000,
    },
  },

  ---@class obsidian.config.FooterOpts
  ---
  ---@field enabled? boolean
  ---@field format? string
  ---@field hl_group? string
  ---@field separator? string|false Set false to disable separator; set an empty string to insert a blank line separator.
  -- footer = {
  --   enabled = false,
  --   format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars",
  --   hl_group = "Comment",
  --   separator = string.rep("-", 80),
  -- },
  ---@class obsidian.config.OpenOpts
  ---
  ---Opens the file with current line number
  ---@field use_advanced_uri? boolean
  ---
  ---Function to do the opening, default to vim.ui.open
  ---@field func? fun(uri: string)
  ---
  ---URI scheme whitelist, new values are appended to this list, and URIs with schemes in this list, will not be prompted to confirm opening
  ---@field schemes? string[]
  open = {
    use_advanced_uri = false,
    func = vim.ui.open,
    schemes = { "https", "http", "file", "mailto" },
  },
  ---@class obsidian.config.CommentOpts
  ---@field enabled boolean
  -- comment = {
  --   enabled = false,
  -- },
  -- TODO:
  -- plugins to consider (install community plugins in obsidian):
  -- quick-explorer
}
