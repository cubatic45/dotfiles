local M = {
    "hrsh7th/nvim-cmp",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
        "hrsh7th/cmp-nvim-lsp", -- { name = nvim_lsp }
        "hrsh7th/cmp-buffer",   -- { name = 'buffer' },
        "hrsh7th/cmp-path",     -- { name = 'path' }
        "hrsh7th/cmp-cmdline",  -- { name = 'cmdline' }
    }

}
M.config = function()
    local cmp = require("cmp")

    cmp.setup({
        preselect = cmp.PreselectMode.None,
        -- 补全源
        sources = cmp.config.sources(
            {
                -- { name = "codeium" },
                { name = "copilot",  group_index = 2 },
                { name = "nvim_lsp", group_index = 2 },
            },
            {
                { name = "buffer" },
                { name = "path" }
            }
        ),

        -- 快捷键设置
        mapping = require("keybindings").cmp(cmp),
        window = {
            documentation = cmp.config.window.bordered()
        },
        sorting = {
            priority_weight = 2,
            comparators = {
                require("copilot_cmp.comparators").prioritize,

                -- Below is the default comparitor list and order for nvim-cmp
                cmp.config.compare.offset,
                -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
                cmp.config.compare.exact,
                cmp.config.compare.score,
                cmp.config.compare.recently_used,
                cmp.config.compare.locality,
                cmp.config.compare.kind,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
            },
        },
    })


    -- / 查找模式使用 buffer 源
    cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
        },
    })

    -- : 命令行模式中使用 path 和 cmdline 源.
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
                { name = "path" },
            },
            {
                { name = "cmdline" },
            }
        ),
    })
end

return M
