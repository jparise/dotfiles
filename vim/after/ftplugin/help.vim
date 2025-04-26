autocmd BufWinEnter <buffer> if winwidth(0) >= 160 | wincmd L | endif
setlocal statusline=%1*%h\ %2*%t

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|setlocal statusline<'
