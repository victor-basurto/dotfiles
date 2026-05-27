-- blink.lua
-- followed configuration by:
-- linkarzu
-- -- https://github.com/linkarzu
-- -- https://www.youtube.com/watch?v=1YEbKDlxfss

-- NOTE: Specify the trigger character(s) used for luasnip
local trigger_text = ";"

return {
  "saghen/blink.cmp",
  enabled = true,
  -- IMPORTANT: Ensure this plugin is loaded at the right time.
  -- LazyVim's default for blink.cmp is usually `event = "InsertEnter"`.
  -- If you're not seeing completion, ensure this is set or inherited.
  event = "InsertEnter",
  opts_extend = {
    "sources.completion.enabled_providers",
    "sources.compat",
    "sources.default",
  },

  dependencies = {
    "moyiz/blink-emoji.nvim",
    "Kaiser-Yang/blink-cmp-dictionary",
    -- Ensure LuaSnip and friendly-snippets are also available to blink.cmp
    -- (they should be top-level plugins, but listed here for clarity if not already implicitly handled)
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    {
      "saghen/blink.compat",
      optional = true, -- make optional so it's only enabled if any extras need it
      opts = {},
      version = not vim.g.lazyvim_blink_main and "*",
    },
    {
      "catppuccin/nvim",
      name = "catppuccin",
      optional = true,
      opts = {
        integrations = { blink_cmp = true },
      },
    },
    -- NOTE: Enable copilot
    -- { "giuxtaposition/blink-cmp-copilot" },
  },
  opts = function(_, opts)
    -- set immplemetation to Lua to avoid .dll issues on Windows
    opts.fuzzy = {
      implementation = "lua",
    }
    -- I noticed that telescope was extremeley slow and taking too long to open,
    -- assumed related to blink, so disabled blink and in fact it was related
    -- :lua print(vim.bo[0].filetype)
    -- So I'm disabling blink.cmp for Telescope
    opts.enabled = function()
      -- Detect Obsidian Vault (same logic as in plugins/obsidian.lua)
      local obsidian_path
      if vim.fn.has("mac") == 1 then
        obsidian_path = vim.fn.expand("~/Google Drive/My Drive/obsidian-work")
      elseif vim.fn.has("win32") == 1 then
        obsidian_path = "G:/My Drive/obsidian-work"
      else
        obsidian_path = vim.fn.expand("~/.config/obsidian-vault")
      end
      -- resolve symlinks (especially for Google Drive on macOS)
      local uv = vim.uv or vim.loop
      obsidian_path = uv.fs_realpath(obsidian_path) or obsidian_path

      -- If filetype is markdown and inside obsidian vault, disable
      if filetype == "markdown" then
        local cwd = vim.fn.getcwd()
        local is_obsidian = false
        if vim.fn.has("win32") == 1 then
          cwd = cwd:gsub("\\", "/")
          if string.find(cwd:lower(), obsidian_path:lower(), 1, true) == 1 then
            is_obsidian = true
          end
        else
          if string.find(cwd, obsidian_path, 1, true) == 1 then
            is_obsidian = true
          end
        end
        if is_obsidian then
          return false
        end
      end

      -- -- Disable for Telescope buffers
      -- if filetype == "TelescopePrompt" or filetype == "minifiles" or filetype == "snacks_picker_input" then
      --   return false
      -- end
      return true
    end

    -- NOTE: The new way to enable LuaSnip
    -- Merge custom sources with the existing ones from lazyvim
    -- NOTE: by default lazyvim already includes the lazydev source, so not adding it here again
    opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
      default = { "lsp", "path", "snippets", "buffer", "emoji" },
      providers = {
        lsp = {
          name = "lsp",
          enabled = true,
          module = "blink.cmp.sources.lsp",
          kind = "LSP",
          min_keyword_length = 0,
          -- When linking markdown notes, I would get snippets and text in the
          -- suggestions, I want those to show only if there are no LSP
          -- suggestions
          --
          -- Enabled fallbacks as this seems to be working now
          -- Disabling fallbacks as my snippets wouldn't show up when editing
          -- lua files
          -- fallbacks = { "snippets", "buffer" },
          score_offset = 90, -- the higher the number, the higher the priority
        },
        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = 25,
          -- When typing a path, I would get snippets and text in the
          -- suggestions, I want those to show only if there are no path
          -- suggestions
          fallbacks = { "snippets", "buffer" },
          -- min_keyword_length = 2,
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            end,
            show_hidden_files_by_default = true,
          },
        },
        buffer = {
          name = "Buffer",
          enabled = true,
          max_items = 3,
          module = "blink.cmp.sources.buffer",
          min_keyword_length = 2,
          score_offset = 15, -- the higher the number, the higher the priority
        },
        snippets = {
          name = "snippets",
          enabled = true,
          max_items = 15,
          min_keyword_length = 2,
          module = "blink.cmp.sources.snippets",
          score_offset = 85, -- the higher the number, the higher the priority
          -- Only show snippets if I type the trigger_text characters, so
          -- to expand the "bash" snippet, if the trigger_text is ";" I have to
          should_show_items = function()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
            -- NOTE: remember that `trigger_text` is modified at the top of the file
            return before_cursor:match(trigger_text .. "%w*$") ~= nil
          end,
          -- NOTE: I also tried to add the ";" prefix to all of the snippets loaded from
          -- friendly-snippets in the luasnip.lua file, but I was unable to do
          -- so, so I still have to use the transform_items here
          -- This removes the ";" only for the friendly-snippets snippets
          transform_items = function(_, items)
            local line = vim.api.nvim_get_current_line()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local before_cursor = line:sub(1, col)
            local start_pos, end_pos = before_cursor:find(trigger_text .. "[^" .. trigger_text .. "]*$")
            if start_pos then
              for _, item in ipairs(items) do
                if not item.trigger_text_modified then
                  ---@diagnostic disable-next-line: inject-field
                  item.trigger_text_modified = true
                  item.textEdit = {
                    newText = item.insertText or item.label,
                    range = {
                      start = { line = vim.fn.line(".") - 1, character = start_pos - 1 },
                      ["end"] = { line = vim.fn.line(".") - 1, character = end_pos },
                    },
                  }
                end
              end
            end
            return items
          end,
        },
        emoji = {
          module = "blink-emoji",
          name = "Emoji",
          score_offset = 93, -- the higher the number, the higher the priority
          min_keyword_length = 2,
          opts = { insert = true }, -- Insert emoji (default) or complete its name
        },
      },
    })

    -- Documentation site: https://cmp.saghen.dev/configuration/appereance.html
    opts.cmdline = {
      enabled = true,
      completion = {
        menu = {
          auto_show = true,
        },
      },
    }

    opts.completion = {
      menu = {
        border = "single",
      },
      documentation = {
        auto_show = true,
        window = {
          border = "single",
        },
      },
    }

    opts.snippets = {
      preset = "luasnip", -- Choose LuaSnip as the snippet engine
      -- This `expand` function is typically provided by LazyVim's default blink.cmp config
      -- and calls `LazyVim.cmp.expand(snippet)`. If you are completely replacing LazyVim's
      -- config, you might need to add it explicitly here, otherwise, it's handled.
      expand = function(snippet, _)
        return LazyVim.cmp.expand(snippet)
      end,
    }

    -- The default preset used by lazyvim accepts completions with enter
    -- I don't like using enter because if on markdown and typing
    -- something, but you want to go to the line below, if you press enter,
    -- the completion will be accepted
    -- https://cmp.saghen.dev/configuration/keymap.html#default
    opts.keymap = {
      preset = "default",

      ["<Tab>"] = { "select_next", "fallback" }, -- or "snippet_forward", or whichever you want
      ["<S-Tab>"] = { "select_prev", "fallback" }, -- or "snippet_backward"
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<S-k>"] = { "scroll_documentation_up", "fallback" },
      ["<S-j>"] = { "scroll_documentation_down", "fallback" },

      ["<C-space>"] = { "show" },
      ["<C-e>"] = { "cancel", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
    }

    return opts
  end,
}
