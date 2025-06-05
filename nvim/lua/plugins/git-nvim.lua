return {
  {
    "tpope/vim-fugitive",
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({ current_line_blame = true })
      vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
      vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Preview blame" })
      vim.keymap.set("n", "<leader>gF", ":Gitsigns blame_line<CR>", { desc = "Blame line" })
      vim.keymap.set("n", "<leader>gd", ":Gitsigns diffthis<CR>", { desc = "diff" })
    end,
  },
}
