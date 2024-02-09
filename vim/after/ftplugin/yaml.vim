let b:ale_linters = ['yamllint']

if expand('%:p:h') =~# '.github/workflows$'
  call add(b:ale_linters, 'actionlint')
end

setlocal shiftwidth=2

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|setlocal shiftwidth<'
