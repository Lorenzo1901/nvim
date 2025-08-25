-- ============================================================================
-- UI AND APPEARANCE PLUGINS
-- ============================================================================

return {
-- Dashboard
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")
            local button = dashboard.button

            dashboard.section.header.val = {
[[                              ...::;;++xxxxxxx++;;::.                 ]],
[[                    .:+xXXX++++++++++++++++;X$&&&&$X++X$XXx;:  .      ]],
[[             .:+xXX+X&&$x+xxxxxxxxxxxxxXXXxx++::;+XX$$&&&&++$Xx+.     ]],
[[        ..+xXX+$&&$$X+:+xXXXXXXXXXXXXXXXXXXXXx+; .::::xX$$&&$;$Xx+ .  ]],
[[     ..+xX+X&&$$X;::::+xXXXXXXXXXXXXXXXXXXXXXX++:   .::;X$$&&$+$X+    ]],
[[  . .xxX+X&&$$X;::.  :+xXXXXXXXXXXXXXXXXXXXxxXX+;  .:::xX$&&$;XXx:    ]],
[[    +XXX+&&$$X+:::.  :xX$XXXXXXXXXXXXX$$$$$XXXx+:.:::xX$&&$;XXx:      ]],
[[    ;xX$;X&&$$Xx::::. ;xxXXXX$$$$$$$$$$$XXXXx+;;;xX$&&&x+Xx+:         ]],
[[     .+xX$x+&&&&$$XX+;::;++++xxxxxx++++++xxXX$$&&$+xXX+;.             ]],
[[         :+xXX$X++X&&&&&&$$$$$$$$$$$$$$$XxxxXXx+;:.                   ]],
[[                ..:;;+xxxXxXxxxxx++;;::.                              ]],
            }

            dashboard.section.buttons.val = {
                button("f", "  Find file", ":lua require('lazy').load({plugins={'fzf.vim'}}) vim.cmd('FZF /home/lor/Documents/uni/')<CR>"),
		button("r", "󰋚  Recent files", ":lua require('lazy').load({plugins={'fzf.vim'}}) vim.cmd('History')<CR>"),
                button("e", "  New file", ":ene <BAR> startinsert <CR>"),
                button("c", "  Configuration", ":lua require('lazy').load({plugins={'fzf.vim'}}) vim.cmd('FZF /home/lor/.config/nvim/')<CR>"),
                button("u", "  Update plugins", ":Lazy sync<CR>"),
                button("q", "  Quit", ":qa<CR>")
            }

            dashboard.section.footer.val = "It's gonna be a long long time..."
            alpha.setup(dashboard.opts)
        end
    },

  -- Theme
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require('onedark').setup { style = 'warmer' }
      require('onedark').load()
    end
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = { },
          lualine_y = {'progress'},
          lualine_z = {'location'}
        }
      }
    end
  },

  -- Indent lines with rainbow colors
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {},
  },
}
