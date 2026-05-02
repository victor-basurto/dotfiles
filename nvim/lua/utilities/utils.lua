local M = {}
local uv = vim.uv

--- Returns true if the current operating system is Windows.
--- Uses libuv's `os_uname` to read the system name and compares
--- it case-insensitively against "windows_nt".
---@return boolean
function M.is_windows()
  return uv.os_uname().sysname:lower() == "windows_nt"
end

--- Copies the absolute path of the current file to the system clipboard,
--- prefixed with "// " for use as a code comment. The home directory portion
--- of the path is replaced with "~" for brevity. Prints the result to the
--- command line. Does nothing if no file is currently open.
function M.copy_full_path()
  local filepath = vim.fn.expand("%:p")
  if filepath == "" then
    print("no file currently open")
    return
  end
  local home = vim.fn.expand("~")
  local display_path = filepath:gsub("^" .. home:gsub("([%(%)%.%+%-%*%?%[%]%^%$%%])", "%%%1"), "~")
  vim.fn.setreg("+", "// " .. display_path)
  print("Copied to clipboard: " .. display_path)
end

--- Copies the path of the current file relative to the working directory
--- to the system clipboard, prefixed with "// " for use as a code comment.
--- Prints the result to the command line. Does nothing if no file is open.
function M.copy_relative_path()
  local filepath = vim.fn.expand("%:.")
  if filepath == "" then
    print("no file currently open")
    return
  end
  vim.fn.setreg("+", "// " .. filepath)
  print("Copied to clipboard: " .. filepath)
end

--- Copies just the filename (no directory) of the current file to the system
--- clipboard, prefixed with "// " for use as a code comment. Prints the result
--- to the command line. Does nothing if no file is currently open.
function M.copy_file_name()
  local filepath = vim.fn.expand("%:t")
  if filepath == "" then
    print("no file currently open")
    return
  end
  vim.fn.setreg("+", "// " .. filepath)
  print("Copied to clipboard: " .. filepath)
end

--- Copies the current date formatted as MM-DD-YYYY to the system clipboard.
--- Prints the copied date string to the command line.
function M.copy_current_date()
  local date = os.date("%m-%d-%Y")
  vim.fn.setreg("+", date)
  print("Copied date: " .. date)
end

return M
