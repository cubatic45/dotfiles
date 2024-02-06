return {
    'ojroques/nvim-osc52',

    config = function()
        require('osc52').setup {
            tmux_passthrough = true,
        }
    end,
    keys = {
        {
            "c",
            mode = "x",
            function()
                require('osc52').copy_visual()
            end,
            desc = "copy text"
        }
    }
}
