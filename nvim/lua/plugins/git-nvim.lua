return {
  {
    "tpope/vim-fugitive",
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
        signcolumn = true,
        signs = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
      })
      vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
      vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Preview blame" })
      vim.keymap.set("n", "<leader>gF", ":Gitsigns blame_line<CR>", { desc = "Blame line" })
      vim.keymap.set("n", "<leader>gd", ":Gitsigns diffthis<CR>", { desc = "diff" })
    end,
  },
  {
    -- TODO: setup keymaps and commands
    "sindrets/diffview.nvim",
  },
  {
    "nvim-mini/mini.map",
    version = false,
    config = function()
      local MiniMap = require("mini.map")
      MiniMap.setup({
        integrations = {
          MiniMap.gen_integration.builtin_search(),
          MiniMap.gen_integration.gitsigns(),
          MiniMap.gen_integration.diagnostic(),
        },
        symbols = {
          encode = require("mini.map").gen_encode_symbols.dot("4x2"),
        },
        window = {
          width = 20,
          winblend = 15,
        },
      })
    end,
  },
}
