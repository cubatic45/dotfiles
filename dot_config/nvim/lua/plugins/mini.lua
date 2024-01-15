return {
    'echasnovski/mini.nvim',
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },
    init = function()
        require('mini.starter').setup({
            items = {
                { action = 'Telescope projects', name = 'Projects', section = 'Telescope' },
            },
            query_updaters = ""
        })
        require('mini.files').setup({
            mappings = {
                close       = 'q',
                go_in_plus  = 'l',
                go_out_plus = 'h',
                reset       = '<BS>',
                reveal_cwd  = '@',
                show_help   = 'g?',
                synchronize = '=',
                trim_left   = '<',
                trim_right  = '>',
            },
        })
        require('mini.bufremove').setup()
        require('mini.statusline').setup()
        require('mini.comment').setup()
        require('mini.indentscope').setup()
    end,
    config = function()
        require('mini.tabline').setup()

        require('mini.cursorword').setup()
    end,

    keys = {
        {
            "<leader>m",
            function()
                local minifiles = require("mini.files")
                local path = vim.api.nvim_buf_get_name(0)
                if not minifiles.close() then minifiles.open(path, true) end
            end,
            desc = "Open mini.files (directory of current file)",
        },
        {
            "<C-w>",
            function()
                require('mini.bufremove').wipeout()
            end,
            desc = "close current buffer"
        },
        { "<C-h>", '<cmd>bprevious<cr>', desc = "previous tab" },
        { "<C-l>", '<cmd>bnext<cr>',     desc = "next tab" }

    },
}
