-- noice.lua
return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        view = "cmdline",
        format = {
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
          ["vim.lsp.util.open_floating_preview"] = true,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = false,
        long_message_to_split = false,
        inc_rename = false,
        lsp_doc_border = true, -- <--- Keeps the border (moved from the first opts function)
      },
      routes = {
        {
          filter = {
            event = "notify",
            -- Match the common LSP "no information" message (case-insensitive)
            pattern = "No information available",
          },
          opts = { skip = true },
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      -- Remove the second plugin block for nvim-notify, as noice handles it.
    },
    config = function()
      require("noice").setup(require("noice").opts)
    end,
  },
}
