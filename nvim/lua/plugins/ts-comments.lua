return {
  { "folke/ts-comments.nvim", opts = {}, event = "VeryLazy", enabled = vim.fn.has("nvim-0.10.0") == 1 },
  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
}
