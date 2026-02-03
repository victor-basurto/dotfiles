--- mason.lua
---@diagnostic disable: missing-fields
-- Disable lsp-inlayhints if that is nightly version, will remove when 0.10.0 is stable
-- local enabled_inlay_hints = true
-- if vim.fn.has("nvim-0.10.0") == 1 then
--   enabled_inlay_hints = true
-- end
return {
  {
    "mason-org/mason.nvim",
    version = "2.2.1",
    opts = {
      ensure_installed = {
        "gitui",
        "stylua",
        "shellcheck",
        "tailwindcss-language-server",
        "shfmt",
        "luacheck",
        "prettier",
        "eslint_d",
        "markdownlint-cli2",
        "markdown-toc",
        "emmet-language-server",
      },
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "astro",
        "bashls",
        "cssls",
        "eslint",
        "emmet_ls",
        "graphql",
        "html",
        "jsonls",
        "lua_ls",
        "powershell_es",
        "prismals",
        "sqlls",
        "vimls",
        "ts_ls",
        "lemminx",
        "yamlls",
        "omnisharp",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = true,
      },
      setup = {
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
      },
    },
    dependencies = { "jose-elias-alvarez/typescript.nvim" },
    config = function()
      local lsp_utils = require("utilities.lsp_utils")
      local global_utils = require("utilities.utils")
      local lspconfig = require("lspconfig")
      -- local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local util = require("lspconfig.util")

      local capabilities = {
        textDocument = {
          completion = {
            completionItem = {
              snippetSupport = true,
              resolveSupport = {
                properties = {
                  "documentation",
                  "detail",
                  "additionalTextEdits",
                },
              },
              triggerCharacters = {
                ".",
                ":",
              },
            },
          },
        },
      }
      capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

      -- default path for .NET SDK in macOS/Linux
      vim.env.DOTNET_ROOT = "/usr/local/share/dotnet"

      -- If running on Windows, set the path to the .NET SDK accordingly
      if global_utils.is_windows() then
        vim.env.DOTNET_ROOT = "C:\\Program Files\\dotnet"
      end
      -- vim.lsp.enable("omnisharp")
      lspconfig.omnisharp.setup({
        capabilities = capabilities,
        on_attach = lsp_utils.on_attach,
        cmd = { "omnisharp", "--languageserver" },
        enable_import_completion = true,
        organize_imports_on_format = true,
        enable_roslyn_analyzers = true,
        settings = {
          RoslynExtensionsOptions = {
            EnableAnalyzersSupport = true,
            EnableDecompilationSupport = true,
            EnableEditorConfigSupport = true,
            EnableImportCompletion = true,
            EnableUpdateDiagnosticNetAnalyzers = true,
          },
          -- Also explicitly tell Omnisharp's settings where to find .NET CLI tools
          DotNetCliPaths = {
            vim.env.DOTNET_ROOT,
          },
          -- Consider adding this if you still see older .NET version issues
          -- UseModernNet = true, -- This is sometimes a setting for Omnisharp
        },
      })

      lspconfig.marksman.setup({

        capabilities = capabilities,
        on_attach = function(client, bufnr)
          lsp_utils.on_attach(client, bufnr)
          local obsidian_lsp_status, obsidian_lsp = pcall(require, "obsidian.lsp")
          if obsidian_lsp_status and obsidian_lsp and obsidian_lsp.on_attach then
            obsidian_lsp.on_attach(client, bufnr)
          end
        end,

        settings = {
          marksman = {
            root = (function()
              local obsidian = require("obsidian")
              -- Use pcall/or short-circuiting in case get_config() is still nil
              local vault_path = pcall(obsidian.get_config) and obsidian.get_config().workspaces[1].path
                or vim.fn.getcwd()
              print(vault_path)
              return vault_path
            end)(),
          },
        },

        -- Keep the custom root_dir to help Lspconfig/Marksman initialization,
        -- but the 'settings' above should be the definitive fix.
        root_dir = util.root_pattern("marksman.json")
          or function()
            local obsidian = require("obsidian")
            local vault_path = pcall(obsidian.get_config) and obsidian.get_config().workspaces[1].path
              or vim.fn.getcwd()
            return vault_path
          end,
      })
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = lsp_utils.on_attach,
        root_dir = util.root_pattern(".git", ".nvim-root", "init.lua", "lua"),
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT", -- Re-added
            },
            diagnostics = {
              globals = { "vim", "LazyVim", "MiniHipatterns", "cmp", "snacks" }, -- Re-added
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
            semanticTokens = { enable = true }, -- Re-added
            format = { enable = false }, -- Re-added
            telemetry = { enable = false }, -- Re-added
            hint = {
              enable = false,
              array_index = "Disable",
              param_name_file = "Disable",
              param_name_group = "LspHint",
              param_name_luadoc = "Disable",
              param_name_only = "Disable",
              param_name_table = "Disable",
              semicolon = "Disable",
            },
          },
        },
      })
      lspconfig.tsserver.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          lsp_utils.on_attach(client, bufnr)
          vim.defer_fn(function()
            if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
              -- This enables the visual component for the buffer
              vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
          end, 100)
        end,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              -- includeInlayVariableTypeHints = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHintsWhenTypeMatchesName = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              -- includeInlayVariableTypeHints = true,

              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHintsWhenTypeMatchesName = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      })
      lspconfig.cssls.setup({})
      lspconfig.html.setup({})
      lspconfig.jsonls.setup({
        settings = {
          json = {
            schemas = {
              {
                fileMatch = { "/sitecore.json" },
                url = vim.fn.stdpath("config") .. "/.sitecore/schemas/RootConfigurationFile.schema.json",
              },
              {
                fileMatch = { "/.sitecore/user.json" },
                url = vim.fn.stdpath("config") .. "/.sitecore/schemas/UserConfiguration.schema.json",
                -- Or: url = vim.fn.getcwd() .. "/.sitecore/schemas/UserConfiguration.schema.json",
              },
              {
                fileMatch = { "*.module.json" },
                url = vim.fn.stdpath("config") .. "/.sitecore/schemas/ModuleFile.schema.json",
                -- Or: url = vim.fn.getcwd() .. "/.sitecore/schemas/ModuleFile.schema.json",
              },
            },
          },
        },
      })
      lspconfig.yamlls.setup({})
      -- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      -- vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity = {
          hint = false,
        },
        float = {
          border = "rounded",
          focusable = false,
        },
      })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach_group", { clear = true }),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.name == "tsserver" then
            vim.diagnostic.enable()
          end
        end,
      })
    end,
  },
}
