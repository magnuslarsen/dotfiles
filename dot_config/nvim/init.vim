" Load vim stuff
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set nu
set scrolloff=5

" vim-plug
call plug#begin(stdpath('data') . '/plugged')

" GPG {de,en}crypt support
Plug 'jamessan/vim-gnupg'

" Colorscheme
Plug 'Mofiqul/dracula.nvim'

" Syntax support
Plug 'sheerun/vim-polyglot'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Treesitter support
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" File explorer
Plug 'nvim-tree/nvim-web-devicons' " optional, for file icons
Plug 'nvim-tree/nvim-tree.lua'

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

Plug 'mmarchini/bpftrace.vim'

" CoC
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-solargraph', {'do': 'yarn install --frozen-lockfile'}
Plug 'yaegassy/coc-ansible', {'do': 'yarn install --frozen-lockfile'}
Plug 'yaegassy/coc-pylsp', {'do': 'yarn install --frozen-lockfile'}
Plug 'yaegassy/coc-pydocstring', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
Plug 'iamcco/coc-diagnostic', {'do': 'yarn install --frozen-lockfile'}
Plug 'xiyaowong/coc-lightbulb-', {'do': 'yarn install --frozen-lockfile'}
Plug 'weirongxu/coc-calc', {'do': 'yarn install --frozen-lockfile'}

Plug 'lewis6991/gitsigns.nvim'
Plug 'mhinz/vim-signify'

call plug#end()

" Disable spell checking
setlocal nospell

let g:coc_filetype_map = {'yaml.ansible': 'ansible'}

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

let g:airline_theme='violet'
colorscheme dracula 

"" Keybinds
" change the leader key from "\" to " "
let mapleader=" "

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif


" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Formatting selected code.
nmap <silent>ff  <Plug>(coc-format)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>fa <Plug>(coc-codeaction)
nmap <leader>fl <Plug>(coc-codeaction-line)
xmap <leader>fl <Plug>(coc-codeaction-selected)


" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" File explorer settings
nmap <silent>fe :NvimTreeToggle<CR>

" Gitsigns config
lua << EOF
require('gitsigns').setup {
  current_line_blame = true,
  current_line_blame_formatter = '<author> - <author_time:%Y-%m-%d> - <summary>',
  current_line_blame_opts = {
    virt_text_pos = 'right_align',
  },
  signcolumn = false,
}
EOF

" Telescope settings
lua << EOF
require('telescope').setup()
require('telescope').load_extension('fzf')
EOF

nnoremap <silent>fd <cmd>Telescope find_files<cr>
nnoremap <silent>fg <cmd>Telescope live_grep<cr>

lua << EOF
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  filters = {
    dotfiles = true,
		custom = { "^.git$" }
  },
  live_filter = {
    prefix = "[FILTER]: ",
    always_show_folders = false,
  }
})
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
      vim.cmd "quit"
    end
  end
})
EOF

