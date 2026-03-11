return {
  {
    "NickvanDyke/opencode.nvim",
    -- dependencies should only contain the list of required plugins
    dependencies = {
      {
        "folke/snacks.nvim",
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
          require("opencode").toggle()
        end,
        desc = "[AI] Toggle OpenCode",
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
