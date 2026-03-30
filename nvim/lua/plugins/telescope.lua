-- NOTE: This plugin has been replaced by `Snacks`, enabled if `Snacks` is not needed anymore
if true then
  return {}
end
return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    enabled = false,
    -- or                              , branch = '0.1.x',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local fb_actions = require("telescope").extensions.file_browser.actions

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
        wrap_results = true,
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        path_display = { "truncate" },
        winblend = 0,
        mappings = {
          n = {},
        },
      })
      opts.pickers = {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = {
            preview_cutoff = 9999,
          },
        },
      }
      opts.extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({
            --custom options
          }),
        },
        ["file_browser"] = {
          theme = "dropdown",
          -- fix error for telescope mini-icons
          entry_marker = require("telescope.make_entry").gen_from_file({
            get_icon = function()
              return " ", "TelescopeNormal"
            end,
          }),
          -- force telescope_file_browser
          hijack_netrw = false,
          mappings = {
            ["n"] = {
              ["N"] = fb_actions.create,
              ["h"] = fb_actions.goto_parent_dir,
              ["/"] = function()
                vim.cmd("startinsert")
              end,
              ["<C-u>"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_previous(prompt_bufnr)
                end
              end,
              ["<C-d>"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_next(prompt_bufnr)
                end
              end,
              ["<PageUp>"] = actions.preview_scrolling_up,
              ["<PageDown>"] = actions.preview_scrolling_down,
            },
          },
        },
        ["frecency"] = {
          path_display = { "truncate" },
          db_safe_mode = false, -- Prevents the "clean DB" prompt which can sometimes cause input glitches
          auto_validate = true,
          default_text = "", -- Force the prompt to start empty
        },
      }
      telescope.setup(opts)
      -- require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("file_browser")
      require("telescope").load_extension("frecency")
    end,
  },
  { "nvim-telescope/telescope-fzf-native.nvim", enabled = false },
}
