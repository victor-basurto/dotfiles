local M = {}

function M.get_vault()
  -- Try environment variable first
  if vim.env.OBSIDIAN_VAULT and vim.env.OBSIDIAN_VAULT ~= "" then
    return vim.fs.normalize(vim.env.OBSIDIAN_VAULT)
  end

  -- Platform-specific fallbacks (matching your original working code)
  local path
  if vim.fn.has("mac") == 1 then
    -- macOS path
    path = vim.fn.expand("~/Google Drive/My Drive/obsidian-work")
  elseif vim.fn.has("win32") == 1 then
    -- Windows path
    path = "G:/My Drive/obsidian-work"
  else
    -- Default for Linux or other systems
    path = vim.fn.expand("~/.config/obsidian-vault")
  end

  return vim.fs.normalize(path)
end

return M
