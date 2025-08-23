return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true,
      flavour = "frappe",
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "akinsho/bufferline.nvim",
    optional = true,
    version = "*",
    priority = 1000,
    dependencies = "nvim-tree/nvim-web-devicons",
    -- TODO: add buffer line configuration
    -- opts = function(_, opts)
    --   if (vim.g.colors_name or ""):find("catppuccin") then
    --     opts.highlights = require("catppuccin.groups.integrations.bufferline").get({})
    --   end
    -- end,
  },
}
