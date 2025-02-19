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

now(function()
    -- utf8
    vim.g.encoding = "UTF-8"
    vim.o.fileencoding = 'utf-8'
    -- jkhl 移动时光标周围保留8行
    vim.o.scrolloff = 8
    vim.o.sidescrolloff = 8
    -- 使用相对行号
    vim.wo.number = true
    vim.wo.relativenumber = true
    -- 高亮所在行
    vim.wo.cursorline = true
    -- 显示左侧图标指示列
    vim.wo.signcolumn = "yes"
    -- 右侧参考线，超过表示代码太长了，考虑换行
    -- vim.wo.colorcolumn = "80"
    -- 缩进4个空格等于一个Tab
    vim.o.tabstop = 4
    vim.bo.tabstop = 4
    vim.o.softtabstop = 4
    vim.o.shiftround = true
    -- >> << 时移动长度
    vim.o.shiftwidth = 4
    vim.bo.shiftwidth = 4
    -- 空格替代tab
    vim.o.expandtab = true
    vim.bo.expandtab = true
    -- 新行对齐当前行
    vim.o.autoindent = true
    vim.bo.autoindent = true
    vim.o.smartindent = true
    -- 搜索大小写不敏感，除非包含大写
    vim.o.ignorecase = true
    vim.o.smartcase = true
    -- 搜索不要高亮
    vim.o.hlsearch = false
    -- 边输入边搜索
    vim.o.incsearch = true
    -- 命令行高为2，提供足够的显示空间
    vim.o.cmdheight = 2
    -- 当文件被外部程序修改时，自动加载
    vim.o.autoread = true
    vim.bo.autoread = true
    -- 禁止折行
    vim.wo.wrap = false
    -- 光标在行首尾时<Left><Right>可以跳到下一行
    vim.o.whichwrap = '<,>,[,]'
    -- 允许隐藏被修改过的buffer
    vim.o.hidden = true
    -- 鼠标支持
    vim.o.mouse = "a"
    -- 禁止创建备份文件
    vim.o.backup = false
    vim.o.writebackup = false
    vim.o.swapfile = false
    -- smaller updatetime
    vim.o.updatetime = 300
    -- 设置 timeoutlen 为等待键盘快捷键连击时间500毫秒，可根据需要设置
    vim.o.timeoutlen = 500
    -- split window 从下边和右边出现
    vim.o.splitbelow = true
    vim.o.splitright = true
    -- 自动补全不自动选中
    vim.g.completeopt = "menu,menuone,noselect,noinsert"
    -- 样式
    vim.o.background = "light"
    vim.o.termguicolors = true
    vim.opt.termguicolors = true
    -- 不可见字符的显示，这里只把空格显示为一个点
    -- vim.o.list = true
    -- vim.o.listchars = "space:·"
    -- 补全增强
    vim.o.wildmenu = true
    -- Dont' pass messages to |ins-completin menu|
    vim.o.shortmess = vim.o.shortmess .. 'c'
    -- 补全最多显示10行
    vim.o.pumheight = 10
    -- 永远显示 tabline
    vim.o.showtabline = 2
    -- 使用增强状态栏插件后不再需要 vim 的模式提示
    vim.o.showmode = false
    vim.o.cmdheight = 0
end)

-- Keymap setup
now(function()
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "


    -- 使用 lua 重新定义 vim.keymap.set
    local set = vim.keymap.set
    local opt = { noremap = true, silent = true }

    set('x', 'c', '"+y')
    vim.keymap.del("n", "<C-w>d")
    vim.keymap.del("n", "<C-w><C-d>")

    -- Basic key mappings
    set('i', 'jj', '<Esc>', opt)
    set("c", "<A-j>", "<C-n>", { expr = false, silent = false })
    set("c", "<A-k>", "<C-p>", { expr = false, silent = false })

    set("n", "<leader>w", ":w<CR>", opt)
    set("n", "<leader>wq", ":wqa!<CR>", opt)

    -- Motion adjustments
    set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
    set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

    -- Scrolling and movement
    set("n", "<C-j>", "5j", opt)
    set("n", "<C-k>", "5k", opt)
    set("v", "<C-j>", "5j", opt)
    set("v", "<C-k>", "5k", opt)

    set("n", "<C-u>", "10k", opt)
    set("n", "<C-d>", "10j", opt)

    -- Magic search
    set("n", "/", "/\\v", { expr = false, silent = false })
    set("v", "/", "/\\v", { expr = false, silent = false })

    -- Move selected text up/down
    set("v", "J", ":move '>+1<CR>gv-gv", opt)
    set("v", "K", ":move '<-2<CR>gv-gv", opt)

    -- Paste without yanking
    set("v", "p", '"_dP', opt)

    -- Exiting commands
    set("n", "qq", ":q!<CR>", opt)
    set("n", "<leader>q", ":qa!<CR>", opt)

    -- Insert mode enhancements
    set("i", "<C-a>", "<ESC>I", opt)
    set("i", "<C-e>", "<ESC>A", opt)
    set("i", "<S-CR>", "<Esc>o", opt)

    ------------------------------------------------------------------
    -- Window management
    ------------------------------------------------------------------
    set("n", "s", "", opt)
    set("n", "sv", ":vsp<CR>", opt)
    set("n", "sh", ":sp<CR>", opt)
    set("n", "sc", "<C-w>c", opt)
    set("n", "so", "<C-w>o", opt)

    -- Window navigation
    set("n", "<A-h>", "<C-w>h", opt)
    set("n", "<A-j>", "<C-w>j", opt)
    set("n", "<A-k>", "<C-w>k", opt)
    set("n", "<A-l>", "<C-w>l", opt)

    -- Resize windows
    set("n", "s,", ":vertical resize -10<CR>", opt)
    set("n", "s.", ":vertical resize +10<CR>", opt)
    set("n", "sj", ":resize +10<CR>", opt)
    set("n", "sk", ":resize -10<CR>", opt)

    -- Tmux integration
    set("n", "<leader>t", function() os.execute('tmux popup -d $(pwd)') end, opt)
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
    vim.o.background = "light"
    vim.o.termguicolors = true
    vim.opt.termguicolors = true
    vim.cmd('colorscheme NeoSolarized')
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

-- Setup indentscope
later(function()
    require('mini.indentscope').setup()
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
local function go_org_imports(wait_ms)
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
    require 'lspconfig'.harper_ls.setup {
        settings = {
            ["harper-ls"] = {
                userDictPath = "~/config/harper/dict.txt",
                linters = {
                    sentence_capitalization = false,
                },
                codeActions = {
                    forceStable = true
                }
            }
        },
    }
    require 'lspconfig'.bashls.setup {}
    require 'lspconfig'.docker_compose_language_service.setup {}
    require 'lspconfig'.dockerls.setup {}
    require 'lspconfig'.marksman.setup {}
    require 'lspconfig'.lua_ls.setup {
        on_init = function(client)
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                    return
                end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    version = 'LuaJIT'
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME
                    }
                    -- library = vim.api.nvim_get_runtime_file("", true)
                }
            })
        end,
        settings = {
            Lua = {}
        }
    }

    require("lspconfig").clangd.setup({})
    require("lspconfig").gopls.setup({
        settings = {
            gopls = {
                gofumpt = true,
                analyses = {
                    unusedparams = true,
                },
                usePlaceholders = true,
                staticcheck = true,
            },
            hints = {
                rangeVariableTypes = true,
                parameterNames = true,
                constantValues = true,
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                functionTypeParameters = true,
            },
        }
    })

    -- Diagnostic keymaps
    vim.keymap.set('n', 'gk', vim.diagnostic.goto_prev)
    vim.keymap.set('n', 'gj', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

    vim.keymap.set('n', '<leader>f', function()
        -- 如果当前文件是go文件，则组织导入
        if vim.bo.filetype == "go" then
            go_org_imports(500)
        end
        -- json 则调用 jq 格式化
        if vim.bo.filetype == "json" then
            vim.cmd("%!jq .")
            return
        end
        -- 其他文件则尝试调用 lsp 格式化
        if vim.lsp.get_clients() ~= nil then
            vim.lsp.buf.format { async = true }
        end
    end)

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

-- Setup nvim-cmp
later(function()
    add({
        source = 'hrsh7th/nvim-cmp',
        depends = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            'zbirenbaum/copilot.lua',
            'zbirenbaum/copilot-cmp',
        }
    })
    local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end
    local has_words_before = function()
        if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then return false end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
    end

    local cmp = require("cmp")

    cmp.setup({
        preselect = cmp.PreselectMode.None,
        sources = {
            { name = "copilot", group_index = 2 },
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
            -- ["<A-l>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            -- 取消
            ["<A-h>"] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            -- 确认
            ["<CR>"] = cmp.mapping.confirm({
                select = false,
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

-- Setup codecompanion
later(function()
    add({
        source = 'olimorris/codecompanion.nvim',
        depends = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "hrsh7th/nvim-cmp",
            "nvim-telescope/telescope.nvim",
        }
    })
    require("codecompanion").setup({
        opts = {
            log_level = "TRACE",
        },
        strategies = {
            chat = {
                adapter = "ollama",
            },
            inline = {
                adapter = "ollama",
            },
            agent = {
                adapter = "ollama",
            },
        },
        adapters = {
            ollama = function()
                return require("codecompanion.adapters").extend("openai", {
                    url = "https://models.inference.ai.azure.com/chat/completions",
                    env = {
                        -- url = "https://models.inference.ai.azure.com",
                        api_key = "",
                    },
                })
            end,
        },
    })
end)

-- Setup copilot
later(function()
    add({
        source = 'zbirenbaum/copilot.lua',
        depends = {
        }
    })
    require('copilot').setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
            lua = false,
            go = true,
        },
    })
end)

-- Setup copilot-cmp
later(function()
    add({
        source = 'zbirenbaum/copilot-cmp',
        depends = {
            'zbirenbaum/copilot.lua'
        }
    })
    require('copilot_cmp').setup({
    })
end)

-- Setup Glow
later(function()
    add({
        source = 'ellisonleao/glow.nvim',
    })
    require('glow').setup({
    })
end)
