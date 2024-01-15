return {
    "ahmedkhalf/project.nvim",
    event = 'VimEnter',
    config = function()
        require("project_nvim").setup {
            exclude_dirs = { "~/go", "/opt" },
            manual_mode = true,
            patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "go.mod", "init.lua" },
            require('telescope').load_extension('projects')
        }
    end
}
