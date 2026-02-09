-- ============================================================================
-- LATEX LANGUAGE SUPPORT (with Zathura)
-- ============================================================================

return {
  -- LaTeX support
  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      -- Set the viewer to Zathura.
      -- Vimtex has built-in support for Zathura, which handles forward
      -- and backward search automatically, provided Zathura and its
      -- dependencies (like synctex) are correctly installed.
      vim.g.vimtex_view_method = 'zathura'
      vim.g.vimtex_syntax_enabled = 1
      -- The auto-save feature from your original config.
      -- This is independent of the PDF viewer.
      vim.api.nvim_create_augroup("auto_save", { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = "auto_save",
        pattern = "*.tex",
        callback = function()
          vim.cmd("silent! write")
        end,
      })
      vim.o.updatetime = 3000
    end
  },
}

