-- ============================================================================
-- TREESITTER PLUGIN
-- ============================================================================

return {
  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = { "lua", "python", "javascript", "html", "css", "latex" },
        auto_install = false,
        highlight = { 
          enable = true,
	  additional_vim_regex_highlighting = { "latex" },
        },
        indent = { enable = true }
      }
    end
  },
}
