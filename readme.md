# Neovim Configuration Guide for Windows



## Table of Contents

1. [Overview](#overview)

2. [General Settings](#general-settings)

3. [Key Features](#key-features)

4. [Complete Keymap Reference](#complete-keymap-reference)

5. [Plugin Categories](#plugin-categories)

6. [Language Support](#language-support)

7. [Quick Start Guide](#quick-start-guide)



---



## Overview



Modern Neovim setup for Windows focused on LaTeX writing, Python development, and general text editing with:



- **Plugin Manager**: Lazy.nvim with lazy loading

- **Theme**: OneDark (warmer variant)

- **Leader Key**: `;` (semicolon)

- **Primary Use Cases**: LaTeX documents, Python code, academic writing



**Key Integrations:**

- SumatraPDF for LaTeX preview

- GitHub Copilot for AI assistance

- FZF for file searching

- LSP for intelligent editing



---



## General Settings



```lua

vim.g.mapleader = ";"                    -- Leader key

vim.opt.number = true                    -- Show line numbers

vim.opt.relativenumber = true            -- Relative line numbers

vim.opt.cursorline = true               -- Highlight current line

vim.opt.clipboard = "unnamedplus"       -- System clipboard

vim.opt.ignorecase = true               -- Case-insensitive search

vim.opt.smartcase = true                -- Smart case when uppercase present

vim.opt.spell = false                   -- Spell check (Italian dictionary)

vim.opt.spelllang = 'it'

```



**Cursor Styles:**

- Normal/Visual: Thin vertical bar

- Insert: Thick vertical bar  

- Replace: Horizontal bar



---



## Key Features



### Dashboard (Alpha.nvim)

Custom ASCII art with quick actions:

- `f` - Find files in University folder

- `r` - Recent files

- `e` - New file

- `c` - Open config

- `u` - Update plugins

- `q` - Quit



### Smart Tab Behavior

Tab key intelligently handles:

1. UltiSnips expansion/navigation

2. GitHub Copilot suggestions

3. Completion menu navigation

4. Regular tab functionality



### Auto-save for LaTeX

LaTeX files auto-save every 3 seconds and compile automatically.



### Code Folding

Uses Treesitter and indentation for intelligent folding.



---



## Complete Keymap Reference



### Dashboard Actions

| Key | Action | Description |

|-----|--------|-------------|

| `f` | Find Files | FZF in University folder |

| `r` | Recent Files | File history |

| `e` | New File | Create new buffer |

| `c` | Config | Open init.lua |

| `u` | Update | Sync plugins |

| `q` | Quit | Exit Neovim |



### Navigation & Windows

| Key | Mode | Action | Description |

|-----|------|--------|-------------|

| `<Tab>` | Normal | Window Navigation | Focus next window |

| `<S-Tab>` | Normal | Window Navigation | Focus previous window |

| `<C-n>` | Normal | File Tree | Toggle nvim-tree |

| `<C-k>` | Normal | Outline | Toggle document outline |



### Clipboard Operations

| Key | Mode | Action | Description |

|-----|------|--------|-------------|

| `<C-v>` | Insert | Paste | From system clipboard |

| `<C-c>` | Visual | Copy | To system clipboard |

| `<C-x>` | Visual | Cut | To system clipboard |



### Text Editing (Visual Mode)

| Key | Mode | Action | Description |

|-----|------|--------|-------------|

| `<Tab>` | Visual | Indent | Keep selection |

| `<S-Tab>` | Visual | Unindent | Keep selection |

| `'` | Visual | Wrap Quotes | Single quotes |

| `"` | Visual | Wrap Quotes | Double quotes |

| `$` | Visual | Math Mode | LaTeX dollar signs |



### LaTeX Specific

| Key | Mode | Action | Description |

|-----|------|--------|-------------|

| `<M-b>` | Visual | Bold | `textbf{}` |

| `<M-i>` | Visual | Italic | `textit{}` |

| `<C-o>` | Normal | Compile | VimTeX compile |

| `<C-l>` | Insert | Spell Fix | Auto-correct word |



### Code Execution

| Key | Mode | Action | Description |

|-----|------|--------|-------------|

| `<F5>` | Normal | Run Python | Execute in split |

| `<S-F5>` | Normal | Run Manim | Render animation |



### Code Folding

| Key | Mode | Action | Description |

|-----|------|--------|-------------|

| `zR` | Normal | Open All | All folds |

| `zM` | Normal | Close All | All folds |

| `za` | Normal | Toggle | Fold at cursor |

| `zo` | Normal | Open | Fold at cursor |

| `zc` | Normal | Close | Fold at cursor |



### Completion & Snippets

| Key | Mode | Action | Description |

|-----|------|--------|-------------|

| `<Tab>` | Insert | Smart Tab | Snippet/Copilot/Complete |

| `<S-Tab>` | Insert | Previous | Snippet/Completion |

| `<CR>` | Insert | Confirm | Completion (no auto-select) |



---



## Plugin Categories



### UI & Appearance

- **alpha-nvim**: Custom dashboard with ASCII art

- **onedark.nvim**: Theme (warmer variant)

- **lualine.nvim**: Status line with git/LSP info

- **indent-blankline.nvim**: Rainbow indent guides



### File Management

- **nvim-tree.lua**: File explorer (Ctrl-N)

- **fzf + fzf.vim**: Fuzzy finder

- **outline.nvim**: Document structure (Ctrl-K)



### Code Editing

- **nvim-treesitter**: Syntax highlighting

- **nvim-autopairs**: Auto-close brackets/quotes

- **nvim-ufo**: Intelligent code folding

- **copilot.vim**: AI code suggestions



### Completion System

- **nvim-cmp**: Completion engine

- **UltiSnips**: Snippet system

- Sources: LSP, buffer, path, cmdline



---



## Language Support



### LaTeX (VimTeX + Texlab LSP)

**Setup Requirements:**

- LaTeX distribution (TeX Live/MiKTeX)

- SumatraPDF viewer

- Texlab LSP: `cargo install texlab`



**Features:**

- Auto-save and compile

- PDF preview with SyncTeX

- Math delimiter highlighting

- Forward/inverse search



### Python (Pyright LSP + Black)

**Setup Requirements:**

- Python 3.x

- Pyright: `npm install -g pyright`

- Black: `pip install black`



**Features:**

- Type checking and completion

- Auto-formatting on save

- F5 execution in split

- DAP debugging support



### Additional Languages

- **JavaScript/HTML/CSS**: Basic support

- **Lua**: For Neovim config editing



---



## Quick Start Guide



### First Launch

1. Open Neovim → Dashboard appears

2. Press `f` to find files or `e` for new file

3. Use `Ctrl-N` for file tree, `Ctrl-K` for outline



### LaTeX Workflow

1. Create `.tex` file

2. Write content (auto-saves every 3s)

3. View PDF in SumatraPDF

4. Use `Alt-B`/`Alt-I` for formatting

5. `$` to wrap math expressions



### Python Development

1. Create `.py` file

2. Write code with LSP assistance

3. Black formats automatically on save

4. Press `F5` to run in split terminal



### General Editing

1. Smart Tab handles snippets/Copilot/completion

2. Visual mode: select text, then `Tab`/quotes/formatting

3. `Ctrl-C`/`Ctrl-V` for system clipboard

4. Window navigation with `Tab`/`Shift-Tab`



### Plugin Management

- `:Lazy` - Manage plugins

- `:Lazy sync` - Update all plugins

- `:checkhealth` - Diagnostic information



### Customization

Edit configuration at: `C:/Users/Lorenzo/AppData/Local/nvim/init.lua`



**Common Modifications:**

- Change leader key: `vim.g.mapleader`

- Add keymaps in key mappings section

- Modify colors in highlights section

- Add plugins in Lazy.nvim setup

