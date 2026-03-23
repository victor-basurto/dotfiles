return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf = require("fzf-lua")
      ---@module "fzf-lua"
      ---@type fzf-lua.Config|{}
      ---@diagnostic disable: missing-fields
      fzf.setup({
        -- fzf-lua has a default 'telescope' profile which is a good starting point
        "telescope",
        -- TODO: add keymaps for
        -- - git
        -- - filebrowser (if exists)
        -- - frecency (if exists)
        -- Enable file navigation when fzf is opened
        winopts = {
          preview = {
            layout = "vertical",
          },
        },
      })
    end,
  },
}
