-- ============================================================================
-- PYTHON LANGUAGE SUPPORT
-- ============================================================================

return {
  -- Python formatting
  {
    'psf/black',
    ft = 'python',
    config = function ()
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        pattern = "*.py",
        callback = function()
          vim.cmd("Black")
        end,
      })
    end
  },

  -- Python debugging and execution
  {
    "mfussenegger/nvim-dap",
    ft = "python",
    keys = { "<F5>" },
    dependencies = {
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local dap_python = require("dap-python")
      dap_python.setup("python")

      vim.keymap.set("n", "<F5>", function()
        vim.cmd("write")
        local file = vim.fn.expand("%:p")
        if vim.bo.filetype == "python" then
          vim.o.splitright = true
          vim.cmd('vsplit | terminal python "' .. file .. '"')
        end
      end, { desc = "Run Python file in vertical split on right" })
    end,
  },
}