let b:ale_fixers = ['eslint', 'prettier']
let b:ale_linters = ['eslint', 'tsserver']

setlocal shiftwidth=2

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|setlocal shiftwidth<'
let b:undo_ftplugin .= '|unlet b:ale_fixers b:ale_linters'
