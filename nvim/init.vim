set number
set relativenumber
syntax on
let mapleader = ";"


" vim-plug config
call plug#begin()
" color scheme
Plug 'tjdevries/colorbuddy.vim'
Plug 'tjdevries/gruvbuddy.nvim'

" telescope - fuzzy search (files, string etc)
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" treesitter - syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" auto complete
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" For luasnip users.
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" color hightlighter
Plug 'norcalli/nvim-colorizer.lua'

" install web devicons
Plug 'kyazdani42/nvim-web-devicons'

" Java lsp
Plug 'mfussenegger/nvim-jdtls'

" PHP lsp
" Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}
" Neovim formatter
Plug 'sbdchd/neoformat'
call plug#end()

lua vim.lsp.set_log_level("debug")

" And then somewhere in your vimrc, to set the colorscheme
lua require('colorbuddy').colorscheme('gruvbuddy')
" Custom config
lua require('config')
" syntax highlight config
lua require('treesitter')
" lspconfig setup
lua require('lspconfig-config')
lua require('lspconfig-java-config')

runtime! keymap.vim

" run formatter on save
" there was some error during undojoin
" found a potential fix here
" https://github.com/sbdchd/neoformat/issues/134#issuecomment-347180213
augroup fmt
  autocmd!
  au BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
augroup END
