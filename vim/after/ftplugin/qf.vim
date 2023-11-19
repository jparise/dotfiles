setlocal statusline=%1*%t\ %2*%{jon#statusline#quickfix()}%=%4l/%-4L

nmap <silent> <buffer> <Left>  <Plug>(qf_older)
nmap <silent> <buffer> <Right> <Plug>(qf_newer)
nmap <silent> <buffer> { <Plug>(qf_previous_file)
nmap <silent> <buffer> } <Plug>(qf_next_file)

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|setlocal statusline<'
let b:undo_ftplugin .= '|execute "silent! nunmap <buffer> <Left>"'
let b:undo_ftplugin .= '|execute "silent! nunmap <buffer> <Right>"'
let b:undo_ftplugin .= '|execute "silent! nunmap <buffer> {"'
let b:undo_ftplugin .= '|execute "silent! nunmap <buffer> }"'
