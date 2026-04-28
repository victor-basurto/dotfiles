local M = {}
local uv = vim.uv or vim.loop

-- Normalize paths across operating systems.
function M.normalize_path(path)
  if not path or path == "" then
    return nil
  end
  -- Resolve the real path when possible,
  path = uv.fs_realpath(path) or path

  -- convert backslashes to forward slashes,
  path = path:gsub("\\", "/")

  -- remove trailing slash
  path = path:gsub("/$", "")

  return path
end

-- Get the Obsidian vault path.
function M.get_vault()
  local path
  -- Prefer OBSIDIAN_VAULT from the environment
  if vim.env.OBSIDIAN_VAULT and vim.env.OBSIDIAN_VAULT ~= "" then
    path = vim.env.OBSIDIAN_VAULT

  -- use OS-specific defaults
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

-- Move the current file into the zettelkasten folder.
function M.move_current_file_to_zettelkasten()
  -- try rename first for same-drive moves
  -- if that fails, fall back to copy + delete.
  local source = vim.fn.expand("%:p")
  if source == "" then
    return
  end

  local vault = M.get_vault()
  local target = vault .. "/zettelkasten/" .. vim.fn.fnamemodify(source, ":t")

  local ok = os.rename(source, target)
  if not ok then
    vim.notify("rename failed, falling back to copy + delete: " .. target, vim.log.levels.WARN)
    vim.fn.writefile(vim.fn.readfile(source), target)
    os.remove(source)
  end

  -- close the buffer after teh file has been removed
  vim.cmd("bd")
end

-- Delete the current file from disk and close the buffer.
function M.delete_current_file_and_buffer()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return
  end

  vim.fn.delete(file)
  vim.api.nvim_buf_delete(0, { force = true })
end

return M
