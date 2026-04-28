local M = {}
local uv = vim.uv or vim.loop

-- normalize paths across OS's
function M.normalize_path(path)
  if not path or path == "" then
    return nil
  end
  -- resolve real path if possible (handles symlinks, etc)
  path = uv.fs_realpath(path) or path

  -- normalize slashes to forward slashes
  path = path:gsub("\\", "/")

  -- remove trailing slash
  path = path:gsub("/$", "")

  return path
end

function M.get_vault()
  local path
  -- Try environment variable first
  if vim.env.OBSIDIAN_VAULT and vim.env.OBSIDIAN_VAULT ~= "" then
    path = vim.env.OBSIDIAN_VAULT
  elseif vim.fn.has("mac") == 1 then
    -- macOS path
    path = vim.fn.expand("~/Google Drive/My Drive/obsidian-work")
  elseif vim.fn.has("win32") == 1 then
    -- Windows path
    path = "G:/My Drive/obsidian-work"
  else
    -- Default for Linux or other systems
    path = vim.fn.expand("~/.config/obsidian-vault")
  end

  return M.normalize_path(path)
end

return M
