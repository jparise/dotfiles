setlocal commentstring=//\ %s

let b:ale_linters = ['clang']
let b:ale_fixers = ['clang-format', 'clangtidy']

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|setlocal commentstring<'
let b:undo_ftplugin .= '|unlet b:ale_linters b:ale_fixers'
