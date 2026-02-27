-- 1. Leader Key
-- Set the leader key to <Space>.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- 2. Indentation & Tabs
vim.opt.expandtab = true      -- Convert tabs to spaces
vim.opt.tabstop = 4           -- 1 tab == 4 spaces
vim.opt.shiftwidth = 4        -- Shift 4 spaces when using '>>' or '<<'
vim.opt.smartindent = true    -- Auto-indent new lines based on C-like syntax rules

-- 3. Line Numbers & UI
vim.opt.number = true         -- Show absolute line number on the current line
vim.opt.relativenumber = true -- Show relative line numbers 
vim.opt.scrolloff = 8         -- Keep 8 lines of context above/below the cursor
vim.opt.signcolumn = "yes"    -- Always show the sign column 
vim.opt.termguicolors = true  -- Enable 24-bit RGB colors

-- 4. Search Behavior
vim.opt.ignorecase = true     -- Ignore case when searching...
vim.opt.smartcase = true      -- ...unless you type a capital letter (e.g., /Test)
vim.opt.hlsearch = false      -- Don't keep search terms highlighted forever after searching
vim.opt.incsearch = true      -- Highlight search matches as you type

-- 5. System Integration & Efficiency
vim.opt.clipboard = "unnamedplus" -- Sync Neovim's clipboard with the system clipboard
vim.opt.updatetime = 50           -- Faster completion and UI updates (default is 4000ms)








































































































































































































