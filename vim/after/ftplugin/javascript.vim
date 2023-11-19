let b:ale_fixers = ['prettier_eslint']
let b:ale_linters = ['eslint']

setlocal shiftwidth=2

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|setlocal shiftwidth<'
let b:undo_ftplugin .= '|unlet b:ale_fixers b:ale_linters'
