local ls = require("luasnip")
local sn = ls.snippet_node
local i = ls.insert_node

local M = {}

--- Check if the cursor is currently inside a text command within math mode (e.g. \text{...})
local function is_in_text_command(line, col)
  local line_prefix = line:sub(1, col)
  return line_prefix:match("\\text%s*{[^}]*$") ~= nil
    or line_prefix:match("\\textbf%s*{[^}]*$") ~= nil
    or line_prefix:match("\\textit%s*{[^}]*$") ~= nil
    or line_prefix:match("\\mathrm%s*{[^}]*$") ~= nil
    or line_prefix:match("\\textnormal%s*{[^}]*$") ~= nil
end

--- Treesitter-based math zone detection
local function treesitter_in_mathzone()
  local has_ts, _ = pcall(require, "vim.treesitter")
  if not has_ts then return nil end

  local bufnr = vim.api.nvim_get_current_buf()
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok or not parser then return nil end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1
  local col = cursor[2]
  local line = vim.api.nvim_get_current_line()

  -- Check current position and previous char position (crucial for insert mode)
  local positions = { { row, col } }
  if col > 0 then
    table.insert(positions, { row, col - 1 })
  end

  for _, pos in ipairs(positions) do
    local node = vim.treesitter.get_node({ bufnr = bufnr, pos = pos, ignore_injections = false })
    local curr = node
    while curr do
      local ntype = curr:type()
      if
        ntype:find("math")
        or ntype == "inline_formula"
        or ntype == "displayed_equation"
        or ntype == "math_environment"
        or ntype == "latex_block"
      then
        if is_in_text_command(line, col) then
          return false
        end
        return true
      end
      curr = curr:parent()
    end
  end

  return nil
end

--- Fallback scanner (regex & buffer inspection)
local function fallback_in_mathzone()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]
  local col = cursor[2]
  local line = vim.api.nvim_get_current_line()
  local line_prefix = line:sub(1, col)

  -- 1. Check if inside \text{...}
  if is_in_text_command(line, col) then
    return false
  end

  -- 2. Check for LaTeX math environments
  local math_envs = {
    "equation", "equation%*",
    "align", "align%*",
    "alignat", "alignat%*",
    "gather", "gather%*",
    "multline", "multline%*",
    "matrix", "pmatrix", "bmatrix", "Bmatrix", "vmatrix", "Vmatrix",
    "cases", "array", "displaymath", "math"
  }

  -- 3. Check single-line display math $$...$$
  local clean_prefix = line_prefix:gsub("\\%$", "")
  local _, count_display = clean_prefix:gsub("%$%$", "")
  if count_display % 2 == 1 then
    return true
  end

  -- 4. Check single-line inline math $...$
  local prefix_no_display = clean_prefix:gsub("%$%$", "")
  local _, count_inline = prefix_no_display:gsub("%$", "")
  if count_inline % 2 == 1 then
    return true
  end

  -- 5. Check multi-line display math $$...$$ or LaTeX environments by scanning upwards
  local bufnr = vim.api.nvim_get_current_buf()
  local cur_row = row - 1
  local min_row = math.max(1, row - 100) -- limit scan depth for performance

  local multiline_display_toggles = 0

  while cur_row >= min_row do
    local prev_line = vim.api.nvim_buf_get_lines(bufnr, cur_row - 1, cur_row, false)[1] or ""
    
    -- Stop if we hit a code fence (```)
    if prev_line:match("^%s*```") then
      break
    end

    -- Check for LaTeX environments
    for _, env in ipairs(math_envs) do
      if prev_line:match("\\begin%s*{" .. env .. "}") then
        return true
      elseif prev_line:match("\\end%s*{" .. env .. "}") then
        return false
      end
    end

    -- Count $$ delimiters on the line
    local clean_prev = prev_line:gsub("\\%$", "")
    local _, d_count = clean_prev:gsub("%$%$", "")
    multiline_display_toggles = multiline_display_toggles + d_count

    cur_row = cur_row - 1
  end

  if multiline_display_toggles % 2 == 1 then
    return true
  end

  return false
end

function M.in_mathzone()
  local ft = vim.bo.filetype
  if ft == "tex" and vim.fn.exists("*vimtex#syntax#in_mathzone") == 1 then
    return vim.fn["vimtex#syntax#in_mathzone"]() == 1
  end

  -- Try Treesitter first (with ignore_injections = false)
  local ts_result = treesitter_in_mathzone()
  if ts_result ~= nil then
    return ts_result
  end

  -- Fallback to buffer scanner
  return fallback_in_mathzone()
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
