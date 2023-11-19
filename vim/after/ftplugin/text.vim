scriptencoding utf-8

setlocal formatoptions+=tcoqnl1j

" Improved text list recognition for formatoption+=n
setlocal formatlistpat=^\\s*                    " Optional leading whitespace
setlocal formatlistpat+=[                       " Start class
setlocal formatlistpat+=\\[({]\\?               " |  Optionally match opening punctuation
setlocal formatlistpat+=\\(                     " |  Start group
setlocal formatlistpat+=[0-9]\\+                " |  |  A number
setlocal formatlistpat+=\\\|[iIvVxXlLcCdDmM]\\+ " |  |  Roman numerals
setlocal formatlistpat+=\\\|[a-zA-Z]            " |  |  A single letter
setlocal formatlistpat+=\\)                     " |  End group
setlocal formatlistpat+=[\\]:.)}                " |  Closing punctuation
setlocal formatlistpat+=]                       " End class
setlocal formatlistpat+=\\s\\+                  " One or more spaces
setlocal formatlistpat+=\\\|^\\s*[-–+o*]\\s\\+  " Or ASCII style bullet points

" Move between paragraphs, landing on text instead of blank lines.
nnoremap <buffer> <expr> { len(getline(line('.')-1)) > 0 ? '{+' : '{-'
nnoremap <buffer> <expr> } len(getline(line('.')+1)) > 0 ? '}-' : '}+'

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|setlocal formatoptions< formatlistpat<'
let b:undo_ftplugin .= '|execute "silent! nunmap <buffer> <expr> {"'
let b:undo_ftplugin .= '|execute "silent! nunmap <buffer> <expr> }"'
