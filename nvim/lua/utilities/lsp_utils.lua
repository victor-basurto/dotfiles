-- utilities/lsp_utils.lua
local M = {}

-- Helper function to check filetype
local function is_filetype(bufnr, filetype)
  return vim.bo[bufnr].filetype == filetype
end

-- Simplified function to enable hints once
function M.enable_hints(client, bufnr)
  -- Check if the client supports inlay hints (and if the Neovim version supports it)
  if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

function M.on_attach(client, bufnr)
  -- common keybindings for LSP clients
  local buf_set_keymap = vim.api.nvim_buf_set_keymap
  local opts = { noremap = true, silent = true }

  buf_set_keymap(bufnr, "n", "K", "<cmd>lua require('utilities.lsp_utils').safe_hover()<CR>", opts)
  buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)

  -- Conditional logic for Lua and TypeScript LSPs
  if is_filetype(bufnr, "lua") and client.name == "lua_ls" then
    print("Lua LSP attached to buffer " .. bufnr)
  elseif is_filetype(bufnr, "typescript") and client.name == "tsserver" then
    print("TypeScript LSP attached to buffer " .. bufnr)
  end
  buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap(bufnr, "n", "gca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

  -- enable inlay hints
  M.enable_hints(client, bufnr)
end

function M.safe_hover()
  vim.lsp.buf.hover()
end

return M
