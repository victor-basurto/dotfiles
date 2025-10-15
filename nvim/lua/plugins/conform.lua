return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  lazy = true,
  keys = {
    {
      "<leader>ccf",
      function()
        -- When manually formatting, ensure `lsp_fallback` is still active or conform is aware of LSP
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "n",
      desc = "Format buffer (Conform)",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      less = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
    },
    formatters = {

      stylua = {
        command = "stylua",
        args = { "--search-parent-directories", "--stdin-filepath", "$FILENAME", "-" },
        stdin = true,
        condition = function(ctx)
          return vim.bo.filetype == "lua"
        end,
      },
      -- is better to handle prettier per project
      prettier = {
        prepend_args = {
          -- "--print-width",
          -- "290",
        },
      },
      ["markdown-toc"] = {
        condition = function(_, ctx)
          for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
            if line:find("<!%-%- toc %-%->") then
              return true
            end
          end
        end,
      },
      ["markdownlint-cli2"] = {
        condition = function(_, ctx)
          local diag = vim.tbl_filter(function(d)
            return d.source == "markdownlint"
          end, vim.diagnostic.get(ctx.buf))
          return #diag > 0
        end,
      },
    },
    init = function()
      -- Ensure conform is available when format_on_save triggers
      vim.filetype.add({
        pattern = { ["%.jsx?$"] = "javascript", ["%.tsx?$"] = "typescript" },
        -- Use a more comprehensive filetype detection if needed
      })
    end,
  },
}
