let b:ale_linters = ['rubocop']
let b:ale_ruby_rubocop_executable = 'bundle'

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|unlet b:ale_linters b:ale_ruby_rubocop_executable'
