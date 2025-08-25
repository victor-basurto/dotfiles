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
        flavour = "macchiato",
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
    optional = true,
    opts = function(_, opts)
      local ok, buf = pcall(require, "catppuccin.groups.integrations.bufferline")
      if ok and buf.get_theme then
        local palettes = require("catppuccin.palettes")
        local mocha = palettes.get_palette("mocha")
        opts.highlights = buf.get_theme({
          styles = { "italic", "bold" },
          custom = {
            all = { fill = { bg = "#000000" } },
            mocha = { background = { fg = mocha.text } },
            latte = { background = { fg = "#000000" } },
          },
        })
      end
      return opts
    end,
  },
}
