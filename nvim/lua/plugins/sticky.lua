return {
  {
    "walkersumida/fusen.nvim",
    version = "*",
    event = "VimEnter",
    opts = {
      -- file location where the annotations are going to be saved
      save_file = vim.fn.expand("$HOME") .. "/.config/sticky-notes/notes/notes.json",
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

      -- [N]otes [a]nnotattion [e]dit/add
      vim.keymap.set("n", "<leader>Nae", fusen.add_mark, { desc = "[Annotation]: Add/Edit note" })
      -- [N]otes [a]nnotattion [c]lear note
      vim.keymap.set("n", "<leader>Nac", fusen.clear_mark, { desc = "[Annotation]: Clear note" })
      -- [N]otes [a]nnotattion [C]lear buffer notes
      vim.keymap.set("n", "<leader>NaC", fusen.clear_buffer, { desc = "[Annotation]: Clear buffer notes" })
      -- [N]otes [a]nnotattion [D] Clear All Notes
      vim.keymap.set("n", "<leader>NaD", fusen.clear_all, { desc = "[Annotation]: Clear ALL notes" })
      -- [N]otes [a]nnotattion [n]ext note
      vim.keymap.set("n", "<leader>Nan", fusen.next_mark, { desc = "[Annotation]: Next note" })
      -- [N]otes [a]nnotattion [p]revious note
      vim.keymap.set("n", "<leader>Nap", fusen.prev_mark, { desc = "[Annotation]: Previous note" })
      -- [N]otes [a]nnotattion [l]ist all notes
      vim.keymap.set("n", "<leader>Nal", fusen.list_marks, { desc = "[Annotation]: List all notes" })
    end,
  },
  {
    "etiennecollin/notes.nvim",
    lazy = false,
    cmd = { "NotesToggle", "NotesShow", "NotesHide", "NotesEdit" },
    opts = {
      notes_file_path = vim.fn.expand("$HOME") .. "/.config/sticky-notes/notes/all-notes.md",
      auto_save = true,
      auto_save_on_exit = true,
      display_mode = "vsplit",
      split = {
        hsplit_height = 30,
        vsplit_width = 30,
      },
      buffer_keymaps = {
        save = "<C-s>",
        quit = "qq",
      },
    },
    config = function(_, opts)
      require("notes").setup(opts)

      -- Main toggle: Open / Close notes in vertical split on the right
      vim.keymap.set("n", "<leader>Nnt", "<cmd>NotesToggle vsplit<CR>", { desc = "[Notes] Toggle right sidebar" })

      -- Open as floating window (good for temporary use)
      vim.keymap.set("n", "<leader>NnF", "<cmd>NotesToggle float<CR>", { desc = "[Notes] Toggle floating window" })

      -- Force show / hide (useful if you want separate control)
      vim.keymap.set("n", "<leader>Nns", "<cmd>NotesShow<CR>", { desc = "[Notes] Show notes" })

      vim.keymap.set("n", "<leader>Nnh", "<cmd>NotesHide<CR>", { desc = "[Notes] Hide notes" })

      -- Directly edit the notes file in current window (rarely needed)
      vim.keymap.set("n", "<leader>Nne", "<cmd>NotesEdit<CR>", { desc = "[Notes] Edit notes file" })
    end,
  },
}
