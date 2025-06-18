local M = {}
function M.enable_hints(client, bufnr)
  -- enable inlay hints
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true)
  end
end
return M
