-- ============================================================================
-- AUTOCOMMANDS
-- ============================================================================

-- Custom highlights and colors (deferred)
vim.schedule(function()
    -- Current line number color
    vim.cmd([[
        highlight CursorLineNr guifg=#f48c06
    ]])

    -- LaTeX math delimiters highlighting
    vim.api.nvim_set_hl(0, "TexMathDelimiter", { fg = "#bb70d2" })

    -- Rainbow indent colors
    local hooks = require "ibl.hooks"
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    end)
    require("ibl").setup { 
        indent = { 
            highlight = { 
                "RainbowRed", "RainbowYellow", "RainbowBlue", 
                "RainbowOrange", "RainbowGreen", "RainbowViolet", "RainbowCyan" 
            } 
        } 
    }
end)

-- LaTeX-specific autocmd
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "*.tex",
  callback = function()
    vim.fn.matchadd("TexMathDelimiter", [[\\\[\|\\\]\|\$]], 10)
  end,
})