setlocal linebreak
setlocal spell

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|setlocal linebreak< spell<'
