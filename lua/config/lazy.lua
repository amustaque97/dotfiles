-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo(
            {
                { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                { out,                            "WarningMsg" },
                { "\nPress any key to exit..." }
            },
            true,
            {}
        )
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

-- Setup lazy.nvim
require("lazy").setup(
    {
        spec = {
            -- if some code requires a module from an unloaded plugin, it will be automatically loaded.
            -- So for api plugins like devicons, we can always set lazy=true
            -- { "hedyhli/outline.nvim",        lazy = true },
            -- auto completion
            {
                "hrsh7th/nvim-cmp",
                lazy = true,
                dependencies = {
                    "hrsh7th/cmp-nvim-lsp",
                    "hrsh7th/cmp-buffer",
                    "hrsh7th/cmp-path",
                    "hrsh7th/cmp-cmdline"
                }
            },
            -- auto completion with luasnip
            {
                "L3MON4D3/LuaSnip",
                -- follow latest release.
                version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
                -- install jsregexp (optional!).
                build = "make install_jsregexp"
            },
            -- rose-pine theme
            { "rose-pine/neovim",         name = "rose-pine" },
            -- gruvbox theme
            { "ellisonleao/gruvbox.nvim", priority = 1000,   config = true, opts = ... },
            {
                "folke/trouble.nvim",
                opts = {}, -- for default options, refer to the configuration section for custom setup.
                cmd = "Trouble"
            },
            { "nvim-tree/nvim-web-devicons", lazy = true },
            { "williamboman/mason.nvim",     lazy = true },
            {
                "nvim-treesitter/nvim-treesitter",
                build = ":TSUpdate",
                config = function()
                    local configs = require("nvim-treesitter.configs")

                    configs.setup(
                        {
                            ensure_installed = {
                                "c",
                                "lua",
                                "vim",
                                "vimdoc",
                                "query",
                                "elixir",
                                "heex",
                                "javascript",
                                "html",
                                "python",
                                "go",
                                "rust",
                                "json",
                                "zig"
                            },
                            sync_install = false,
                            highlight = { enable = true },
                            indent = { enable = true },
                            -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
                            disable = function(lang, buf)
                                local max_filesize = 100 * 1024 -- 100 KB
                                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                                if ok and stats and stats.size > max_filesize then
                                    return true
                                end
                            end
                        }
                    )
                end
            },
            { "ziglang/zig.vim",      lazy = true },
            { "neovim/nvim-lspconfig" },
            { "catppuccin/nvim",      name = "catppuccin", priority = 1000 },
            {
                "maxmx03/solarized.nvim",
                lazy = false,
                priority = 1000,
                ---@type solarized.config
                opts = {},
                config = function(_, opts)
                    vim.o.termguicolors = true
                    vim.o.background = "dark"
                    require("solarized").setup(opts)
                    -- vim.cmd.colorscheme "solarized"
                end
            }
            -- {
            --     "wtfox/jellybeans.nvim",
            --     priority = 1000,
            --     config = function()
            --         require("jellybeans").setup()
            --         vim.cmd.colorscheme("jellybeans")
            --     end,
            -- }
        },
        -- Configure any other settings here. See the documentation for more details.
        -- colorscheme that will be used when installing plugins.
        -- install = { colorscheme = { "habamax" } },
        -- automatically check for plugin updates
        checker = { enabled = false }
    }
)
