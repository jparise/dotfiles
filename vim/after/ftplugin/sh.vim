let b:ale_fixers = ['shfmt']

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|unlet b:ale_fixers'
