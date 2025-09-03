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
    dependencies = {
      "akinsho/bufferline.nvim",
      optional = true,
      opts = function(_, opts)
        if (vim.g.colors_name or ""):find("catppuccin") then
          opts.highlights = require("catppuccin.groups.integrations.bufferline").get_theme()
        end
      end,
    },
  },
  {
    "akinsho/bufferline.nvim",
    after = "catppuccin",
    lazy = false,
    config = function()
      local bflineCatppuccin = require("catppuccin.groups.integrations.bufferline")
      require("bufferline").setup({
        highlights = bflineCatppuccin.get_theme(),
      })
    end,
  },
}
