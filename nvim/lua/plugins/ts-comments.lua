return {
  { "folke/ts-comments.nvim", opts = {}, event = "VeryLazy", enabled = vim.fn.has("nvim-0.10.0") == 1 },
  {
    "folke/todo-comments.nvim",
    optional = true,
    enabled = false,
    keys = {
      {
        -- {
        --   "<leader>ct",
        --   function()
        --     Snacks.picker.todo_comments()
        --   end,
        --   desc = "Todo",
        -- },
        {
          "<leader>cT",
          function()
            Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
          end,
          desc = "Todo/Fix/Fixme",
        },
      },
    },
  },
}
