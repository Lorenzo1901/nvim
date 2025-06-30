-- ============================================================================
-- LAZY.NVIM BOOTSTRAP
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- Clone lazy.nvim if it doesn't exist
if not (vim.uv or vim.loop).fs_stat(lazypath) then
 vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)
-- Install neovim-remote and pynvim if missing
if not vim.fn.executable("nvr") then
   vim.fn.system("pip3 install --user neovim-remote pynvim")
end
-- ============================================================================
-- LOAD CONFIGURATION
-- ============================================================================
require("config.options")
require("config.keymaps")
require("config.autocmds")
-- ============================================================================
-- SETUP PLUGINS
-- ============================================================================
require("lazy").setup({
 spec = {
   { import = "plugins" },
   { import = "plugins.languages" },
 },
 change_detection = { notify = false }
})