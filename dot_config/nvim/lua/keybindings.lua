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
local opt = { noremap = true, silent = true, }
-- ALT+j/k 上一个下一个
map("c", "<A-j>", "<C-n>", { expr = false, silent = false })
map("c", "<A-k>", "<C-p>", { expr = false, silent = false })

map("n", "<leader>w", ":w<CR>", opt)
map("n", "<leader>wq", ":wqa!<CR>", opt)

-- fix :set wrap
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- 上下滚动浏览
map("n", "<C-j>", "5j", opt)
map("n", "<C-k>", "5k", opt)
map("v", "<C-j>", "5j", opt)
map("v", "<C-k>", "5k", opt)

-- ctrl u / ctrl + d 只移动10行，默认移动半屏
map("n", "<C-u>", "10k", opt)
map("n", "<C-d>", "10j", opt)

-- magic search
map("n", "/", "/\\v", { expr = false, silent = false })
map("v", "/", "/\\v", { expr = false, silent = false })

-- 上下移动选中文本
map("v", "J", ":move '>+1<CR>gv-gv", opt)
map("v", "K", ":move '<-2<CR>gv-gv", opt)

-- 在visual mode 里粘贴不要复制
map("v", "p", '"_dP', opt)

-- 退出
map("n", "qq", ":q!<CR>", opt)
map("n", "<leader>q", ":qa!<CR>", opt)

-- insert 模式下，跳到行首行尾
map("i", "<C-a>", "<ESC>I", opt)
map("i", "<C-e>", "<ESC>A", opt)

-- insert 模式下，创建新一行
map("i", "<S-CR>", "<Esc>o", opt)


------------------------------------------------------------------
-- windows 分屏快捷键
------------------------------------------------------------------
-- 取消 s 默认功能
map("n", "s", "", opt)
map("n", "sv", ":vsp<CR>", opt)
map("n", "sh", ":sp<CR>", opt)
-- 关闭当前
map("n", "sc", "<C-w>c", opt)
-- 关闭其他
map("n", "so", "<C-w>o", opt) -- close others
-- alt + hjkl  窗口之间跳转
map("n", "<A-h>", "<C-w>h", opt)
map("n", "<A-j>", "<C-w>j", opt)
map("n", "<A-k>", "<C-w>k", opt)
map("n", "<A-l>", "<C-w>l", opt)
-- 左右比例控制
map("n", "s,", ":vertical resize -10<CR>", opt)
map("n", "s.", ":vertical resize +10<CR>", opt)
-- 上下比例
map("n", "sj", ":resize +10<CR>", opt)
map("n", "sk", ":resize -10<CR>", opt)

-- jq json format
map("n", "<leader>jq", ":%!jq '.'<CR>", opt)

-- 插件快捷键
local pluginKeys = {}



-- lsp 回调函数快捷键设置
pluginKeys.mapLSP = function(client, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    local mapbuf = vim.keymap.set
    -- rename
    mapbuf("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", bufopts)
    -- code action
    mapbuf("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", bufopts)
    -- go xx
    mapbuf("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", bufopts)
    mapbuf("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", bufopts)
    mapbuf("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", bufopts)
    -- 接口实现
    mapbuf("n", "gi", "<cmd>Telescope lsp_implementations<CR>", bufopts)
    -- 类型定义
    mapbuf('n', '<leader>d', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opt)
    -- 查看引用
    mapbuf("n", "gr", "<cmd>Telescope lsp_references<CR>", bufopts)
    -- diagnostic
    mapbuf("n", "gp", "<cmd>Telescope diagnostics<CR>", bufopts)
    mapbuf("n", "gk", "<cmd>lua vim.diagnostic.goto_prev()<CR>", bufopts)
    mapbuf("n", "gj", "<cmd>lua vim.diagnostic.goto_next()<CR>", bufopts)
    mapbuf("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<CR>", bufopts)

    mapbuf("n", "<laeder>gi", "<cmd>Telescope lsp_incoming_calls<CR>", bufopts)
    mapbuf("n", "<leader>go", "<cmd>Telescope lsp_outgoing_calls<CR>", bufopts)
    -- 没用到
    -- mapbuf('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opt)
    -- mapbuf("n", "<leader>s", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opt)
    -- mapbuf('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opt)
    -- mapbuf('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opt)
    -- mapbuf('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opt)
end


-- nvim-cmp 自动补全
pluginKeys.cmp = function(cmp)
    local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end
    -- local has_words_before = function()
    --     local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    --     return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    -- end
    local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
    end
    return {
        -- 上一个
        ["<A-k>"] = cmp.mapping.select_prev_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        -- 下一个
        ["<A-j>"] = cmp.mapping.select_next_item(),
        -- 出现补全
        ["<A-.>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        -- 取消
        ["<A-,>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        -- 确认
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ["<CR>"] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
        }),
        -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        -- 如果窗口内容太多，可以滚动
        ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),

        -- super Tab
        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.select_next_item()
        --     elseif has_words_before() then
        --         cmp.complete()
        --     else
        --         fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
        --     end
        -- end, { "i", "s" }),
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
        -- end of super Tab
    }
end

return pluginKeys
