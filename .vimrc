" Colours
syntax on
filetype indent plugin on
colorscheme wolfpack


" Searching
set hlsearch " highlight all matches
set ignorecase " ignore case when searching
set incsearch " search as characters are entered
highlight Search ctermfg=black ctermbg=magenta cterm=bold
highlight SpecialKey ctermbg=red ctermfg=red guibg=red guifg=red


" Usability
set autowrite " automatically save before commands like :next and :make
set backspace=indent,eol,start " enable backspace in insert mode
set cmdheight=2 " set the command window height to 2 lines
set colorcolumn=80,120 " line lenght markers
set cursorline " highlight current line
set dictionary="/usr/dict/words" " completion dictionary
set hidden " hide buffers when they are abandoned
set laststatus=2 " always show statusline
set list " show whitespace characters
set listchars=tab:»·,trail:· " show trailing whitespace
set mouse=a " enable mouse usage (all modes)
set nobackup " no backup files
set nopaste " use nopaste by default
set noswapfile " no swap files
set number " display line numbers on the left
set pastetoggle=<F3> " toggle between paste and nopaste
set showcmd " show (partial) command in status line
set showmatch " show matching brackets
set smartcase " do smart case matching
set splitbelow " open splits below
set splitright " open vertical splits on the right
set tabstop=2 shiftwidth=2 expandtab " use 2 spaces by default
set wildmenu " command-line completion menu
set wildmode=longest:list,full " command-line completion mode


" Folding
set foldmethod=indent " fold based on indent level
set foldenable " fold files by default
set foldnestmax=10 " max 10 depth
set foldlevelstart=10 " start with fold level of 10
" In normal mode, press Space to toggle the current fold open/closed. However, if the cursor is not in a fold, move to the right
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf


" Leader shortcuts
let mapleader = ','
vnoremap <Leader>p :set paste<CR>"+]p:set nopaste<CR>
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>s :mksession!<CR>
nnoremap <leader>a :Ag 
vnoremap <leader>y "+y<CR>


" Mappings
inoremap <Tab> <C-R>=TabOrComplete()<CR>
map <F7> :checktime<CR>
map <C-E> :%s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g<CR>
noremap <c-t> :NERDTreeTabsToggle<CR>
nnoremap <silent> <C-p> :ProjectFiles<CR>
nnoremap <F3> :Buffers<CR>
noremap <C-a> :Ag! <C-r>=expand('<cword>')<CR><CR>


" AutoGroups
augroup configgroup
  autocmd BufEnter *.coffee set syntax=coffee
  autocmd BufEnter *.py setlocal tabstop=4
  autocmd BufEnter *.slim set syntax=slim
  autocmd BufReadPost * call JumpToLastPosition()
  autocmd BufWritePost .vimrc source $MYVIMRC " automatically load the .vimrc file whenever it is saved
  autocmd BufWritePre *.rb,*.scss,*.haml,*.coffee,*.slim,*.html :%s/\s\+$//e " remove trailing whitespace on save
  autocmd FileType clojure RainbowToggleOn
  autocmd StdinReadPre * let s:std_in=1 " automatically load NERDTree if no files were specified
  autocmd VimEnter * call ShowNerdTree()
  autocmd VimEnter * wincmd p " jump to the main window so NERDTree is not focused by default
augroup END


" fzf
set rtp+=~/.fzf
let g:fzf_layout = { 'down': '~30%' }

command! ProjectFiles execute 'Files' s:find_git_root()
command! -bang -nargs=* Ag
  \ call fzf#vim#grep(
  \   'ag  --nogroup --column --color --color-line-number "15" --color-match "106" --color-path "1;15" '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)


" nerdtree
let NERDTreeShowHidden=1


" rainbow
let g:rainbow_active = 1


" tabline
highlight TabLineSel ctermfg=0 ctermbg=158 cterm=none
highlight TabLine ctermbg=237


" vim-airline
let g:airline_powerline_fonts = 1
let g:airline_theme='atomic'


" vim-emoji
set completefunc=emoji#complete


" vim-gitgutter
highlight SignColumn guibg=black ctermbg=black

highlight GitGutterAdd guifg=green ctermfg=green
highlight GitGutterChange guifg=yellow ctermfg=yellow
highlight GitGutterDelete guifg=red ctermfg=red


" Custom Functions
function! TabOrComplete() " use TAB to complete when typing words, else inserts TABs as usual
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction

function! JumpToLastPosition() " jump to last position when reopening a file
  if line("'\"") > 1 && line("'\"") <= line("$")
    exe "normal! g'\""
  endif
endfunction

function! ShowNerdTree() " automatically load NERDTree
  if argc() == 0 && !exists("s:std_in")
    NERDTree
  endif
endfunction

function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction


" Plugins
call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter' " Git diff markers
Plug 'ap/vim-css-color' " Preview colours
Plug 'carlson-erik/wolfpack' " Colorscheme
Plug 'edkolev/tmuxline.vim' " Tmux statusline generator
Plug 'godlygeek/tabular' " Text filtering and alignment
Plug 'jistr/vim-nerdtree-tabs' " Make NERDTree feel like a true panel, independent of tabs
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Command-line fuzzy finder
Plug 'junegunn/fzf.vim' " Bundle of fzf-based commands
Plug 'junegunn/vim-emoji' " Display emoji
Plug 'junegunn/vim-peekaboo' " Display the contents of the registers
Plug 'kchmck/vim-coffee-script' " CoffeeScript support
Plug 'luochen1990/rainbow' " Rainbow parentheses
Plug 'mkitt/tabline.vim' " Configure tab labels
Plug 'Raimondi/delimitMate' " Auto-completion in insert mode
Plug 'scrooloose/nerdtree' " File system explorer
Plug 'slim-template/vim-slim' " Slim syntax highlighting
Plug 'tpope/vim-endwise' " End certain structures automatically
Plug 'tpope/vim-fugitive' " Git wrapper
Plug 'tpope/vim-rails' " Editing of Ruby on Rails applications
Plug 'vim-airline/vim-airline' " Status/tabline
Plug 'vim-airline/vim-airline-themes' " Themes for vim-airline
Plug 'vim-scripts/toggle_comment' " Toggle comments for one or more lines in both normal and visual mode
call plug#end()
