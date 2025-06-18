local M = {}
local uv = vim.uv
function M.is_windows()
  -- Check if the OS is Windows
  return uv.os_uname().sysname:lower() == "windows_nt"
end
return M
