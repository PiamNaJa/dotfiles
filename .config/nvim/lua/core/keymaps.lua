-- Neotree
vim.keymap.set("n", "<D-b>", ":Neotree filesystem reveal left<CR>", {})

-- Telescope
local teleBuiltin = require("telescope.builtin")
vim.keymap.set("n", "<D-p>", teleBuiltin.find_files, {})
vim.keymap.set("n", "<leader>fg", teleBuiltin.live_grep, {})

-- LSP
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
vim.keymap.set({ "n", "v", "i" }, "<D-F>", vim.lsp.buf.format, {})
vim.keymap.set({ "n", "v" }, "<leader>rn", vim.lsp.buf.rename, {})
