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
  -- TODO: install Flash for faster navigation
  -- TODO: install snacks (image) ref: youtube linkarzu "images in neovim"
  -- TODO: install "arnamak/stay-centered" for auto-centering cursor
}
