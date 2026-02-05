--- mason.lua
---@diagnostic disable: missing-fields
return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        -- Ensure Neovim dev types are included
        "lazy.nvim",
        "nvim-lspconfig",
      },
    },
  },
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
        "emmet-ls",
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
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      "folke/lazydev.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")
      local lsp_utils = require("utilities.lsp_utils")

      -- 1. Setup Capabilities (Blink Integration)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_blink, blink = pcall(require, "blink.cmp")
      if ok_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      -- default path for .NET SDK in macOS/Linux
      -- vim.env.DOTNET_ROOT = "/usr/local/share/dotnet"

      -- If running on Windows, set the path to the .NET SDK accordingly
      -- if global_utils.is_windows() then
      --   vim.env.DOTNET_ROOT = "C:\\Program Files\\dotnet"
      -- end
      -- vim.lsp.enable("omnisharp")

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
      -- Lua
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
            diagnostics = { globals = { "vim" } },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                -- "${3rd}/luv/library"
              },
            },
            hint = { enable = true },
            telemetry = { enable = false },
          },
        },
      })
      -- Typescript
      require("typescript").setup({
        server = {
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            -- Use your custom attach logic if it exists
            if lsp_utils.on_attach then
              lsp_utils.on_attach(client, bufnr)
            end
            vim.diagnostic.enable(true, { bufnr = bufnr })
          end,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayVariableTypeHints = true,
              },
            },
          },
        },
      })
      -- 5. JSON/Sitecore Setup
      lspconfig.jsonls.setup({
        capabilities = capabilities,
        settings = {
          json = {
            schemas = {
              {
                fileMatch = { "/sitecore.json" },
                url = vim.fn.stdpath("config") .. "/.sitecore/schemas/RootConfigurationFile.schema.json",
              },
              {
                fileMatch = { "*.module.json" },
                url = vim.fn.stdpath("config") .. "/.sitecore/schemas/ModuleFile.schema.json",
              },
            },
          },
        },
      })
      local servers = { "cssls", "html", "yamlls", "emmet_ls", "bashls", "astro", "prismals", "omnisharp" }
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup({
          capabilities = capabilities,
          on_attach = lsp_utils.on_attach,
        })
      end

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
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
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
        "tsserver",
        "lemminx",
        "yamlls",
        "omnisharp",
      },
    },
  },
}
