local M = {
    'neovim/nvim-lspconfig',
}
M.config = function()
    local nvim_lsp = require("lspconfig")
    local keybindings = require("keybindings").mapLSP
    local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
    nvim_lsp.gopls.setup({
        lsp_cfg = {
            capabilities = capabilities,
        },
        on_attach = require("keybindings").mapLSP,
        root_dir = function(fname)
            local lastRootPath = nil
            local gomodpath = vim.trim(vim.fn.system("go env GOPATH")) .. "/pkg/mod"
            local fullpath = vim.fn.expand(fname, ":p")
            if string.find(fullpath, gomodpath) and lastRootPath ~= nil then
                return lastRootPath
            end
            local root = nvim_lsp.util.root_pattern("go.mod", ".git")(fname)
            if root ~= nil then
                lastRootPath = root
            end
            return root
        end,
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
    nvim_lsp.lua_ls.setup {
        on_attach = keybindings,
        on_init = function(client)
            local path = client.workspace_folders[1].name
            if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you're using
                            -- (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT'
                        },
                        -- Make the server aware of Neovim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME
                                -- "${3rd}/luv/library"
                                -- "${3rd}/busted/library",
                            }
                            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                            -- library = vim.api.nvim_get_runtime_file("", true)
                        }
                    }
                })

                client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            end
            return true
        end
    }
    nvim_lsp.bashls.setup {
        on_attach = keybindings,
    }
    nvim_lsp.neocmake.setup {
        on_attach = keybindings,
    }
    nvim_lsp.dockerls.setup {
        on_attach = keybindings,
    }
    nvim_lsp.clangd.setup {
        on_attach = keybindings,
        cmd = {
            "clangd",
        }
    }
end

return M
