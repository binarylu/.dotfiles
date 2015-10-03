"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" For Vundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugin snipmate and its dependencies
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" For pathogen
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
execute pathogen#infect()
syntax on
filetype plugin indent on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" For General Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax on
" Make Vim more useful
set nocompatible
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
set backspace=2 "或者 set backspace=indent,eol,start
" Don’t show the intro message when starting Vim
"set shortmess=atI
" Centralize backups, swapfiles and undo history
"set backupdir=~/.vim/backups
"set directory=~/.vim/swaps
"if exists("&undodir")
"    set undodir=~/.vim/undo
"endif
" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

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

" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the (partial) command as it’s being typed
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
set binary
" Don’t add empty newlines at the end of files
set noeol
" When open binary files, display the values by hex
set display=uhex
" Respect modeline in files.
set modeline
set modelines=4

" Change mapleader
let mapleader=","
" Allow cursor keys in insert mode
set esckeys
" Use F9 to toggle paste mode
set pastetoggle=<F9>

" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
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
"set textwidth=76

" Allow backspace in insert mode
set backspace=indent,eol,start
" Start scrolling three lines before the horizontal window border
"set scrolloff=3
" Enhance command-line completion
set wildmenu
" Enable line numbers
set number
" Highlight current line
"set cursorline
" Show “invisible” characters
set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_
"set list

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Strip trailing whitespace (,ss)
function! StripWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
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
    if &filetype == "ruby"
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
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autocmd
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("autocmd")
    " Use relative line numbers
    if exists("&relativenumber")
        set relativenumber
        au BufReadPost * set relativenumber
    endif

    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif

    " Enable file type detection
    filetype on
    " Treat .json files as .js
    autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
    " Treat .md files as Markdown
    autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
    autocmd BufNewFile *.py,*.sh,*.c,*.cc,*.cpp exec ":call SetTitle()"
    " Set Tab format depends on file types
    autocmd BufNewFile,BufRead * exec ":call SetTab()"
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map
" Check the key description: :h key-notation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>
" Close highlight
nnoremap <leader><CR> :nohlsearch<CR>

" Move between different windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize window size
noremap + <C-w>+
noremap - <C-w>-
noremap <C-[> <C-w><
noremap <C-]> <C-w>>

" Toggle NERDTree
noremap <F1> :NERDTreeToggle<CR>
noremap <F2> <ESC>:call Textwidth()<CR>
"inoremap <F5> <ESC>:call Compile()<CR>
noremap <F5> <ESC>:call Compile()<CR>
noremap <F8> <ESC>:set invlist<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Theme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('gui_running')
    set background=light
else
    set background=dark
endif

"colorscheme solarized

" If you use a terminal emulator with a transparent background and Solarized
" isn’t displaying the background color transparently, set this to 1 and
" Solarized will use the default (transparent) background of the terminal
" emulator. urxvt required this in my testing; iTerm2 did not.
let g:solarized_termtrans=1
