"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Automatic installation of vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -sS -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if empty(glob(data_dir . '/after/syntax/sh/slurm.vim'))
  silent execute '!curl -sS -fLo '.data_dir.'/after/syntax/sh/slurm.vim --create-dirs https://raw.githubusercontent.com/SchedMD/slurm/refs/heads/master/contribs/slurm_completion_help/slurm.vim'
endif

call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

Plug 'tpope/vim-sensible'
Plug 'vim-scripts/restore_view.vim'     " automatically save and restore view

" Plugin snipmate and its dependencies
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'

Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'          " show git status in nerdtree
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-rails'
Plug 'leafgarland/typescript-vim'
Plug 'jiangmiao/auto-pairs' 
Plug 'vim-scripts/a.vim'                                " Quickly switch between source files and header files
Plug 'vim-scripts/minibufexplorerpp'                    " Manage buffer
"Plug 'Valloric/YouCompleteMe'
Plug 'Valloric/ListToggle'                  " A simple vim plugin for toggling the display of the quickfix list and the location-list
Plug 'vim-scripts/DrawIt'
Plug 'tkhoa2711/vim-togglenumber'
Plug 'luochen1990/rainbow'
Plug 'tmhedberg/SimpylFold'                 " Fold python code more precise
"Plug 'winmanager'                          " Manager windows, combind NERDtree and taglist
"Plug 'terryma/vim-multiple-cursors'
"Plug 'vim-scripts/loremipsum'              " Placeholder for frontpage development
"Plug 'benmills/vimux'                       " make interacting with tmux from vim effortless
Plug 'airblade/vim-gitgutter'               " shows a git diff in the 'gutter' (sign column).

" Theme
"Plug 'altercation/vim-colors-solarized'

" plug#end() automatically executes filetype plugin indent on and syntax enable
call plug#end()
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Settings {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax on
" Make Vim more useful
set nocompatible
" Get rid of the prompt to save the current buffer when switching buffers
set hidden
" Optimize for fast terminal connections
set ttyfast
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
set history=200
" read/write a .viminfo file, don't store more
"set viminfo='20,\"50
" Enable mouse in all modes
"set mouse=a
" Disable error bells
set noerrorbells
" Use visual bell instead of beeping.
set visualbell
" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure
" Allow specified keys that move the cursor left/right to move to the previous/next line when the cursor is on the first/last character in the line.
set whichwrap =b,s,<,>,[,]
" make backspace work like most other apps
set backspace=2 "or set backspace=indent,eol,start
" Don't show the intro message when starting Vim
"set shortmess=atI
" Centralize backups, swapfiles and undo history
"set backupdir=~/.vim/backups
"set directory=~/.vim/swaps
"if exists("&undodir")
"    set undodir=~/.vim/undo
"endif
" Don't create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*
" By default, 'options' is included, which will cause error when use both
" mvim and vim, some options may not be found.
set viewoptions-=options

" set status line
set laststatus=2
set statusline=
"set statusline+=%2*%-3.3n%0*\
set statusline+=%f\
set statusline+=%h%1*%m%r%w%0*
set statusline+=[
if v:version >= 600
set statusline+=%{strlen(&ft)?&ft:'none'},
set statusline+=%{&encoding},
endif
set statusline+=%{&fileformat}]
if filereadable(expand("$VIM/vimfiles/plugin/vimbuddy.vim"))
set statusline+=\ %{VimBuddy()}
endif
set statusline+=%=
set statusline+=0x%-8B\
set statusline+=%-14.(%l,%c%V%)\ %<%P

" Don't reset cursor to start of line when moving around.
set nostartofline
" Show the (partial) command as it's being typed
set showcmd
" Show the current mode
set showmode
" Show the cursor position
set ruler
"set rulerformat=%20(%2*%<%f%=\ %m%r\ %3l\ %c\ %p%%%)
" Number of screen lines to use for the command-line.  Helps avoiding
"set cmdheight=2
" Show the filename in the window titlebar
set title

" Use UTF-8 without BOM, used inside Vim
set encoding=utf-8 nobomb
" Sets the character encoding for the file of this buffer
set fenc=utf-8
set fencs=utf-8,ucs-bom,cp936,gb18030,big5,euc-jp,euc-kr,latin1
" Set vim available to read binary file. You can also use the -b Vim argument.
"set binary
" Don't add empty newlines at the end of files
"set noeol
" When open binary files, display the values by hex
set display=uhex
" Respect modeline in files.
set modeline
set modelines=4

" Change mapleader
let mapleader=","
" Allow cursor keys in insert mode
set esckeys
" timeout for map keys
set timeoutlen=1000
" timeout for terminal, the curosr command
set ttimeoutlen=100
" Use F9 to toggle paste mode
set pastetoggle=<F9>

" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" Make search case sensitive when search content contains upper case
set smartcase
" Highlight dynamically as pattern is typed
set incsearch
" When searching by regex, add '\' except '$ . * ^'
set magic
" Add the g flag to search/replace by default
"set gdefault
" Highlight the matched brackets
set showmatch
" The time to highlight the matched brackets when insert a bracket (Unit: ms)
set matchtime=5
" Highlight setting for cursorline
hi CursorLine cterm=NONE ctermbg=darkgrey ctermfg=NONE guibg=darkgrey guifg=NONE
" Highlight current line
set cursorline

" Make tabs as wide as two spaces
set tabstop=4
" Number of spaces to use for each step of (auto)indent.  Used for |'cindent'|, |>>|, |<<|, etc.
set shiftwidth=4
" Treate space like <Tab> when BS the spaces
set softtabstop=4
" Use the appropriate number of spaces to insert a <Tab>
set expandtab
" This is a sequence of letters which describes how automatic formatting is to be done.  See |fo-table|.  When the 'paste' option is
set formatoptions=tcrqn
" Copy indent from current line when starting a new line (typing <CR> in Insert mode or when using the 'o' or 'O' command).
set autoindent
set smartindent
set cindent
" When on, lines longer than the width of the window will wrap and displaying continues on the next line.  When off lines will not wrap
"set nowrap
set wrap
" Maximum width of text that is being inserted.  A longer line will be broken after white space to get this width.  A zero value disables
set textwidth=0

" Allow backspace in insert mode
set backspace=indent,eol,start
" Start scrolling three lines before the horizontal window border
"set scrolloff=3
" Enhance command-line completion
set wildmenu
" Enable relative line numbers
set number
set relativenumber
" Highlight current line
"set cursorline
" Show invisible characters
set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_
"set list
" fold method
"set fdm=marker
set foldmethod=indent
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Strip trailing whitespace (,ss)
function! StripWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction

function! RemoveCR()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/
//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction

function! Compile()
    exec "w"
    if &filetype == "c"
        exec "!gcc -Wall % -o %< && ./%<"
    elseif &filetype == "cpp"
        exec "!g++ -Wall % -o %< && ./%<"
    endif
endfunction

function! Textwidth()
    if &textwidth == "76"
        exec "set textwidth=0"
        exec "echo 'textwidth=0'"
    else
        exec "set textwidth=76"
        exec "echo 'textwidth=76'"
    endif
endfunction

function! SetTab()
    if &filetype == "ruby" || &filetype == "eruby" || &filetype == "html"
        " Make tabs as wide as two spaces
        set tabstop=2
        " Number of spaces to use for each step of (auto)indent.  Used for |'cindent'|, |>>|, |<<|, etc.
        set shiftwidth=2
        " Treate space like <Tab> when BS the spaces
        set softtabstop=2
    else
        " Make tabs as wide as two spaces
        set tabstop=4
        " Number of spaces to use for each step of (auto)indent.  Used for |'cindent'|, |>>|, |<<|, etc.
        set shiftwidth=4
        " Treate space like <Tab> when BS the spaces
        set softtabstop=4
    endif
endfunction

func SetTitle()
    let pos=[0,0,0,0]
    if &filetype == "sh"
        let pos=[0, 4, 1, 0]
        call setline(1, "\#!/bin/sh")
        call append(line("."), "\# Author:")
        call append(line(".")+1, "")
        call append(line(".")+2, "")
    elseif &filetype == "python"
        let pos=[0, 5, 1, 0]
        call setline(1, "\#!/bin/env python")
        call append(line("."), "\#coding:utf-8")
        call append(line(".")+1, "\#Author:")
        call append(line(".")+2, "")
        call append(line(".")+3, "")
    elseif &filetype == "c"
        let pos=[0, 5, 5, 0]
        call setline(1, "\#include <stdio.h>")
        call append(line("."), "")
        call append(line(".")+1, "int main(int argc, char *argv[])")
        call append(line(".")+2, "{")
        call append(line(".")+3, "    ")
        call append(line(".")+4, "    return 0;")
        call append(line(".")+5, "}")
    elseif &filetype == "cpp"
        let pos=[0, 7, 5, 0]
        call setline(1, "\#include <iostream>")
        call append(line("."), "")
        call append(line(".")+1, "using namespace std;")
        call append(line(".")+2, "")
        call append(line(".")+3, "int main(int argc, char *argv[])")
        call append(line(".")+4, "{")
        call append(line(".")+5, "    ")
        call append(line(".")+6, "    return 0;")
        call append(line(".")+7, "}")
    endif
    call setpos(".", pos)
endfunc
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autocmd {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("autocmd")
    " Enable file type detection
    filetype on
    autocmd BufNewFile *.py,*.sh,*.c,*.cc,*.cpp exec ":call SetTitle()"
    " Set Tab format depends on file types
    autocmd BufNewFile,BufRead * exec ":call SetTab()"

    " Do not hightlight the current line when entering insert mode
    autocmd InsertEnter * se nocul
    " Do not hightlight the current line when leave the current window
    autocmd WinLeave * se nocul
    " Hightlight the current line after leaving insert mode
    autocmd InsertLeave * se cul
    " Hightlight the current line after entering a new window
    autocmd WinEnter * se cul
endif
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map {{{
" Check the key description: :h key-notation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <space> za

noremap <leader>ss :call StripWhitespace()<CR>
noremap <leader>cr :call RemoveCR()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>
" Close highlight
nnoremap <leader><CR> :nohlsearch<CR>
" Toggle MiniBufExplorer
nnoremap <leader>b :TMiniBufExplorer<CR>
" Toggle NERDTree
noremap <leader>tr :NERDTreeToggle<CR>
" Toggle tagbar
noremap <leader>tb :TagbarToggle<CR>
" Toggle set list
noremap <leader>ls <ESC>:set invlist<CR>
" Toggle textwidth
noremap <leader>tw <ESC>:call Textwidth()<CR>
noremap <leader>n :ToggleNumber<CR>
noremap <leader>r :RainbowToggle<CR>

" Move between different Tabs
"nnoremap <leader>t1 1gt
"nnoremap <leader>t2 2gt
"nnoremap <leader>t3 3gt
"nnoremap <leader>t4 4gt
"nnoremap <leader>t5 5gt
"nnoremap <leader>t6 6gt
"nnoremap <leader>t7 7gt
"nnoremap <leader>t8 8gt
"nnoremap <leader>t9 9gt

" Move between different Buffers
nnoremap <leader>1 :b1<CR>
nnoremap <leader>2 :b2<CR>
nnoremap <leader>3 :b3<CR>
nnoremap <leader>4 :b4<CR>
nnoremap <leader>5 :b5<CR>
nnoremap <leader>6 :b6<CR>
nnoremap <leader>7 :b7<CR>
nnoremap <leader>8 :b8<CR>
nnoremap <leader>9 :b9<CR>

" Move between different windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize window size
noremap + <C-w>+
noremap - <C-w>-
noremap <C-n> <C-w><
noremap <C-m> <C-w>>

"inoremap <F5> <ESC>:call Compile()<CR>
noremap <F5> <ESC>:call Compile()<CR>
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Theme {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('gui_running')
    set background=light
else
    set background=dark
endif

"colorscheme solarized

" If you use a terminal emulator with a transparent background and Solarized
" isn't displaying the background color transparently, set this to 1 and
" Solarized will use the default (transparent) background of the terminal
" emulator. urxvt required this in my testing; iTerm2 did not.
let g:solarized_termtrans=1
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------------------------------------
" tagbar settings {{{
"------------------------------------
let g:tagbar_width = 30
let g:tagbar_zoomwidth = 0
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0
let g:tagbar_previewwin_pos = 'botright'
" }}}

"------------------------------------
" syntastic settings {{{
" Checkers: shell (http://www.shellcheck.net/about.html)
"------------------------------------
set statusline+=\ \ %#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_stl_format = "[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]"
let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"
let g:syntastic_style_error_symbol = "S>"
let g:syntastic_style_warning_symbol = "S!"
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height = 5
let g:syntastic_cpp_compiler = "g++"
let g:syntastic_cpp_compiler_options = " -std=c++11 -stdlib=libc++ -Wall"
let g:syntastic_c_compiler = "gcc"
let g:syntastic_c_compiler_options = " -Wall -pedantic-errors"
" }}}

"------------------------------------
" MiniBufExplorer settings {{{
"------------------------------------
let g:miniBufExplSplitToEdge = 0
let g:miniBufExplModSelTarget = 1
let g:miniBufExplorerMoreThanOne = 3
" }}}

"------------------------------------
" Rainbow settings {{{
" highlight Parentheses
"------------------------------------
let g:rainbow_conf = {
    \   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
    \   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
    \   'operators': '_,_',
    \   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
    \   'separately': {
    \       '*': {},
    \       'tex': {
    \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
    \       },
    \       'lisp': {
    \           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
    \       },
    \       'vim': {
    \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
    \       },
    \       'html': {
    \           'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
    \       },
    \       'css': 0,
    \   }
    \}
" }}}

"------------------------------------
" nerdtree settings {{{
"------------------------------------
if has("autocmd")
    " Close nerdtree windows when all other windows are closed
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
endif
" }}}

"------------------------------------
" nerdtree-git-plugin settings {{{
" highlight Parentheses
"------------------------------------
if has("autocmd")
    " Close nerdtree windows when all other windows are closed
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
endif
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }
" }}}

"------------------------------------
" ListToggle settings {{{
"------------------------------------
let g:lt_location_list_toggle_map = '<leader>lo'
let g:lt_quickfix_list_toggle_map = '<leader>qu'
" }}}

"------------------------------------
" GitGutter settings {{{
"------------------------------------
let g:gitgutter_realtime = 1000
" }}}

" }}}

" vim:ft=vim:fdm=marker:ff=unix:nowrap:tabstop=4:shiftwidth=4:softtabstop=4:smarttab:shiftround:expandtab