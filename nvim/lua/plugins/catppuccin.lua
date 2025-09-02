return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      local catppuccin = require("catppuccin")
      catppuccin.setup({
        transparent_background = true,
        float = {
          transparent = false,
          solid = false,
        },
        flavour = "frappe",
        integrations = {
          bufferline = {
            enabled = true,
            highlights = true, -- get highlights for bufferline
            style = "default", -- "default" | "minimal" (optional)
          },
        },
      })

      vim.cmd("colorscheme catppuccin")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    after = "catppuccin",
    lazy = false,
    config = function(_, opts)
      -- local bfline = require("bufferline")
      local bflineCatppuccin = require("catppuccin.groups.integrations.bufferline")
      opts.highlights = bflineCatppuccin.get_theme()
    end,
  },
}
