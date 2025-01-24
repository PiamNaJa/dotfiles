return {
    "nvim-telescope/telescope.nvim",
    keys = {
        {
            "<leader>fp",
            function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
            desc = "Find Plugin File",
        },
    },
    opts = {
        defaults = {
            sorting_strategy = "ascending",
            layout_strategy = "flex",
            layout_config = {
                horizontal = { preview_cutoff = 80, preview_width = 0.55 },
                vertical = { mirror = true, preview_cutoff = 25 },
                prompt_position = "top",
                width = 0.87,
                height = 0.80,
            },
        },
    },
}
