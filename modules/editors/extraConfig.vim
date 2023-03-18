set noswapfile
let mapleader = ","
syntax enable
colorscheme solarized

set tw=0 " No Auto insert newline
set number
set lazyredraw
set cursorline
set wildmenu
set visualbell
set spell spelllang=en_US
nnoremap <Tab> :bprevious<CR>
nnoremap <S-Tab> :bnext<CR>

" double line or block
nmap <C-d> yyp
vmap <C-d> ykp
imap <C-d> <ESC>yypi

set formatoptions-=tc
" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d
vnoremap <leader>p "_dP"
nnoremap <leader>vp viw"_dP"

" move line up and down
nnoremap <S-Up> ddkkp
nnoremap <S-Down> ddp

" copy to buffer
vmap <leader>fy :w! ~/.vimbuffer<CR>
nmap <leader>fy :.w! ~/.vimbuffer<CR>
" paste from buffer
nnoremap <leader>fp :r ~/.vimbuffer<CR>
map <leader>w :StripWhitespace<CR>

autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NvimTreeOpen | endif
nmap <F7> :NvimTreeToggle<CR>
