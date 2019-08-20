syntax on
filetype plugin on
let mapleader = ","

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" NERDTree
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'

" Comment
Plug 'vim-scripts/toggle_comment'

" Auto-completion for quotes, parens, brackets, etc. in insert mode.
Plug 'Raimondi/delimitMate'

" Add 'end' in Ruby
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-rails'

" Slim
Plug 'slim-template/vim-slim'

" Coffeescript
Plug 'kchmck/vim-coffee-script'

" Ruby code analyzer
Plug 'ngmy/vim-rubocop'

" Status/tabline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Show git diff
Plug 'airblade/vim-gitgutter'

" Command-line fuzzy finder
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" Full path fuzzy search
Plug 'mkitt/tabline.vim'

" Markdown
Plug 'godlygeek/tabular'
Plug 'tpope/vim-markdown'

" Defaulth theme
Plug 'carlson-erik/wolfpack'

" tmux statusline integration
Plug 'edkolev/tmuxline.vim'

" Highlight colours
Plug 'ap/vim-css-color'

" Git wrapper
Plug 'tpope/vim-fugitive'

" See the contents of the registers
Plug 'junegunn/vim-peekaboo'

" Emoji
Plug 'junegunn/vim-emoji'

" Rubocop
Plug 'w0rp/ale'

" Better diff
Plug 'chrisbra/vim-diff-enhanced'

" Clojure REPL support
Plug 'tpope/vim-fireplace'

" Static Vim support for Leiningen and Boot
Plug 'tpope/vim-salve'

" Jenkins
Plug 'martinda/Jenkinsfile-vim-syntax'

" Initialize plugin system
call plug#end()
" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Needed for Airline status/tabline font
let g:airline_powerline_fonts = 1
let g:airline_theme='atomic'
set timeoutlen=50

filetype indent on
set background=dark
set number
scriptencoding utf-8
set encoding=utf-8

" by default, the indent is 2 spaces
set kp=ri sw=2 ts=2 expandtab
" identation for specific files
autocmd Filetype python set ts=4 expandtab
autocmd Filetype slim set syntax=slim
autocmd FileType jenkinsfile setlocal ts=4 sw=4

" Enable search highlight
set hlsearch
autocmd ColorScheme * hi Search ctermfg=black ctermbg=gray cterm=bold

" Jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Automatically load NERDTree if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Jump to the main window
autocmd VimEnter * wincmd p
" Show hidden files and folders
let NERDTreeShowHidden=1

" load a relative .vimrc file for the current project
set exrc

" automatically load the .vimrc file whenever it is saved
au BufWritePost .vimrc so $MYVIMRC

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd    " Show (partial) command in status line.
set showmatch  " Show matching brackets.
set smartcase  " Do smart case matching
set incsearch  " Incremental search
set autowrite  " Automatically save before commands like :next and :make
set hidden     " Hide buffers when they are abandoned
set mouse=a    " Enable mouse usage (all modes)

" Command-line completion menu
set wildmenu
set wildmode=list:longest,full

" Enable backspace in insert mode
set backspace=indent,eol,start

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
let g:cssColorVimDoNotMessMyUpdatetime = 1
set t_Co=256
set colorcolumn=80,120

" Show trailing whitespace:
set listchars=tab:»·,trail:·
set list
hi SpecialKey ctermbg=red ctermfg=red guibg=red guifg=red
hi StatusLine ctermfg=white ctermbg=black cterm=bold
hi StatusLineNC ctermfg=white ctermbg=black cterm=NONE

" Remove trailing whitespace on save for the following filetypes:
au BufWritePre *.rb,*.scss,*.haml,*.coffee,*.slim,*.html,*.py,*.clj :%s/\s\+$//e

" associate filetypes
au BufRead,BufNewFile *.slim setfiletype slim
au BufRead,BufNewFile *.coffee setfiletype coffee
au BufRead,BufNewFile Jenkinsfile set filetype=jenkinsfile
au BufRead,BufNewFile *.jenkinsfile set filetype=jenkinsfile

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
nmap <c-t> :NERDTreeTabsToggle<enter>
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

" Tabline
:hi TabLineSel ctermfg=0 ctermbg=158 cterm=none
:hi TabLine ctermbg=237

" FZF settings
function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles execute 'Files' s:find_git_root()

set rtp+=~/.fzf

let g:fzf_layout = { 'down': '~30%' }
nnoremap <silent> <C-p> :ProjectFiles<CR>
nnoremap <F3> :Buffers<CR>

command! -bang -nargs=* Ag
  \ call fzf#vim#grep(
  \   'ag  --nogroup --column --color --color-line-number "15" --color-match "106" --color-path "1;15" '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

noremap <C-a> :Ag! <C-r>=expand('<cword>')<CR><CR>

" Emoji completion
set completefunc=emoji#complete
map <C-E> :%s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g<CR>

" Pretty format for JSON
au FileType json setlocal equalprg=python\ -m\ json.tool

" Use rubocop-daemon instead of rubocop
call ale#Set('ruby_rubocop_executable', 'rubocop-daemon-wrapper')
