-- ============================================================================
-- LSP CONFIGURATION
-- ============================================================================

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- LaTeX LSP
      vim.lsp.config.texlab = {
        cmd = { "texlab" },
        filetypes = { "tex" },
        root_markers = { "*.tex", ".git" },
        settings = {
          texlab = {
            build = {
              command = "latexmk",
              args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
            },
            forward_search = {
              executable = "zathura",
              args = { "--synctex-forward", "%l:1:%f", "%p" },
            },
          },
        },
      }
      vim.lsp.enable("texlab")

      -- Python LSP
      vim.lsp.config.pyright = {
        filetypes = { "python" },
        root_markers = { ".git", "setup.py", "pyproject.toml", "requirements.txt" },
      }
      vim.lsp.enable("pyright")
    end,
  },
}
