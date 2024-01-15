local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("basic")
require("keybindings")
require("lazy").setup("plugins")
vim.cmd('hi clear MiniTablineFill')
vim.cmd('hi clear MiniStatuslineFilename')

vim.cmd('hi MiniCursorwordCurrent term=underline cterm=underline gui=underline guibg=NONE')
vim.cmd('hi MiniCursorword term=underline cterm=underline gui=underline guibg=NONE')