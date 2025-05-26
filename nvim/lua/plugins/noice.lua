return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "no information available",
        },
        opts = { skip = true },
      })
      opts.presets.lsp_doc_border = true
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 10000,
    },
    config = function()
      local noice = require("noice")
      noice.setup({
        -- add missing require files for noice config
        cmdline = {
          view = "cmdline",
          format = {
            -- cmdline = { icon = "" },
            -- search_down = { icon = "🔍" },
            -- search_up = { icon = "🔍" },
            -- filter = { icon = "🔍" },
            lua = { icon = "🌙" },
          },
        },
        lsp = {
          progress = {
            enabled = false,
          },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = false, -- use a classic bottom cmdline for search
          command_palette = false, -- position the cmdline and popupmenu together
          long_message_to_split = false, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      })
    end,
  },
}
