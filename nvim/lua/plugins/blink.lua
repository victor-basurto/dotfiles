-- blink.lua
-- followed configuration by:
-- linkarzu
-- -- https://github.com/linkarzu
-- -- https://www.youtube.com/watch?v=1YEbKDlxfss

-- NOTE: Specify the trigger character(s) used for luasnip
local trigger_text = ";"

return {
  "saghen/blink.cmp",
  version = "2.*",
  enabled = true,
  event = "InsertEnter",
  opts_extend = {
    "sources.default",
  },

  dependencies = {
    "Kaiser-Yang/blink-cmp-dictionary",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "saghen/blink.lib",
    {
      "catppuccin/nvim",
      name = "catppuccin",
      optional = true,
      opts = {
        integrations = { blink_cmp = true },
      },
    },
  },
  opts = function(_, opts)
    ---@cast opts blink.cmp.Config
    -- set implementation to Lua to avoid .dll issues on Windows
    opts.fuzzy = {
      implementation = "lua",
    }
    opts.appearance = {
      nerd_font_variant = "mono",
    }

    -- Merge custom sources cleanly with standard built-ins
    opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
      default = { "lazydev", "lsp", "path", "snippets", "buffer" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
        lsp = {
          name = "lsp",
          enabled = true,
          module = "blink.cmp.sources.lsp",
          min_keyword_length = 0,
          score_offset = 90,
        },
        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = 25,
          fallbacks = { "snippets", "buffer" },
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
          score_offset = 15,
        },
        snippets = {
          name = "snippets",
          enabled = true,
          max_items = 15,
          min_keyword_length = 2,
          module = "blink.cmp.sources.snippets",
          score_offset = 85,
          should_show_items = function()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
            return before_cursor:match(trigger_text .. "%w*$") ~= nil
          end,
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
      },
    })

    opts.cmdline = {
      enabled = true,
      completion = {
        menu = {
          auto_show = true,
        },
      },
    }

    opts.completion = {
      list = { selection = { preselect = true, auto_insert = true } },
      ghost_text = { enabled = true },
      menu = {
        draw = {
          padding = 1,
          columns = { { "kind_icon" }, { "label", gap = 1 } },
        },
        border = "solid",
      },
    }

    opts.snippets = {
      preset = "luasnip",
      expand = function(snippet, _)
        return require("lazyvim.util").cmp.expand(snippet)
      end,
    }

    opts.signature = { enabled = true, window = { border = "solid" } }

    opts.keymap = {
      preset = "default",
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
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
