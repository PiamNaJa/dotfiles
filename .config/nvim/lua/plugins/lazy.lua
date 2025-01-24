return {
    {
        "LazyVim/LazyVim",
        opts = {
			colorscheme = function()
				require("catppuccin").load()
			end,
		},
    },
    {
        import = "lazyvim.plugins.extras.lang.json"
    },
    {
        import = "lazyvim.plugins.extras.lang.typescript"
    },
}
