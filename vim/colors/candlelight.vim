" Vim color file
"
" Name:         candlelight.vim
" Version:      1.0
" Maintainer:   Jon Parise <jon@indelible.org>

set background=dark
highlight clear
if exists('syntax_on')
    syntax reset
endif
let g:colors_name = 'candlelight'

if has('gui_running')
    highlight   Cursor          guibg=#ffffff   guifg=#000000
    highlight   Directory       guibg=#000000   guifg=#6699cc
    highlight   Error           guibg=#000000   guifg=#cc3300
    highlight   ErrorMsg        guibg=#000000   guifg=#339999 
    highlight   Folded          guibg=#000000   guifg=#339999
    highlight   LineNr          guibg=#000000   guifg=#339999
    highlight   MoreMsg         guibg=#000000   guifg=#339999
    highlight   NonText         guibg=#000000   guifg=#333333
    highlight   Normal          guibg=#000000   guifg=#b0b0b0
    highlight   Question        guibg=#101010   guifg=#c0c0c0
    highlight   SpecialKey      guibg=#000000   guifg=#339999   gui=bold
    highlight   StatusLine      guibg=#333333   guifg=#ffffff   gui=NONE
    highlight   StatusLineNC    guibg=#333333   guifg=#999999   gui=NONE
    highlight   Title           guifg=#ffffff   guibg=#000000   gui=bold
    highlight   VertSplit       guibg=#333333   guifg=#666666   gui=NONE
    highlight   Visual          guibg=#808080   guifg=#cdcdcd
    highlight   WarningMsg      guibg=#000000   guifg=#339999
    highlight   MatchParen      guibg=#000000   guifg=#b0b0b0   gui=bold

    highlight   Pmenu           guibg=DarkBlue  guifg=#b0b0b0   gui=NONE
    highlight   PmenuSel        guibg=DarkBlue  guifg=#ffffff   gui=NONE

    highlight   Comment         guibg=#000000   guifg=#777777
    highlight   Constant        guibg=#000000   guifg=#cccccc   gui=NONE
    highlight   Identifier      guibg=#000000   guifg=#ffffff
    highlight   Operator        guibg=#000000   guifg=#cccccc
    highlight   PreProc         guibg=#000000   guifg=#cccccc   gui=bold
    highlight   Special         guibg=#000000   guifg=#888888
    highlight   Statement       guibg=#000000   guifg=#cccc99   gui=bold
    highlight   ToDo            guibg=#000000   guifg=#ffcc99
    highlight   Type            guibg=#000000   guifg=#c0c0c0

    highlight   htmlLink        guibg=#000000   guifg=#669999   gui=NONE

    highlight   TabLine         guibg=DarkBlue  guifg=#b0b0b0   gui=NONE
    highlight   TabLineSel      guibg=DarkBlue  guifg=#ffffff   gui=bold
    highlight   TabLineFill     guibg=DarkBlue  guifg=#ffffff   gui=NONE
else
    highlight   Cursor          ctermbg=black   ctermfg=white
    highlight   Directory       ctermbg=black   ctermfg=white
    highlight   ErrorMsg        ctermbg=black   ctermfg=darkcyan
    highlight   LineNr          ctermbg=black   ctermfg=darkcyan
    highlight   MoreMsg         ctermbg=black   ctermfg=cyan
    highlight   NonText         ctermbg=black   ctermfg=darkgrey
    highlight   Normal          ctermbg=black   ctermfg=grey
    highlight   Question        ctermbg=black   ctermfg=grey
    highlight   Error           ctermbg=black   ctermfg=darkcyan
    highlight   SpecialKey      ctermbg=black   ctermfg=cyan
    highlight   StatusLine      ctermbg=white   ctermfg=darkgrey
    highlight   StatusLineNC    ctermbg=black   ctermfg=darkgrey
    highlight   Title           ctermbg=black   ctermfg=cyan
    highlight   Visual          ctermbg=white   ctermfg=darkgrey
    highlight   WarningMsg      ctermbg=black   ctermfg=cyan

    highlight   Comment         ctermbg=black   ctermfg=darkgrey
    highlight   Constant        ctermbg=black   ctermfg=white
    highlight   Identifier      ctermbg=black   ctermfg=grey
    highlight   Operator        ctermbg=black   ctermfg=grey
    highlight   PreProc         ctermbg=black   ctermfg=white
    highlight   Special         ctermbg=black   ctermfg=grey
    highlight   Statement       ctermbg=black   ctermfg=grey
    highlight   ToDo            ctermbg=black   ctermfg=cyan
    highlight   Type            ctermbg=black   ctermfg=white
endif
