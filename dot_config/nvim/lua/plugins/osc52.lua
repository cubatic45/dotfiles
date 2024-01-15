return {
    'ojroques/nvim-osc52',
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
