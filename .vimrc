" Jon Parise <jon@indelible.org>
version 7.0

set autoindent          " turn autoindenting on
set autowrite           " auto-save before running external commands
set nobackup            " turn backups off
set backspace=indent,eol,start " smarter backspace
set nocompatible        " turn off full vi compatibility
set cmdwinheight=3      " height of the command window
set completeopt=menu,longest,preview " insert mode completion options
set cpoptions=aABceF    " vi compatibility options
set directory=/tmp      " swap directory
set encoding=utf-8      " change the default text encoding
set esckeys             " allows cursor keys in insert mode
set noerrorbells        " turn off error bells
set esckeys             " allows cursor keys in insert mode
set expandtab           " expand tabs to spaces
set formatoptions=cqrt  " options for "text format" ("gp")
set helpheight=0        " disable help
set hidden              " enable hidden buffers
set history=100         " remember the last 100 lines of command-line history
set nohlsearch          " turn off search result highlighting
set ignorecase          " mostly ignore case in search patterns. see smartcase
set incsearch           " use incremental search
set noinsertmode        " don't start vim in insertmode
set joinspaces          " insert two spaces after period when joining lines
set laststatus=2        " always show status line
set nolist              " turn off extended character listing
set listchars=tab:��,trail:� " extended character representations
set magic               " use extended regexp in search patterns
set modeline            " turn on the modeline
set modelines=5         " last line is the modeline
set mouse=h             " mouse options
set mousefocus          " use the mouse to set the window focus
set mousehide           " hide the mouse in the gui
set nonumber            " don't number lines
set report=0            " show all changes
set noruler             " don't show cursor position
set scrolloff=3         " scroll when within 3 lines of the screen's edge
set shell=tcsh          " set the shell
set shiftround          " round indent size to a multiple of shiftwidth
set shiftwidth=4        " number of spaces in each indent
set shortmess=atI       " abbreviate all messages
set noshowcmd           " don't show incomplete commands
set showmode            " show the current mode
set showtabline=1       " show tabline as needed
set smartcase           " respect uppercase characters when searching
set smartindent         " smart indenting when starting a new line
set smarttab            " smart movement and deleting based on tab settings
set softtabstop=4       " set soft tab stop to four spaces
set nostartofline       " don't jump to first char with page commands
set tabstop=4           " set tabs to eight spaces
set textwidth=78        " set the maximum text width
set notitle             " turn off the titlebar
set t_vb=               " turn off terminal's visual bell
set visualbell          " turn on the visual bell
set wildchar=<TAB>      " character used for command line expansion
set wildmenu            " use menu when in 'full' command-line completion mode
set wildmode=list:longest,full " completion mode behavior
set wrapmargin=0        " wrap from the right margin
set nowritebackup       " don't write backups

" Store marks, registers, and buffers in $TEMP/viminfo
set viminfo='20,\"50,%,h,n~/.viminfo

" Ignore filenames with these suffixes
set suffixes=.bak,~
set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.lib,*.swp,*.jpg,*.png,*.gif,*.pyc,*.pyo

let mapleader = ","

" Enable syntax highlighting and filetype-based syntax and indentation rules.
syntax on
filetype on
filetype plugin on
filetype indent on

if &diff
    syntax off " only highlight the diff output itself
endif

let g:zenburn_high_Contrast = 1
colorscheme mustang

"--[ System Options ]-----------------------------------------------------------

if has('gui_running')
    set guioptions=aAeimgr
    set lines=60
    set ruler
    set title

    if has('gui_win32')
        "set guifont=Lucida_Console:h10
        "set guifont=Andale_Mono:h10
        set guifont=Consolas:h10.5
    end

    if has('gui_macvim')
        "set guifont=Menlo Regular:h11
        "set guifont=Inconsolata:h14
        set guifont=Monaco:h12
    end
end

if has('win32')
    set shell=cmd.exe
endif

"--[ Key Mappings ]-------------------------------------------------------------

" Fix the backspace key on some terminals
"imap <Del> <BS>
"map  <Del> <BS>
"fixdel

" Buffer management
map  <Right> :bnext<CR>
imap <Right> <ESC>:bnext<CR>
map  <Left>  :bprev<CR>
imap <Left>  <ESC>:bprev<CR>
map  <Del>   :bd<CR>

" Ctrl-Space for omnicomplete
inoremap <C-space> <C-x><C-o>

" Reformat the current paragraph to textwidth
imap <C-J> <c-o>gqap
map  <C-J> gqap

" Shift-tab to insert a hard tab
imap <silent> <S-tab> <C-v><tab>

" Run the current make program 
nmap <F7> :make<CR>

"--[ AutoCommands ]------------------------------------------------------------

if has("autocmd")
    " Restore cursor position from this file's last edit
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \ execute("normal`\"") |
        \ endif

    augroup C
        au!
        au FileType c,cpp   set formatoptions=croql
        au FileType c,cpp   set cindent
        au FileType c,cpp   set cinoptions=t0(0
    augroup END

    augroup Python
        au!
        au FileType python  set nosmartindent autoindent expandtab
        au FileType python  set omnifunc=pythoncomplete#Complete
        au FileType python  set completeopt-=preview
    augroup END

    augroup reStructuredText
        au! FileType rst	set makeprg=python\ rst2html.py\ %\ output.html
    augroup END

    augroup Web
        au!
        au Filetype css,html,htmldjango,xhtml  set noet tw=0 wm=0
    augroup END

    augroup Mail
        au!
        au BufRead  mutt*,SLRN*   set laststatus=1 tw=70
        au BufRead  mutt*,SLRN*   normal :g/^> -- *$/,/^$/-1d
    augroup END

    augroup CVS
        au!
        au BufRead  cvs*    set laststatus=1 tw=78 
    augroup END

    augroup Git
        au!
        au BufRead .git/COMMIT_EDITMSG normal 1G
    augroup END
endif