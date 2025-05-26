local M = {}
function M.strict()
  --- @type table?
  local id
  local ok = true
  for _, key in ipairs({ "h", "j", "k", "l", "+", "-" }) do
    local count = 0
    local timer = assert(vim.uv.new_timer())
    local map = key
    local keymap = vim.keymap
    keymap.set("n", key, function()
      if vim.v.count > 1 then
        count = 0
      end
      if count > 10 then
        ok, id = pcall(vim.notify, "use h/j/k/l to navigate... Key: " .. key, vim.log.levels.WARN, {
          title = "🤬",
          replace = id,
          keep = function()
            return count >= 10
          end,
        })
        if not ok then
          id = nil
          return map
        end
      else
        count = count + 1
        timer:start(2000, 0, function()
          count = 0
        end)
        return map
      end
    end, { expr = true, silent = true })
  end
end
return M
