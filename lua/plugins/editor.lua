-- ============================================================================
-- EDITOR PLUGINS
-- ============================================================================

return {
  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus" },
    keys = { "<C-n>" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
          side = "left",
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
        sync_root_with_cwd = false,
      })

      vim.keymap.set("n", "<C-n>", function()
        require("nvim-tree.api").tree.toggle({ path = "C:\\Users\\Lorenzo\\Desktop\\Uni" })
      end, { noremap = true, silent = true })
    end,
  },

  -- FZF fuzzy finder
  {
    "junegunn/fzf",
    cmd = { "FZF", "Files", "Buffers", "Lines" },
    build = function() 
      vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/junegunn/fzf.git", "~/.fzf" })
      vim.fn.system({ "~/.fzf/install" }) 
    end
  },
  {
    "junegunn/fzf.vim",
    cmd = { "FZF", "Files", "Buffers", "Lines" },
    dependencies = { "junegunn/fzf" },
  },

  -- Document outline
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen", "OutlineClose" },
    keys = { "<C-k>" },
    config = function()
      require("outline").setup()
      vim.keymap.set("n", "<C-k>", "<cmd>Outline<CR>", { desc = "Open/Close Outline" })
    end,
  },

  -- Autopairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup{}
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },

  -- Code folding
  {
    "kevinhwang91/nvim-ufo",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end
      })

      vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
    end,
  },

  -- GitHub Copilot
  { 
    'github/copilot.vim',
  },
}