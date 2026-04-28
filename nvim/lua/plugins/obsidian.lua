-- Obsidian
local obsidian_utils = require("utilities.obsidian_utils")
local obsidian_path = obsidian_utils.get_vault() -- get work vault

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
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

    -- Frontmatter updates
    frontmatter = {
      enabled = true,
      func = function(note)
        if note.title then
          note:add_alias(note.title)
        end

        -- Helper: return existing metadata value or a default
        local meta = note.metadata or {}

        -- Preserve `date` from existing frontmatter, or set today on new notes
        local date = meta.date or os.date("%Y-%m-%d")

        -- Preserve custom fields, defaulting to empty structures for new notes
        local hubs = meta.hubs or { "[[]]" }
        local parent = meta.parent or {}
        local urls = meta.urls or {}

        local out = {
          id = note.id,
          aliases = note.aliases,
          tags = note.tags,
          date = date,
          hubs = hubs,
          parent = parent,
          urls = urls,
        }

        -- Pass through any OTHER metadata fields you may add in the future
        for k, v in pairs(meta) do
          if out[k] == nil then
            out[k] = v
          end
        end

        return out
      end,
      -- Controls YAML key ordering in the file
      sort = { "id", "aliases", "tags", "date", "hubs", "parent", "urls" },
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
      local has_nvim_cmp = pcall(require, "cmp")
      local has_blink = pcall(require, "blink.cmp")
      return {
        nvim_cmp = has_nvim_cmp and not has_blink,
        blink = has_blink,
        min_chars = 2,
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

    picker = {
      name = "snacks",
      note_mappings = {
        new = "<C-x>",
        insert_link = "<C-l>",
      },
      tag_mappings = {
        tag_note = "<C-x>",
        insert_tag = "<C-l>",
      },
    },

    -- search = {
    --   sort_by = "modified",
    --   sort_reversed = true,
    --   max_lines = 1000,
    -- },

    -- callbacks = {
    --   enter_note = function(_, note)
    --     if note == nil then
    --       return
    --     end
    --     vim.keymap.set("n", "<leader>cho", "<cmd>Obsidian toggle_checkbox<cr>", {
    --       buffer = note.bufnr,
    --       desc = "Toggle checkbox",
    --     })
    --     -- Using string require inside function to prevent early load issues
    --     vim.keymap.set("n", "<Tab>", function()
    --       require("obsidian.api").nav_link("next")
    --     end, { buffer = note.bufnr, desc = "Go to next link" })
    --
    --     vim.keymap.set("n", "<S-Tab>", function()
    --       require("obsidian.api").nav_link("prev")
    --     end, { buffer = note.bufnr, desc = "Go to previous link" })
    --   end,
    -- },
    --
    -- open = {
    --   use_advanced_uri = false,
    --   func = vim.ui.open,
    --   schemes = { "https", "http", "file", "mailto" },
    -- },
    --
    -- exclude_dirs = { ".git", "node_modules", "dist", "build" },
  },
}
