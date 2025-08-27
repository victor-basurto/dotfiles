return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
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
    optional = true,
    priority = 1000,
    event = "VeryLazy",
    config = function()
      require("bufferline").setup({
        highlights = require("catppuccin.groups.integrations.bufferline").get_theme(),
      })
    end,
  },
}
