-- ============================================================================
-- PYTHON LANGUAGE SUPPORT
-- ============================================================================

return {
  -- Python formatting
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    cmd = 'ConformInfo',
    opts = {
      formatters_by_ft = {
        python = { "black" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },

  -- Python debugging and execution
  {
    "mfussenegger/nvim-dap",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      require("dap-python").setup("python")
      
      vim.keymap.set("n", "<F5>", function()
        vim.cmd("write")
        local file = vim.fn.expand("%:p")
        vim.opt.splitright = true
        vim.cmd('vsplit | terminal python "' .. file .. '"')
      end)
    end,
  },
}
