return {
  {
    "walkersumida/fusen.nvim",
    version = "*",
    event = "VimEnter",
    opts = {
      -- file location where the annotations are going to be saved
      save_file = vim.fn.expand("$HOME") .. "/.config/fusen/notes/notes.json",
      -- Disable all default keymaps (so "me", "mc", etc. won't conflict)
      keymaps = {
        add_mark = "me",
        clear_mark = "mc",
        clear_buffer = "mC",
        clear_all = "mD",
        next_mark = "mn",
        prev_mark = "mp",
        list_marks = "ml",
      },
    },

    config = function(_, opts)
      require("fusen").setup(opts)

      -- Disable the default short keymaps so they don't interfere
      vim.keymap.set("n", "me", "<Nop>", { silent = true })
      vim.keymap.set("n", "mc", "<Nop>", { silent = true })
      vim.keymap.set("n", "mC", "<Nop>", { silent = true })
      vim.keymap.set("n", "mD", "<Nop>", { silent = true })
      vim.keymap.set("n", "mn", "<Nop>", { silent = true })
      vim.keymap.set("n", "mp", "<Nop>", { silent = true })
      vim.keymap.set("n", "ml", "<Nop>", { silent = true })

      -- keymap mappings
      local fusen = require("fusen")

      vim.keymap.set("n", "<leader>Ne", fusen.add_mark, { desc = "[Notes]: Add/Edit note" })
      vim.keymap.set("n", "<leader>Nc", fusen.clear_mark, { desc = "[Notes]: Clear note" })
      vim.keymap.set("n", "<leader>NC", fusen.clear_buffer, { desc = "[Notes]: Clear buffer notes" })
      vim.keymap.set("n", "<leader>ND", fusen.clear_all, { desc = "[Notes]: Clear ALL notes" })
      vim.keymap.set("n", "<leader>Nn", fusen.next_mark, { desc = "[Notes]: Next note" })
      vim.keymap.set("n", "<leader>Np", fusen.prev_mark, { desc = "[Notes]: Previous note" })
      vim.keymap.set("n", "<leader>Nl", fusen.list_marks, { desc = "[Notes]: List all notes" })
    end,
  },
}
