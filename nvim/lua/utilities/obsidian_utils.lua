---@module [TODO:description]
---@author [TODO:description]
---@license [TODO:description]

---@module [TODO:description]
---@author [TODO:description]
---@license [TODO:description]

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

-- TODO: Enable once obsidian is ready for migration
-- return multiple obsidian vault paths to handle archive and new vault
function M.get_vaults()
  local main
  local archive

  -- use OS-specific defaults
  if vim.fn.has("mac") == 1 then
    -- macOS path
    main = vim.fn.expand("~/Google Drive/My Drive/obsidian-work")
    archive = vim.fn.expand("~/Google Drive/My Drive/obsidian-work-archive")
  elseif vim.fn.has("win32") == 1 then
    -- Windows path
    main = "G:/My Drive/obsidian-work"
    archive = "G:/My Drive/obsidian-work-archive"
  else
    -- Default for Linux or other systems
    main = vim.fn.expand("~/.config/obsidian-vault")
    archive = vim.fn.expand("~/.config/obsidian-vault-archive")
  end

  return {
    main = M.normalize_path(main),
    archive = M.normalize_path(archive),
  }
end

-- TODO: once M.get_vaults() is enabled, rename this function to M.get_vault()
-- return the current path for either archive vault or work vault
function M.get_vault_detector()
  local cwd = vim.fn.getcwd()
  local paths = M.get_vaults()

  -- if path is archive, return the archive
  if cwd:find(paths.archive, 1, true) then
    return paths.archive
  end

  -- otherwise main
  return paths.main
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
