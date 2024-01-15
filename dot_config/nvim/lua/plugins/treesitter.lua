return {
    "nvim-treesitter/nvim-treesitter",
    build = function()
        require("nvim-treesitter.install").update({ with_sync = false })
    end,
    lazy = false,
    config = function()
        local options = {
            ensure_installed = {
                "vim",
                "bash",
                "vimdoc",
                "go",
                "gomod",
                "gosum",
                "python",
                "lua",
                "sql",
                "yaml",
                "dockerfile",
                "vue",
                "javascript",
                "make"
            },
            auto_install = false,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = {
                enable = true,
            },
        }
        require("nvim-treesitter.configs").setup(options)
        -- 开启 Folding 模块
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        -- 默认不要折叠
        -- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
        vim.opt.foldlevel = 99
    end,
    keys = {
        { "<leader>z", '<cmd>foldclose<cr>', desc = "fold code" },
        { "Z",         '<cmd>foldopen<cr>',  desc = "unfold code" }
    }
}
