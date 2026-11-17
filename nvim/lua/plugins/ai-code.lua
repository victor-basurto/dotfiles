return {
  "nickjvandyke/opencode.nvim",
  -- main supports OpenCode v2
  config = function()
    -- OpenCode action picker
    vim.keymap.set({ "n", "x" }, "<leader>as", function()
      require("opencode").select()
    end, { desc = "OpenCode actions" })

    -- Send selected range
    vim.keymap.set({ "n", "x" }, "<leader>ar", function()
      return require("opencode").operator("@this")
    end, { expr = true, desc = "Send range to OpenCode" })

    -- Send current line
    -- vim.keymap.set("n", "goo", function()
    --   return require("opencode").operator("@this") .. "_"
    -- end, { expr = true, desc = "Send line to OpenCode" })
  end,
}
