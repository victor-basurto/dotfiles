return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
      vim.keymap.set("n", "<Leader>dapt", dap.toggle_breakpoint, { desc = "[DAP] Toggle Brakepoint" })
      vim.keymap.set("n", "<Leader>dapc", dap.continue, { desc = "[DAP] Continue" })
    end,
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    lazy = true,
    config = function()
      local dap_vscode_js = require("dap-vscode-js")
      dap_vscode_js.setup({
        node_path = "node",
        debugger_path = "", -- Let the plugin figure this out
        debugger_cmd = {}, -- Let the plugin figure this out
        log_file_path = "", -- Optional logging
        log_file_level = 2,
        log_console_level = 3,
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      })
      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-chrome", -- Use the Chrome adapter
            request = "launch",
            name = "Launch & Debug Chrome (React/Browser)",
            -- Use a function to prompt the user for the URL on launch
            url = function()
              local co = coroutine.running()
              vim.ui.input({
                prompt = "Enter URL: ",
                default = "http://localhost:3000",
              }, function(url)
                coroutine.resume(co, url)
              end)
              return coroutine.yield()
            end,
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
            -- userDataDir = false, -- Optional: Use a fresh profile each time
          },
        }
      end
    end,
  },

  -- database
  {
    "tpope/vim-dadbod",
    cmd = "DB",
  },
  {
    "kristijanhusak/vim-dadbod-completion",
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql", "mysql", "plsql" },
    config = function()
      require("blink.cmp").setup({
        sources = {
          default = { "lsp", "path", "buffer" },
          providers = {
            ["vim-dadbod-completion"] = {
              module = "vim_dadbod_completion",
              name = "vim-dadbod-completion",
              score_offset = 100,
            },
          },
        },
      })
    end,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = "vim-dadbod",
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
    },
    init = function()
      local data_path = vim.fn.stdpath("data")

      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
      vim.g.db_ui_show_database_icon = true
      vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_use_nvim_notify = true

      -- NOTE: The default behavior of auto-execution of queries on save is disabled
      -- this is useful when you have a big query that you don't want to run every time
      -- you save the file running those queries can crash neovim to run use the
      -- default keymap: <leader>S
      vim.g.db_ui_execute_on_save = false
    end,
  },
}
