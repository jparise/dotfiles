let b:ale_fixers = ['zigfmt']
let b:ale_linters = ['zls']
let b:ale_fix_on_save = 1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|unlet b:ale_fixers b:ale_linters b:ale_fix_on_save'
