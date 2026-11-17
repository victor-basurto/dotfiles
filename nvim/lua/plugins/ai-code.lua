return {
  "nickjvandyke/opencode.nvim",
  -- main supports OpenCode v2
  config = function()
    local opencode_cmd = "opencode"
    -- Shared Snacks terminal configuration
    local terminal_opts = {
      win = {
        position = "right",
        enter = true,
        width = 0.45,
      },
    }
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks.terminal").open(opencode_cmd, terminal_opts)
        end,
      },
    }
    -- OpenCode prompt
    vim.keymap.set("n", "<leader>ao", function()
      require("snacks.terminal").toggle(opencode_cmd, terminal_opts)
    end, { desc = "[o]pen OpenCode TUI" })

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

    -- Toggle actual OpenCode TUI
    vim.keymap.set({ "n", "t" }, "<leader>ao", function()
      require("snacks.terminal").toggle(opencode_cmd, {
        win = {
          position = "right",
          enter = false,
        },
      })
    end, { desc = "Toggle OpenCode TUI" })
  end,
}
