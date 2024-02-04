return {
    "Tsuzat/NeoSolarized.nvim",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
        require("NeoSolarized").setup {
            transparent = true,
            style = "light",
        }
        vim.cmd [[ colorscheme NeoSolarized ]]
    end,
}
