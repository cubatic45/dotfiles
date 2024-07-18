require("basic")
require("keybindings")

local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Keymap setup
now(function()
    vim.keymap.set('x', 'c', '"+y')
    vim.keymap.del("n", "<C-w>d")
    vim.keymap.del("n", "<C-w><C-d>")
end)

-- Setup mini.notify
now(function()
    require('mini.notify').setup()
    vim.notify = require('mini.notify').make_notify()
end)

-- Setup NeoSolarized colorscheme
now(function()
    add({ source = 'tsuzat/NeoSolarized.nvim' })
    require("NeoSolarized").setup({
        transparent = false,
    })
    vim.cmd [[ colorscheme NeoSolarized ]]
end)

-- Setup mini.starter
now(function()
    require('mini.starter').setup({
        items = {
        },
        query_updaters = ""
    })
end)

-- Setup mini.tabline
now(function()
    require('mini.tabline').setup()
    vim.cmd('hi clear MiniTablineFill')
end)

-- Setup mini.statusline
now(function()
    require('mini.statusline').setup()
    vim.cmd('hi clear MiniStatuslineFilename')
end)

-- Setup mini.cursorword
later(function()
    require('mini.cursorword').setup()
    vim.cmd('hi MiniCursorwordCurrent term=underline cterm=underline gui=underline guibg=NONE')
    vim.cmd('hi MiniCursorword term=underline cterm=underline gui=underline guibg=NONE')
end)

-- Setup mini.pairs
later(function()
    require('mini.pairs').setup()
end)

-- Setup mini.ai
later(function()
    require('mini.ai').setup()
end)

-- Setup mini.files
later(function()
    add({ source = 'nvim-tree/nvim-web-devicons' })
    require('nvim-web-devicons').setup()
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

    vim.keymap.set('n', '<leader>m', function()
        local minifiles = require("mini.files")
        local path = vim.api.nvim_buf_get_name(0)
        if not minifiles.close() then minifiles.open(path, true) end
    end)

    vim.keymap.set('n', '<C-w>', function()
        require('mini.bufremove').wipeout()
    end)
    vim.keymap.set('n', '<C-h>', '<cmd>bprevious<cr>')
    vim.keymap.set('n', '<C-l>', '<cmd>bnext<cr>')
end)


-- Setup mini.git
later(function()
    require('mini.git').setup()
end)

-- Setup vgit.nvim
later(function()
    add({ source = 'tanvirtin/vgit.nvim', depends = { 'nvim-lua/plenary.nvim' } })
    require('vgit').setup({
        keymaps = {
            ['n <leader>k'] = function() require('vgit').hunk_up() end,
            ['n <leader>j'] = function() require('vgit').hunk_down() end,
            ['n <leader>gs'] = function() require('vgit').buffer_hunk_stage() end,
            ['n <leader>gr'] = function() require('vgit').buffer_hunk_reset() end,
            ['n <leader>gp'] = function() require('vgit').buffer_hunk_preview() end,

            ['n <leader>gb'] = function() require('vgit').buffer_blame_preview() end,
            ['n <leader>gf'] = function() require('vgit').buffer_diff_preview() end,
            ['n <leader>gh'] = function() require('vgit').buffer_history_preview() end,
            ['n <leader>gu'] = function() require('vgit').buffer_reset() end,
            ['n <leader>gg'] = function() require('vgit').buffer_gutter_blame_preview() end,
            ['n <leader>glu'] = function() require('vgit').buffer_hunks_preview() end,
            ['n <leader>gls'] = function() require('vgit').project_hunks_staged_preview() end,
            ['n <leader>gd'] = function() require('vgit').project_diff_preview() end,
            ['n <leader>gq'] = function() require('vgit').project_hunks_qf() end,
            ['n <leader>gx'] = function() require('vgit').toggle_diff_preference() end,
        },
    })
end)

-- Setup LSP configuration
function go_org_imports(wait_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for cid, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
            end
        end
    end
end

now(function()
    add({ source = 'neovim/nvim-lspconfig', depends = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim' } })
    require('mason').setup()
    require('mason-lspconfig').setup({
        automatic_installation = true
    })

    require("lspconfig").gopls.setup({
        settings = {
            gopls = {
                gofumpt = true,
                analyses = {
                    unusedparams = true,
                },
                usePlaceholders = true,
                staticcheck = true,
            }
        }
    })

    -- Diagnostic keymaps
    vim.keymap.set('n', 'gk', vim.diagnostic.goto_prev)
    vim.keymap.set('n', 'gj', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

    -- LSP buffer local mappings
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
            local opts = { buffer = ev.buf }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'gh', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<leader>d', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<leader>f', function()
                go_org_imports(500)
                vim.lsp.buf.format { async = true }
            end, opts)
        end,
    })
end)

-- Setup nvim-treesitter
later(function()
    add({
        source = 'nvim-treesitter/nvim-treesitter',
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    })

    require('nvim-treesitter.configs').setup({
        ensure_installed = {
            "vim", "bash", "vimdoc", "go", "gomod", "gosum", "python", "lua", "sql",
            "yaml", "dockerfile", "vue", "javascript", "make"
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
        }
    })

    -- Enable folding module
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldlevel = 99 -- Default to unfolded

    vim.keymap.set('n', '<leader>z', '<cmd>foldclose<cr>')
    vim.keymap.set('n', 'Z', '<cmd>foldopen<cr>')
end)

-- Setup symbols-outline
later(function()
    add({ source = 'simrat39/symbols-outline.nvim' })
    require("symbols-outline").setup()
    vim.keymap.set('n', '<leader>s', '<cmd>SymbolsOutline<cr>')
end)

-- Setup supermaven
later(function()
    add({
        source = 'supermaven-inc/supermaven-nvim',
        depends = { 'nvim-lua/plenary.nvim', "hrsh7th/nvim-cmp" }
    })
    require("supermaven-nvim").setup({
        disable_keymaps = true,
        ignore_filetypes = { json = true, yaml = true, toml = true },
    })
end)

-- Setup nvim-cmp
later(function()
    add({
        source = 'hrsh7th/nvim-cmp',
        depends = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        }
    })
    local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end
    local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
    end

    local cmp = require("cmp")

    cmp.setup({
        preselect = cmp.PreselectMode.None,
        sources = {
            { name = "supermaven" },
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" }
        },
        mapping = {
            -- 上一个
            ["<A-k>"] = cmp.mapping.select_prev_item(),
            -- 下一个
            ["<A-j>"] = cmp.mapping.select_next_item(),
            -- 出现补全
            ["<A-l>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            -- 取消
            ["<A-h>"] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            -- 确认
            ["<CR>"] = cmp.mapping.confirm({
                select = true,
                behavior = cmp.ConfirmBehavior.Replace,
            }),
            -- 如果窗口内容太多，可以滚动
            ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
            ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),

            ["<Tab>"] = vim.schedule_wrap(function(fallback)
                if cmp.visible() and has_words_before() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end),
            ["<S-Tab>"] = cmp.mapping(function()
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                    feedkey("<Plug>(vsnip-jump-prev)", "")
                end
            end, { "i", "s" }),
        },
        window = {
            documentation = cmp.config.window.bordered(),
        }
    })

    -- / search mode uses buffer source
    cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
        },
    })

    -- : command line mode uses path and cmdline sources
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
end)

-- Setup telescope
later(function()
    add({
        source = "nvim-telescope/telescope.nvim",
        depends = { "nvim-lua/plenary.nvim" }
    })

    require('telescope').setup({
        defaults = {
            initial_mode = "insert",
            mappings = {
                i = {
                    ["<A-j>"] = "move_selection_next",
                    ["<A-k>"] = "move_selection_previous",
                    ["<C-n>"] = "move_selection_next",
                    ["<C-p>"] = "move_selection_previous",
                    ["<Down>"] = "cycle_history_next",
                    ["<Up>"] = "cycle_history_prev",
                    ["<esc>"] = "close",
                    ["<C-c>"] = "close",
                    ["<C-u>"] = "preview_scrolling_up",
                    ["<C-d>"] = "preview_scrolling_down",
                },
            }
        }
    })

    vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files<cr>')
    vim.keymap.set('n', '<C-f>', '<cmd>Telescope live_grep<cr>')
    vim.keymap.set('n', '<C-s>', '<cmd>Telescope oldfiles<cr>')
end)

-- Setup dap
later(function()
    add({
        source = 'rcarriga/nvim-dap-ui',
        depends = { "leoluz/nvim-dap-go", 'mfussenegger/nvim-dap', "nvim-neotest/nvim-nio" }
    })
    require('dapui').setup(
        {
            layouts = { {
                elements = { {
                    id = "scopes",
                    size = 0.25
                }, {
                    id = "breakpoints",
                    size = 0.25
                }, {
                    id = "stacks",
                    size = 0.25
                }, {
                    id = "watches",
                    size = 0.25
                } },
                position = "left",
                size = 40
            }, {
                elements = { {
                    id = "repl",
                    size = 1
                }, },
                position = "bottom",
                size = 10
            } },
        }

    )
    require('dap-go').setup()
    vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
    vim.keymap.set('n', '<Leader>du', function() require('dapui').toggle() end)
end)
