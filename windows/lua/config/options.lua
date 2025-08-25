-- ============================================================================
-- GENERAL SETTINGS
-- ============================================================================

vim.g.mapleader = ";"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.spell = false
vim.opt.spelllang = 'it'
vim.opt.ignorecase = true  -- Make search case-insensitive by default
vim.opt.smartcase = true   -- Switch to case-sensitive if query contains uppercase letters
vim.opt.cursorline = true  -- Enable current line highlighting
vim.opt.clipboard = "unnamedplus"
vim.opt.guicursor = "n-v-c:ver15,i-ci-ve:ver25,r-cr-o:hor20"
vim.opt.selection = "inclusive"
vim.opt.virtualedit = "onemore"
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }