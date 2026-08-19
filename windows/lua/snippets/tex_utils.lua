local ls = require("luasnip")
local sn = ls.snippet_node
local i = ls.insert_node

local M = {}

function M.in_mathzone()
  local ft = vim.bo.filetype
  if ft == "tex" then
    if vim.fn["vimtex#syntax#in_mathzone"]() == 0 then
      return false
    end
  else
    local ok, inspect = pcall(vim.api.nvim_exec2, "Inspect", { output = true })
    if ok and not inspect.output:lower():find("math") then
      return false
    end
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local cursor_byte = cursor[2]
  local line_prefix = line:sub(1, cursor_byte)

  local depth = 0
  for idx = #line_prefix, 1, -1 do
    local char = line_prefix:sub(idx, idx)
    if char == "$" then
      return true
    elseif char == "}" then
      depth = depth + 1
    elseif char == "{" then
      if depth == 0 then
        if idx >= 6 and line_prefix:sub(idx - 5, idx - 1) == "\\text" then
          return false
        end
        if idx >= 8 and (line_prefix:sub(idx - 7, idx - 1) == "\\textbf" or line_prefix:sub(idx - 7, idx - 1) == "\\textit") then
          return false
        end
      else
        depth = depth - 1
      end
    end
  end
  return true
end

function M.not_in_mathzone()
  return not M.in_mathzone()
end

function M.get_visual(args, parent)
  if parent and parent.snippet and parent.snippet.env and parent.snippet.env.LS_SELECT_RAW and #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    return sn(nil, i(1))
  end
end

function M.line_begin(line_to_cursor, matched_trigger)
  local prefix = line_to_cursor:sub(1, -(#matched_trigger + 1))
  return prefix:match("^%s*$") ~= nil
end

return M
