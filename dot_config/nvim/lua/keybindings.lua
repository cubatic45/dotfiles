-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- leader key 为空
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 使用 lua 重新定义 vim.keymap.set
local map = vim.keymap.set
local opt = { noremap = true, silent = true }

-- Basic key mappings
map('i', 'jj', '<Esc>', opt)
map("c", "<A-j>", "<C-n>", { expr = false, silent = false })
map("c", "<A-k>", "<C-p>", { expr = false, silent = false })

map("n", "<leader>w", ":w<CR>", opt)
map("n", "<leader>wq", ":wqa!<CR>", opt)

-- Motion adjustments
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Scrolling and movement
map("n", "<C-j>", "5j", opt)
map("n", "<C-k>", "5k", opt)
map("v", "<C-j>", "5j", opt)
map("v", "<C-k>", "5k", opt)

map("n", "<C-u>", "10k", opt)
map("n", "<C-d>", "10j", opt)

-- Magic search
map("n", "/", "/\\v", { expr = false, silent = false })
map("v", "/", "/\\v", { expr = false, silent = false })

-- Move selected text up/down
map("v", "J", ":move '>+1<CR>gv-gv", opt)
map("v", "K", ":move '<-2<CR>gv-gv", opt)

-- Paste without yanking
map("v", "p", '"_dP', opt)

-- Exiting commands
map("n", "qq", ":q!<CR>", opt)
map("n", "<leader>q", ":qa!<CR>", opt)

-- Insert mode enhancements
map("i", "<C-a>", "<ESC>I", opt)
map("i", "<C-e>", "<ESC>A", opt)
map("i", "<S-CR>", "<Esc>o", opt)

------------------------------------------------------------------
-- Window management
------------------------------------------------------------------
map("n", "s", "", opt)
map("n", "sv", ":vsp<CR>", opt)
map("n", "sh", ":sp<CR>", opt)
map("n", "sc", "<C-w>c", opt)
map("n", "so", "<C-w>o", opt)

-- Window navigation
map("n", "<A-h>", "<C-w>h", opt)
map("n", "<A-j>", "<C-w>j", opt)
map("n", "<A-k>", "<C-w>k", opt)
map("n", "<A-l>", "<C-w>l", opt)

-- Resize windows
map("n", "s,", ":vertical resize -10<CR>", opt)
map("n", "s.", ":vertical resize +10<CR>", opt)
map("n", "sj", ":resize +10<CR>", opt)
map("n", "sk", ":resize -10<CR>", opt)

-- Tmux integration
map("n", "<leader>t", function() os.execute('tmux popup -d $(pwd)') end, opt)

