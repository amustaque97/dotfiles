require('config.lazy')
require('config.lsp')
require('config.auto_completion')


vim.opt.list = true
vim.opt.number = true
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.numberwidth = 1
vim.opt.cursorline = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.laststatus = 2
vim.opt.colorcolumn = '80'
vim.opt.breakindent = true
vim.opt.mouse = 'a'
vim.opt.expandtab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.syntax = 'on'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.cmd.colorscheme('catppuccin-mocha')

-- chnage netwr file manager layout
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 0
vim.g.netrw_list_hide = [[^\.\.\?/$]]
vim.g.netrw_sort_sequence = [[[\/]$]]
vim.g.netrw_use_errorwindow = 0

-- custom treesitter color for code comments
vim.api.nvim_set_hl(0, "Comment", { fg = "#C0C0C0" })
vim.api.nvim_set_hl(0, "@comment", { link = "Comment" })


-- mappings
local map = vim.api.nvim_set_keymap
-- split navigation
map('n', '<C-j>', '<C-w><C-j>', {})
map('n', '<C-k>', '<C-w><C-k>', {})
map('n', '<C-l>', '<C-w><C-l>', {})
map('n', '<C-h>', '<C-w><C-h>', {})
map('n', '<leader>s=', '<C-w>=', {})

map('', '<leader>w', '<cmd>close<cr>', { silent = true })      -- close current buffer
map('', '<leader>l', '<cmd>nohlsearch<cr>', { silent = true }) -- clear highlightsearch
map('i', 'kj', '<esc>', {})                                    -- kj to exit insert mode
map('n', '<leader>sc', '<cmd>source $MYVIMRC<cr>', {})         -- source vimrc
map('n', 'e', '<cmd>:Sexplore!<cr>', {})                       -- open explore vertically on the right side of window

-- setup host python for neovim
if vim.fn.executable('python3') > 0 then
    local path = vim.fn.system('which python3')
    -- remove newline from `vim.fn.system` else provider python will fail
    local py_path = string.gsub(path, '\n', '')
    vim.g.python3_host_prog = py_path
end

-- setup mason to install linter, formatter etc.
require("mason").setup()

-- custom command to clear lsp log file
vim.api.nvim_create_user_command('LspLogClear', function()
    local log_path = vim.lsp.get_log_path()
    local f = io.open(log_path, "w")
    if f then f:close() end
    print("LSP log cleared: " .. log_path)
end, {})

-- this is required for the `docker_compose_language_service` lsp to work properly
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "docker-compose*.yaml", "docker-compose*.yml" },
    command = "set filetype=yaml.docker-compose"
})
