" 基本設定
set mouse=a

" プラグイン ===================
call plug#begin('~/.vim/plugged')

" Fern本体
Plug 'lambdalisue/vim-fern'

" アイコン表示
Plug 'lambdalisue/vim-fern-renderer-devicons'
Plug 'ryanoasis/vim-devicons'

" Gitステータス表示
Plug 'lambdalisue/vim-fern-git-status'

" LSP
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

" 自動補完
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" おしゃれなバー
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" コメントアウト
Plug 'tpope/vim-commentary'

" カラーテーマ
Plug 'dracula/vim', { 'as': 'dracula' }

call plug#end()
" ===============================

" 自動補完設定
let g:asyncomplete_auto_popup = 1

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"


" Fernでマウス操作
augroup fern_custom
  autocmd!
  autocmd FileType fern call s:fern_init()
augroup END

function! s:fern_init() abort
  nmap <buffer> <CR> <Plug>(fern-action-open-or-expand)
  nmap <buffer> o <Plug>(fern-action-open-or-expand)
  " 分割表示
  nmap <buffer> v    <Plug>(fern-action-open:vsplit)
  nmap <buffer> s    <Plug>(fern-action-open:split)
endfunction

" Airline SETTINGS
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab

" theme
syntax enable

if has('termguicolors')
  set termguicolors
endif

colorscheme dracula

" Fernのレンダラーをdeviconsに変更
let g:fern#renderer = "devicons"



