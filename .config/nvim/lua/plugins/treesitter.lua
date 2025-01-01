return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            ensure_installed = { "lua", "vim", "vimdoc", "markdown", "markdown_inline", "javascript", "typescript", "json", "html", "css", "scss", "yaml", "jsonc", "json", "bash", "java", "go", "tsx", "kotlin", },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
