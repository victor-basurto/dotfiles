return {
  { "smjonas/inc-rename.nvim", opts = {} },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
  { "bullets-vim/bullets.vim" },
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      picker = {
        -- NOTE: documentation for `snacks.explorer`
        --https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#%EF%B8%8F-layouts
        sources = {
          explorer = {
            layout = {
              preset = "right",
              layout = {
                height = 0,
                min_width = 50,
                -- position = "right",
                border = "none",
              },
            },
          },
        },
      },
    },
  },
}
