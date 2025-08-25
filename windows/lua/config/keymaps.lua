-- ============================================================================
-- KEY MAPPINGS
-- ============================================================================

-- Helper function for window navigation
local function index_of(tbl, val)
  for i, v in ipairs(tbl) do
    if v == val then return i end
  end
end

-- Window navigation
vim.keymap.set("n", "<Tab>", function()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local cur = vim.api.nvim_get_current_win()
  local idx = index_of(wins, cur)
  local next_win = wins[(idx % #wins) + 1]
  vim.api.nvim_set_current_win(next_win)
end, { desc = "Focus next window" })

vim.keymap.set("n", "<S-Tab>", function()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local cur = vim.api.nvim_get_current_win()
  local idx = index_of(wins, cur)
  local prev_win = wins[(idx - 2) % #wins + 1]
  vim.api.nvim_set_current_win(prev_win)
end, { desc = "Focus previous window" })

-- Clipboard operations
vim.keymap.set("i", "<C-v>", "<C-r>+", { noremap = true, silent = true })
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })
vim.keymap.set("v", "<C-x>", '"+d', { noremap = true, silent = true })

-- Visual mode mappings
vim.keymap.set('v', '<Tab>', '>gv', { desc = 'Indent' })
vim.keymap.set('v', '<S-Tab>', '<gv', { desc = 'Unindent' })

vim.keymap.set('v', "'", "c''<Esc>P`[v`]l", { desc = 'Wrap with single quotes' })
vim.keymap.set('v', '"', 'c""<Esc>P`[v`]l', { desc = 'Wrap with double quotes' })
vim.keymap.set('v', '$', 'c$$<Esc>P`[v`]l', { desc = 'Wrap with dollar signs' })

-- Spell checking
vim.api.nvim_set_keymap('i', '<C-l>', '<c-g>u<Esc>[s1z=]a<c-g>u', { noremap = true, silent = true })

-- LaTeX formatting
vim.api.nvim_set_keymap('v', '<M-b>', "c\\textbf{<C-r>\"}", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<M-i>', "c\\textit{<C-r>\"}", { noremap = true, silent = true })

-- LaTeX compilation
vim.api.nvim_set_keymap('n', '<C-o>', ':w<CR>:VimtexCompile<CR>', { noremap = true, silent = true })

-- Manim execution
vim.keymap.set("n", "<S-F5>", function()
  vim.cmd("write")
  local dir = vim.fn.expand("%:p:h")
  local filename = vim.fn.expand("%:t")
  local class = vim.fn.expand("%:t:r")
  local cmd = "cd " .. dir .. " && manim -pql " .. filename .. " " .. class
  vim.o.splitright = true
  vim.cmd("vsplit")
  vim.cmd("terminal " .. cmd)
end, { desc = "Run Manim scene", noremap = true, silent = true })