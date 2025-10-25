local M = {}

-- Track previous line count to detect deletions
local prev_line_counts = {}

-- enable inlay hints with refresh only on line deletions
function M.enable_hints(client, bufnr)
  if client.server_capabilities.inlayHintProvider then
    local ok = pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
    if not ok then
      vim.notify("Failed to enable inlay hints for buffer " .. bufnr, vim.log.levels.WARN)
      return
    end

    -- Store initial line count
    prev_line_counts[bufnr] = vim.api.nvim_buf_line_count(bufnr)

    -- Only refresh on line deletions (which cause the bug)
    vim.api.nvim_create_autocmd({ "TextChanged" }, {
      buffer = bufnr,
      callback = function()
        local current_lines = vim.api.nvim_buf_line_count(bufnr)
        local prev_lines = prev_line_counts[bufnr] or current_lines

        -- Only refresh if lines were deleted
        if current_lines < prev_lines then
          vim.defer_fn(function()
            if vim.api.nvim_buf_is_valid(bufnr) then
              pcall(vim.lsp.inlay_hint.enable, false, { bufnr = bufnr })
              vim.defer_fn(function()
                if vim.api.nvim_buf_is_valid(bufnr) then
                  pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
                end
              end, 50)
            end
          end, 10)
        end

        prev_line_counts[bufnr] = current_lines
      end,
    })
  end
end

function M.on_attach(client, bufnr)
  -- common keybindings for LSP clients
  local buf_set_keymap = vim.api.nvim_buf_set_keymap
  local opts = { noremap = true, silent = true }

  buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap(bufnr, "n", "gca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

  -- enable inlay hints
  M.enable_hints(client, bufnr)
end

return M
