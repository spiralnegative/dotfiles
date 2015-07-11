" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Leader
let mapleader = ","

syntax on
filetype plugin on
filetype indent on
set background=dark
set number
set kp=ri sw=2 ts=2 expandtab
autocmd Filetype slim set syntax=slim
autocmd BufWrite *.rb :RuboCop -a

" Jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Automatically load NERDTree if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" load a relative .vimrc file for the current project
set exrc

" automatically load the .vimrc file whenever it is saved
au BufWritePost .vimrc so $MYVIMRC


" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set hidden		" Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes)

" Command-line completion menu
set wildmenu
set wildmode=list:longest,full

" Open vsplits and splits 
set splitright
set splitbelow

" Show line numbers
" :set number
set relativenumber

" Always show statusline
set laststatus=2

" Colors
colorscheme wolfpack
set t_Co=256

" Show trailing whitespace:
set listchars=tab:»·,trail:·
set list
hi SpecialKey ctermbg=red ctermfg=red guibg=red guifg=red
hi StatusLine ctermfg=white ctermbg=black cterm=bold
hi StatusLineNC ctermfg=white ctermbg=black cterm=NONE

" Remove trailing whitespace on save for ruby,sass,haml,coffeescript files.
au BufWritePre *.rb,*.scss,*.haml,*.coffee,*.slim :%s/\s\+$//e

" associate filetypes
au BufRead,BufNewFile *.slim setfiletype slim
au BufRead,BufNewFile *.coffee setfiletype coffee

"Use TAB to complete when typing words, else inserts TABs as usual.
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction
:inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
:set dictionary="/usr/dict/words"

" Map key to open NERDTree
nmap <c-t> :NERDTreeToggle<enter>
nmap <c-h> <c-w>h
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-l> <c-w>l

" Paste / Nopaste
map <Leader>p :set paste<CR>"+]p:set nopaste<CR>

" Copy to clipboard
map <Leader>y "+y<CR>

" Reload files
map <F7> :checktime<CR>

" No swapfile
set noswapfile
set nobackup

"if has("autocmd")
"  augroup ruby
"    au BufReadPre,FileReadPre set kp=ri sw=2 ts=2 expandtab
"  augroup END
"endif

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/vundle'

" NERDTree
Plugin 'scrooloose/nerdtree'

" Comment
Plugin 'vim-scripts/toggle_comment'

" Auto-completion for quotes, parens, brackets, etc. in insert mode.
Plugin 'Raimondi/delimitMate'

" Add 'end' in Ruby
Plugin 'tpope/vim-endwise'

" Slim
Plugin 'slim-template/vim-slim'

" Coffeescript
Plugin 'kchmck/vim-coffee-script'

" Ruby code analyzer
Plugin 'ngmy/vim-rubocop'

" All of your Plugins must be added before the following line
call vundle#end()
