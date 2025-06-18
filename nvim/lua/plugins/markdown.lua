return {
  {
    "iamcco/markdown-preview.nvim",
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
  },
  {
    "hedyhli/markdown-toc.nvim",
    ft = "markdown", -- Lazy load on markdown filetype
    cmd = { "Mtoc" }, -- Or, lazy load on "Mtoc" command
    opts = {
      -- Your configuration here (optional)
      {
        headings = {
          -- Include headings before the ToC (or current line for `:Mtoc insert`).
          -- Setting to true will include headings that are defined before the ToC
          -- position to be included in the ToC.
          before_toc = true,
        },

        -- Table or boolean. Set to true to use these defaults, set to false to disable completely.
        -- Fences are needed for the update/remove commands, otherwise you can
        -- manually select ToC and run update.
        fences = {
          enabled = true,
          -- These fence texts are wrapped within "<!-- % -->", where the '%' is
          -- substituted with the text.
          start_text = "mtoc-start",
          end_text = "mtoc-end",
          -- An empty line is inserted on top and below the ToC list before the being
          -- wrapped with the fence texts, same as vim-markdown-toc.
        },

        -- Enable auto-update of the ToC (if fences found) on buffer save
        auto_update = true,

        toc_list = {
          -- string or list of strings (for cycling)
          -- If cycle_markers = false and markers is a list, only the first is used.
          -- You can set to '1.' to use a automatically numbered list for ToC (if
          -- your markdown render supports it).
          markers = { "*", "+", "-" },
          cycle_markers = true,
        },
      },
    },
  },
  config = function()
    require("mtoc").setup({})
  end,
  -- TODO: configure markdown for better readability
}
