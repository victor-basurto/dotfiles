local M = {}
-- by default, windows doesnt remove the file, only closes the current buffer from where the command was triggered
-- in order to delete the file from the system this custom function will handle windows shell deletion
function M.del_buffer_win()
  -- get full path of the current buffer
  local filename = vim.fn.expand("%:p")

  -- check if the file exists
  if filename == "" or vim.bo.buftype ~= "" then
    vim.notify("No file to delete", vim.log.levels.WARN)
    return
  end

  -- ask for confirmation
  vim.ui.input({
    prompt = "Are you sure you want to delete this file?" .. filename .. "(y/n): ",
    default = "n",
  }, function(input)
    if input and input:lower() == "y" then
      -- close the buffer
      vim.cmd("bd!") -- buffer delete (force)

      -- Construct the PowerShell command.
      -- -NoProfile: Speeds up PowerShell execution by not loading the user profile.
      -- -Command: Specifies the command to execute.
      -- Remove-Item: The PowerShell cmdlet for deleting files/folders.
      -- -Path: Specifies the file path. Paths with spaces must be quoted, and quotes need to be escaped for Lua and PowerShell.
      -- -Force: Forces the deletion, even if the file is read-only (similar to '/F' in 'del').
      -- -ErrorAction Stop: Ensures that any error encountered by Remove-Item is treated as a terminating error.
      -- -ErrorVariable pserr: Stores any error messages in a PowerShell variable named 'pserr'.
      -- ; if ($pserr) { exit 1 }: If 'pserr' contains an error, exit PowerShell with a non-zero code (indicating failure to Neovim).
      local ps_cmd = 'powershell.exe -NoProfile -Command "Remove-Item -Path \\"'
        .. filename
        .. '\\" -Force -ErrorAction Stop -ErrorVariable pserr; if ($pserr) { exit 1 }"'

      local output = vim.fn.system(ps_cmd) -- execute the PowerShell command
      local exit_code = vim.v.shell_error -- check if the exit code of the last shell command is 0 (success)
      if exit_code == 0 then
        vim.notify("File deleted " .. filename, vim.log.levels.INFO)
      else
        vim.notify(
          "Failed to delete file: "
            .. filename
            .. ". PowerShell Error: "
            .. output
            .. " (Exit Code: "
            .. exit_code
            .. ")",
          vim.log.levels.ERROR
        )
      end
    else
      vim.notify("File not deleted", vim.log.levels.INFO)
    end
  end)
end
return M
