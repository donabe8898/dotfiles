" Save ~/.config/nvim/init.vim

"行番号を表示
set number
"タブ文字の代わりにスペースを使う
set expandtab
"プログラミング言語に合わせて適切にインデントを自動挿入
set smartindent
"各コマンドやsmartindentで挿入する空白の量
set shiftwidth=4
"Tabキーで挿入するスペースの数
set softtabstop=4
"カレントディレクトリを自動で移動
set autochdir
"バッファ内で扱う文字コード
set encoding=utf-8
"書き込む文字コード : この場合encodingと同じなので省略可
set fileencoding=utf-8
"読み込む文字コード : この場合UTF-8を試し、だめならShift_JIS
set fileencodings=utf-8,cp932
"Vimの無名レジスタとシステムのクリップボードを連携 : ダメならxclipをインストールで使えるかも
set clipboard+=unnamed,unnamedplus
"eコマンド等でTabキーを押すとパスを保管する : この場合まず最長一致文字列まで補完し、2回目以降は一つづつ試す
set wildmode=longest,full

"LeaderキーをSpaceに設定(これだけでは意味をなさない)
let mapleader = "\<Space>"

"C++,Java等のインラインブロックを中括弧付きのブロックに展開
nnoremap <C-j> ^/(<CR>%a{<CR><Esc>o}<Esc>
"カーソル上の単語を置換
nnoremap <expr> S* ':%s/\<' . expand('<cword>') . '\>/'



"下部分にターミナルウィンドウを作る
function! Myterm()
    split
    wincmd j
    resize 10
    terminal
    wincmd k
endfunction
command! Myterm call Myterm()


"上のエディタウィンドウと下のターミナルウィンドウ(ターミナル挿入モード)を行き来
tnoremap <C-t> <C-\><C-n><C-w>k
nnoremap <C-t> <C-w>ji
"ターミナル挿入モードからターミナルモードへ以降
tnoremap <Esc> <C-\><C-n>

" kokokara plugin dayo~~~


call plug#begin('~/.vim/plugged')
    Plug 'rust-lang/rust.vim'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'preservim/nerdtree'
    Plug 'cohama/lexima.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
call plug#end()


syntax enable

set number
set guifont=DroidSansMono\ Nerd\ Font\ 13
set guifontwide=DroidSansMono\ Nerd\ Font\ 13
set hlsearch
set smartindent
set laststatus=2
set wildmenu
set ruler
set history=1000
set encoding=utf8
set tabstop=4
set shiftwidth=4

:set autoindent
:set smartindent

filetype on

set mouse=a



filetype plugin indent on
nmap <C-f> :NERDTreeToggle<CR>

" 保存時に自動でrustfmt
let g:rustfmt_autosave = 1

let g:airline_powerline_fonts = 1

" tab Hokan
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
