-- ============================================================================
-- LSP CONFIGURATION
-- ============================================================================

return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lspconfig = require("lspconfig")

      -- LaTeX LSP
      lspconfig.texlab.setup {
        cmd = { "texlab" },
        filetypes = { "tex" },
        single_file_support = false,
        root_dir = lspconfig.util.root_pattern("*.tex", ".git"),
        settings = {
          texlab = {
            build = {
              command = "latexmk",
              args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
            },
            forward_search = {
              executable = "SumatraPDF",
              args = { "--synctex-forward", "%l:1:%f", "%p" },
            },
          },
        },
      }

      -- Python LSP
      lspconfig.pyright.setup {
        filetypes = { "python" },
        single_file_support = true,
        root_dir = lspconfig.util.root_pattern(".git", "setup.py", "pyproject.toml", "requirements.txt"),
      }
    end,
  },
}