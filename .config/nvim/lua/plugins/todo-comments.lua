-- Highlight TODO, notes, etc., in comments
return {
    {
        'folke/todo-comments.nvim',
        event = 'VimEnter',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
        },
        opts = { signs = false },
        config = function()
            require('todo-comments').setup()
            local function get_project_root()
                local file_path = vim.fn.expand('%:p:h') -- Current file's directory
                local command = string.format("git -C %s rev-parse --show-toplevel", vim.fn.shellescape(file_path))
                local handle = io.popen(command)
                local result = handle and handle:read("*a") or ""
                if handle then handle:close() end
                return result:gsub("[\n\r]", "") -- Clean up the output
            end
            vim.keymap.set('n', '<leader>td', function()
                local root = get_project_root()
                if root ~= "" then
                    require('telescope').extensions['todo-comments'].todo({ cwd = root })
                else
                    print("Error: Could not determine project root. Make sure the file is in a Git repository.")
                end
            end, { silent = true, noremap = true })
        end,
    },
}
