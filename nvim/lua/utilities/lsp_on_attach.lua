local M = {}
function M.on_attach(client, bufnr)
  -- enable inlay hints
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true)
  end
end
return M
