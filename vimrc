" =========================================================================== "
" 			My Custom .vimrc
" =========================================================================== "
" Created after watching PyCon 2012 Singapore
" https://www.youtube.com/watch?v=YhqsjUUHj6g

" HOW TO INSTALL VIM
"
" Prerequisites:
" (Ubuntu) sudo apt-get build-dep vim
" (OSX) Command Line Tools for Xcode
"
" $ hg clone https://vim.googlecode.com/hg/ vim
" $ cd vim/src
" $ ./configure --enable-pythoninterp --with-features=huge
" --prefix=$HOME/opt/vim
"
" $ make && make install
" $ mkdir -p $HOME/bin
" $ cd $HOME/bin
" $ ln -s $HOME/opt/vim/bin/vim
" $ which vim
" $ vim --version
"
" On Ubuntu
" $ apt-get sudo apt-get install gtk2-engines-pixbuf

" Make vim incompatbile to vi
set nocompatible

" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" Mouse and Backspace
set mouse=a		" on OSX press ALT and click
" indent  allow backspacing over autoindent
" eol     allow backspacing over line breaks (join lines)
" start   allow backspacing over the start of insert; CTRL-W and CTRL-U
"         stop once at the start of insert.
set backspace=indent,eol,start
set bs=2		" Make backspace behave like normal again

" Encoding
set encoding=utf-8

" Rebind <Leader> key
let mapleader = ","

" Bind nohl
" Removes highlight of your search
noremap	<C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>

" Bind Ctrl+<movement> keys to move around the windows,
" instead of using Ctrl+w + <movement>
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Easier moving between tabs
map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>

" Set Line numbers, lenght and colors
set number	" Show line numbers
set tw=80	" Width of document (used by gd)
set nowrap	" don't automatically wrap on load
set fo-=t	" don't automatically wrap text when typing

" Disable comment (#) when paste from clipboard
set paste
set copyindent

" Size of a hard tabstop "indent" size
"
" 2 spaces
autocmd FileType yaml setlocal ai ts=2 sw=2 et
autocmd FileType html setlocal ai ts=2 sw=2 et
autocmd FileType javascript setlocal ai ts=2 sw=2 et
autocmd FileType puppet setlocal ai ts=2 sw=2 et
autocmd FileType ruby setlocal ai ts=2 sw=2 et
autocmd FileType xml setlocal ai ts=2 sw=2 et
autocmd FileType json setlocal ai ts=2 sw=2 et
autocmd FileType sh setlocal ai ts=2 sw=2 et
autocmd FileType gitcommit setlocal ai ts=2 sw=2 et
autocmd FileType vim setlocal ai ts=2 sw=2 et

" 4 spaces
autocmd FileType python setlocal ai ts=4 sw=4 et

" cd ~/.vim/color
" wget -O wombat256mod.vim \
" http://www.vim.org/scripts/download_script.php?src_id=13400
set colorcolumn=80
highlight ColorColumn ctermbg=233
set t_Co=256
color wombat256mod

" Enable syntax highlighting
filetype off
filetype plugin indent on
syntax on

" Easier formatting of paragraphs
vmap Q gq
nmap Q gqap

" Useful settings History and undolevels
set history=1000
set undolevels=1000

" Make search case insensitive
set hlsearch
set incsearch
set ignorecase
set smartcase

" Disable stupid backup and swap files - they trigger too many events
" for file system watchers
set nobackup
set nowritebackup
set noswapfile

" Hide mode type
set noshowmode

" Setup Pathogen to manage your plugins
" Pathogen
filetype off " Pathogen needs to run before plugin indent on
call pathogen#infect()
execute pathogen#infect()
call pathogen#helptags() " generate helptags for everything in 'runtimepath'
filetype plugin indent on

" Specify a directory for plugins
call plug#begin('~/.vim/bundle')

" Shorthand notation for plugin
" -- Making Vim look Good --
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" -- Vim as a SysAdmin Programmer's text editor --
Plug 'scrooloose/nerdtree'
Plug 'vim-syntastic/syntastic'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'davidhalter/jedi-vim'
Plug 'voxpupuli/vim-puppet'
Plug 'pearofducks/ansible-vim'

" -- Git Plugins --
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Initialize plugin system
call plug#end()

" =========================================================================== "
" 			Python IDE Setup
" =========================================================================== "

" Settings for vim-airline
" cd ~/.vim/bundle
" git clone https://github.com/vim-airline/vim-airline
" set laststatus=2
if has("statusline") && !&cp
  set laststatus=2              " always show the status bar
  set statusline=%f\ %m\ %r     " filename, modified, readonly
  set statusline+=\ %l/%L[%p%%] " current line/total lines
  set statusline+=\ %v[0x%B]    " current column [hex char]
endif

let g:airline_detect_paste=0
let g:airline#extensions#tabline#enabled = 1

" Settings for vim-airline-themes
" cd ~/.vim/bundle
" git clone https://github.com/vim-airline/vim-airline-themes
let g:airline_theme='powerlineish'
let g:airline_powerline_fonts = 1

" Settings for ctrlp
" cd ~/.vim/bundle
" git clone https://github.com/ctrlpvim/ctrlp.vim.git
let g:ctrlp_max_height = 30
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=*/coverage/*

" Better navigation through omnicomplete option list
" See http://stackoverflow.com/questions/2170023/how-to-map-keys-for
set completeopt=longest,menuone
function! OmniPopup(action)
  if pumvisible()
    if a:action == 'j'
      return "\<C-N>"
    elseif a:action == 'k'
      return "\<C-P>"
    endif
  endif
  return a:action
endfunction

inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>

" Function to remove whitespace
" https://vi.stackexchange.com/questions/454/whats-the-simplest-way-to-strip-\
" trailing-whitespace-from-all-lines-in-a-file
fun! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

command! TrimWhitespace call TrimWhitespace()

" Automatically remove white spaces.
autocmd BufWritePre * :call TrimWhitespace()

" -- Python folding --
" mkdir -p ~/.vim/ftplugin
" wget -O ~/.vim/ftplugin/python_editing.vim \
" http://www.vim.org/scripts/download_script.php?src_id=5492
" Press 'f' to fold the function 'F' to fold all functions
set nofoldenable

" -- Syntastic settings --
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Python checker
let g:syntastic_python_checkers = ['isort', 'flake8', 'pylint']

" Bash checker
let g:syntastic_sh_checkers = ['shellcheck']

" -- NERDTree settings --

" Open a NERDTree automatically when vim starts up
autocmd vimenter * NERDTree | wincmd p
" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Show hidden files
let NERDTreeShowHidden=1
