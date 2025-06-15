---@diagnostic disable: missing-fields
return {
  {
    "williamboman/mason.nvim",
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
      },
    },
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "astro",
          "bashls",
          "cssls",
          "eslint",
          "graphql",
          "html",
          "jsonls",
          "lua_ls",
          "powershell_es",
          "prismals",
          "sqlls",
          "ts_ls",
          "vimls",
          "lemminx",
          "yamlls",
          "omnisharp",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local util = require("lspconfig.util")
      vim.env.DOTNET_ROOT = "/usr/local/share/dotnet"
      -- vim.lsp.enable("omnisharp")
      lspconfig.omnisharp.setup({
        capabilities = capabilities,
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

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        root_dir = util.root_pattern(".git", ".nvim-root", "init.lua", "lua"),
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
              library = {
                vim.fn.expand("$VIMRUNTIME/lua"),
                vim.fn.stdpath("config") .. "/lua",
              },
              ignoreDir = {
                ".git",
                "node_modules",
                "venv",
                "dist",
                "build",
                "__pycache__",
                "target",
                ".next",
                "AppData",
                "Downloads",
                "Documents",
                "OneDrive",
              },
            },
            hint = {
              enable = true,
              array_index = "Enable",
              param_name_file = "Inline",
              param_name_group = "LspHint",
              param_name_luadoc = "Inline",
              param_name_only = "Inline",
              param_name_table = "Inline",
              semicolon = "Disable",
            },
          },
        },
      })
      lspconfig.tsserver.setup({
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              enabled = true,
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              -- other tsserver-specific inlay hints options if needed
            },
          },
          javascript = {
            inlayHints = {
              enabled = true,
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              -- other tsserver-specific inlay hints options if needed
            },
          },
        },
      })
      lspconfig.cssls.setup({})
      lspconfig.html.setup({})
      lspconfig.jsonls.setup({})
      lspconfig.yamlls.setup({})
      lspconfig.marksman.setup({})
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
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
