setlocal commentstring=//\ %s
setlocal shiftwidth=2

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|setlocal commentstring< shiftwidth<'
