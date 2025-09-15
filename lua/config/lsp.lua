local lspconfig = require('lspconfig')

-- list of language servers
local servers = { 'zls', 'lua_ls', 'pyright', 'gopls', 'bashls', 'clangd', 'dockerls', 'docker_compose_language_service',
    'ts_ls', 'yamlls' }

-- @param bufnr number: active buffer
-- @return nil: this function doesn't return any value
---@diagnostic disable-next-line: unused-function
local function setup_outline(bufnr, opts)
    -- setup outline for lsp document symbol
    require("outline").setup({})

    -- setup keymap for outline
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>o", "<cmd>Outline<CR>", opts)
end

local function on_attach(client, bufnr)
    local opts = { noremap = true, silent = true }

    -- speical settings for lua language server
    if client.name == "lua_ls" then
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
                return
            end
        end
        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            -- Make the server aware of Neovim runtime files
            workspace = {
                userThirdParty = { os.getenv("HOME") .. ".local/share/LuaAddons" },
                checkThirdParty = "Apply",
                library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths
                    -- here.
                    -- '${3rd}/luv/library'
                    -- '${3rd}/busted/library'
                }
            }
        })
    end


    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "v", "caa", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gO", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>s", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "single" })<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "single" })<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "f", '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", '<leader>o', '<cmd>Trouble symbols toggle focus=false<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

    -- setup lsp code formatting if LSP server supports formatting
    -- this will create a group `LspFormat`
    -- `vim.lsp.buf.format` only work if `documentFormattingProvider` is true
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormat", { clear = true }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ async = true })
            end
        })
    end

    -- setup document symbol outline to the right of the screen
    -- this is an alternate to default `vim.lsp.buf.document_symbol` function
    -- this is more intiuative and shown on the right side of the window.
    -- setup_outline(bufnr, opts)
end

-- iterate over the list of servers and acll setup for each one
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        flags = {
            debounce_text_changes = 150,
        },
        settings = {
            Lua = {
            },
        },
    }
end
