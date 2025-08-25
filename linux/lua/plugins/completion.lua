-- ============================================================================
-- COMPLETION AND SNIPPETS
-- ============================================================================

return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
    },
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        mapping = {
          ['<CR>'] = cmp.mapping.confirm({ select = false }),

          ['<C-n>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<Up>'] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_selected_entry() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<Down>'] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_selected_entry() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
        },

        sources = {
          { name = 'nvim_lsp', max_item_count = 20 },
          { name = 'buffer', max_item_count = 10, keyword_length = 3 },
          { name = 'path', max_item_count = 10 },
        },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })

      cmp.setup.cmdline('/', {
        sources = { { name = 'buffer' } }
      })

      cmp.setup.cmdline(':', {
        sources = { { name = 'path' }, { name = 'cmdline' } }
      })
    end,
  },
	{
  'SirVer/ultisnips',
  config = function()
    vim.g.UltiSnipsExpandTrigger = '<Tab>'
    vim.g.UltiSnipsJumpForwardTrigger = '<Tab>'
    vim.g.UltiSnipsJumpBackwardTrigger = '<S-Tab>'
  end,
},
}

