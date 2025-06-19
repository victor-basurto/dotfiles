return {
  {
    "iamcco/markdown-preview.nvim",
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
  },
  {
    "hedyhli/markdown-toc.nvim",
    ft = "markdown",
    cmd = { "Mtoc" },
    opts = {
      headings = { before_toc = false },
      fences = {
        enabled = true,
        start_text = "mtoc-start",
        end_text = "mtoc-end",
      },
      auto_update = true,
      toc_list = {
        markers = { "*", "+", "-" },
        cycle_markers = true,
        item_format_string = "${indent}${marker} [[#${name}]]", -- default obsidian TOC style
      },
    },
    config = function(_, default_opts)
      local mtoc = require("mtoc")
      mtoc.setup(default_opts) -- Apply the initial default configuration

      -- Define specific configurations for overrides
      -- Default Browser
      local browser_override_opts = vim.tbl_deep_extend("force", {}, default_opts, {
        fences = {
          start_text = "mtoc-start",
          end_text = "mtoc-end",
        },
        toc_list = {
          item_format_string = "${indent}${marker} [${name}](#${link})",
        },
      })

      -- Obsidian TOC styles
      local obsidian_override_opts = vim.tbl_deep_extend("force", {}, default_opts, {
        fences = {
          start_text = "mtoc-obsidian-start", -- Use distinct fences for Obsidian if desired
          end_text = "mtoc-obsidian-end",
        },
        toc_list = {
          item_format_string = "${indent}${marker} [[#${name}]]",
        },
      })

      -- Helper function to set config, run command, and revert
      local function generate_toc_with_temp_config(target_config)
        -- Set the desired temporary config
        mtoc.setup(target_config)

        -- Defer the command to ensure config is applied
        -- We might need a slightly longer deferral or chained deferrals
        -- to be absolutely sure the config is settled before the command runs.
        vim.defer_fn(function()
          vim.cmd("Mtoc insert")

          -- After the command runs, defer the revert as well.
          -- This ensures the revert doesn't happen *before* the command
          -- has finished processing its state, which could be relevant
          -- if the command itself has any async parts.
          vim.defer_fn(function()
            mtoc.setup(default_opts)
          end, 20) -- Small defer for revert
        end, 50) -- Main defer for setup + command
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          -- NOTE: <leader>mtoc: Generates TOC using the default (browser-compatible) configuration
          vim.keymap.set("n", "<leader>mtoc", function()
            -- Even for the default, use the helper to ensure consistent behavior
            generate_toc_with_temp_config(browser_override_opts)
          end, {
            desc = "Insert Markdown TOC (browser-compatible)",
            buffer = true,
          })

          -- NOTE: <leader>motoc: Generates TOC using Obsidian wikilinks
          vim.keymap.set("n", "<leader>motoc", function()
            generate_toc_with_temp_config(obsidian_override_opts)
          end, {
            desc = "Insert Markdown TOC (Obsidian wikilinks)",
            buffer = true,
          })
        end,
      })
    end,
  },
}
