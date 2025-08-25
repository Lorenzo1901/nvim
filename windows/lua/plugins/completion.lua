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
      'sirver/ultisnips',
    },
    config = function()
      local cmp = require('cmp')
      
      vim.cmd([[
        function! SuperTab(command)
          if a:command == 'n'
            return "\<Tab>"
          else
            return "\<Tab>"
          endif
        endfunction
      ]])
      
      vim.g.UltiSnipsExpandTrigger = ""
      vim.g.UltiSnipsJumpForwardTrigger = ""  
      vim.g.UltiSnipsJumpBackwardTrigger = ""
      
      local function t(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end
      
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
          end,
        },
        
        mapping = {
          ['<CR>'] = cmp.mapping.confirm({ select = false }),

          ['<Tab>'] = cmp.mapping(function(fallback)
            if vim.fn["UltiSnips#CanExpandSnippet"]() == 1 or vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
              local mode = vim.fn.mode()
              if mode == 's' then
                vim.api.nvim_feedkeys(t("<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>"), "s", true)
              else
                vim.api.nvim_feedkeys(t("<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>"), "i", true)
              end
            elseif vim.fn.exists('*copilot#Accept') == 1 then
              local suggestion = vim.fn['copilot#GetDisplayedSuggestion']()
              if suggestion.text ~= '' then
                vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](t("<Tab>")), "i", true)
              elseif cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            elseif cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
              local mode = vim.fn.mode()
              if mode == 's' then
                vim.api.nvim_feedkeys(t("<C-R>=UltiSnips#JumpBackwards()<CR>"), "s", true)
              else
                vim.api.nvim_feedkeys(t("<C-R>=UltiSnips#JumpBackwards()<CR>"), "i", true)
              end
            elseif cmp.visible() then
              cmp.select_prev_item()
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
        sources = {{ name = 'buffer' }}
      })
      
      cmp.setup.cmdline(':', {
        sources = {{ name = 'path' }, { name = 'cmdline' }}
      })
    end,
  },
}