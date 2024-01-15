local M = {
    "nvim-telescope/telescope.nvim",
    dependencies = { 'nvim-lua/plenary.nvim' }
}

M.config = function()
    local status, telescope = pcall(require, "telescope")
    if not status then
        vim.notify("没有找到 telescope")
        return
    end

    telescope.setup({
        defaults = {
            -- 打开弹窗后进入的初始模式，默认为 insert，也可以是 normal
            initial_mode = "insert",
            -- 窗口内快捷键
            mappings = {
                i = {
                    -- 上下移动
                    ["<A-j>"] = "move_selection_next",
                    ["<A-k>"] = "move_selection_previous",
                    ["<C-n>"] = "move_selection_next",
                    ["<C-p>"] = "move_selection_previous",
                    -- 历史记录
                    ["<Down>"] = "cycle_history_next",
                    ["<Up>"] = "cycle_history_prev",
                    -- 关闭窗口
                    ["<esc>"] = "close",
                    ["<C-c>"] = "close",
                    -- 预览窗口上下滚动
                    ["<C-u>"] = "preview_scrolling_up",
                    ["<C-d>"] = "preview_scrolling_down",
                },
            }
        },
        pickers = {
            -- 内置 pickers 配置
            find_files = {
                -- 查找文件换皮肤，支持的参数有： dropdown, cursor, ivy
                -- theme = "dropdown",
            }
        },
        extensions = {
            -- 扩展插件配置
        },
    })
end

M.keys = {
    {
        "<C-p>",
        function()
            require('telescope.builtin').find_files()
        end,
        desc = "Lists files in your current working directory, respects .gitignore",

    },
    {
        "<C-f>",
        function()
            require('telescope.builtin').live_grep()
        end,
        desc =
        "Search for a string in your current working directory and get results live as you type, respects .gitignore."
    },
    {
        "<C-s>",
        function()
            require('telescope.builtin').oldfiles()
        end,
        desc = "Lists previously open files"
    }
}

return M
