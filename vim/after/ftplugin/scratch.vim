setlocal statusline=%4*[Scratch]
setlocal statusline+=%=
setlocal statusline+=%1*%4l:%-3v

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|setlocal statusline<'
