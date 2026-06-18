return {
  {
    "nickjvandyke/opencode.nvim",
    version = "*", -- Latest stable release
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any; goto definition on the type or field for details
      }

      vim.o.autoread = true -- Required for `vim.g.opencode_opts.events.reload`

      -- Recommended/example keymaps
      -- vim.keymap.set({ "n", "x" }, "<leader>oa", function()
      --   require("opencode").ask("@this: ")
      -- end, { desc = "Ask opencode…" })
      -- vim.keymap.set({ "n", "x" }, "<leader>os", function()
      --   require("opencode").select()
      -- end, { desc = "Select opencode…" })
      --
      -- vim.keymap.set({ "n", "x" }, "go", function()
      --   return require("opencode").operator("@this ")
      -- end, { desc = "Add range to opencode", expr = true })
      -- vim.keymap.set("n", "goo", function()
      --   return require("opencode").operator("@this ") .. "_"
      -- end, { desc = "Add line to opencode", expr = true })
      --
      -- vim.keymap.set("n", "<S-C-u>", function()
      --   require("opencode").command("session.half.page.up")
      -- end, { desc = "Scroll opencode up" })
      -- vim.keymap.set("n", "<S-C-d>", function()
      --   require("opencode").command("session.half.page.down")
      -- end, { desc = "Scroll opencode down" })
    end,
  },
}
