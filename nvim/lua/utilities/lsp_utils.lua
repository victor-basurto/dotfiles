-- utilities/lsp_utils.lua
local M = {}

-- Simplified function to enable hints once
function M.enable_hints(client, bufnr)
  if client and client.server_capabilities and client.server_capabilities.inlayHintProvider then
    -- use pcall to avoid errors for older servers
    pcall(vim.lsp.inlay_hint, bufnr, true)
  else
    -- defensive fallback: still attempt to enable inlay hints (some servers don't advertise capability)
    pcall(vim.lsp.inlay_hint, bufnr, true)
  end
end

function M.on_attach(client, bufnr)
  -- common keybindings for LSP clients
  local buf_set_keymap = vim.api.nvim_buf_set_keymap
  local opts = { noremap = true, silent = true }

  buf_set_keymap(bufnr, "n", "K", "<cmd>lua require('utilities.lsp_utils').safe_hover()<CR>", opts)
  buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap(bufnr, "n", "gca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

  -- enable inlay hints
  -- M.enable_hints(client, bufnr)
end
function M.safe_hover()
  -- Store the original vim.notify function
  local original_notify = vim.notify

  -- Temporarily replace vim.notify with a function that swallows all messages
  vim.notify = function() end

  -- Execute the hover command (which is asynchronous)
  vim.lsp.buf.hover()

  -- Restore original vim.notify after the LSP client has a chance to send
  -- its asynchronous "no information" message (usually 50ms is plenty).
  vim.defer_fn(function()
    vim.notify = original_notify
  end, 50)
end

return M
