local M = {}
local uv = vim.uv

-- Check if the OS is Windows
function M.is_windows()
  return uv.os_uname().sysname:lower() == "windows_nt"
end
return M
