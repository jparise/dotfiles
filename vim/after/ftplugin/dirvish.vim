setlocal statusline=%1*%{fnamemodify(expand('%'),':~')}

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|setlocal statusline<'
