return {
  {
    "NickvanDyke/opencode.nvim",
    version = "*",
    -- dependencies should only contain the list of required plugins
    dependencies = {
      {
        "folke/snacks.nvim",
        optional = true,
        opts = {
          input = {},
          picker = {},
          terminal = {},
        },
      },
    },
    -- Move keys here, to the same level as dependencies
    keys = {
      {
        "<leader>aa",
        function()
          local oc = require("opencode")
          -- check if opencode window is currently visible
          local winid = vim.fn.bufwinid("opencode")
          if winid ~= -1 then
            -- if its open, just hid the window (dont kill the buffer/session)
            vim.api.nvim_win_hide(winid)
          else
            -- if its closed, open it back up
            oc.toggle()
          end
        end,
        desc = "[AI] Toggle OpenCode (keep session)",
      },
      {
        "<leader>as",
        function()
          require("opencode").ask()
        end,
        desc = "[AI] Ask OpenCode",
      },
    },
  },
}
