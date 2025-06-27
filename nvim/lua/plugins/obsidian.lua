local obsidian_path

if vim.fn.has("mac") == 1 then
  -- macOS path
  obsidian_path = vim.fn.expand("~/Google Drive/My Drive/obsidian-work")
elseif vim.fn.has("win32") == 1 then
  -- Windows path
  obsidian_path = "G:/My Drive/obsidian-work"
else
  -- Default for Linux or other systems (adjust as needed)
  obsidian_path = vim.fn.expand("~/.config/obsidian-vault") -- Example Linux path
end
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = { "markdown" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    -- current working directory for notes.
    workspaces = {
      {
        name = "ObsidianWork",
        path = obsidian_path, -- path to your Obsidian vault
      },
    },
    log_level = vim.log.levels.INFO,
    disable_frontmatter = true,
    notes_subdir = "inbox", -- store notes in the `inbox` directory
    new_notes_location = "notes_subdir", -- new notes should be store in the `notes_subdir` -> `inbox`
    preferred_link_style = "wiki", -- Either 'wiki' or 'markdown'.

    -- store attachments in the `assets` directory.
    attachments = {
      img_folder = "assets",
    },

    -- daily notes configuration
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
    completion = {
      blink = true,
      min_chars = 2,
    },

    -- custom key mappings
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ["<leader>cho"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Smart action depending on context, either follow link or toggle checkbox.
      ["<cr>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
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
    note_frontmatter_func = function(note)
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

    ui = {
      enable = false,
    },
    -- picker configuration
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
  },
  -- TODO:
  -- plugins to consider (install community plugins in obsidian):
  -- edit-in-neovim
  -- quick-explorer
}
