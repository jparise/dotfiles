let g:markdown_fenced_languages = [
\ 'bash=sh',
\ 'c',
\ 'console=sh',
\ 'cpp',
\ 'c++=cpp',
\ 'elixir',
\ 'elvish',
\ 'erlang',
\ 'gradle=groovy',
\ 'groovy',
\ 'html',
\ 'ini=dosini',
\ 'java',
\ 'javascript',
\ 'js=javascript',
\ 'objc',
\ 'nushell=nu',
\ 'python',
\ 'py=python',
\ 'pycon=python',
\ 'sh',
\ 'sql',
\ 'swift',
\ 'typescript',
\ 'ts=typescript',
\ 'vim',
\ 'viml=vim',
\ 'zig',
\ 'zsh',
\]

setlocal autoindent
setlocal formatoptions+=n
setlocal linebreak
setlocal spell

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|setlocal autoindent< formatoptions< linebreak< spell<'
let b:undo_ftplugin .= '|unlet g:markdown_fenced_languages'

" Preview in whichever application the system associates with Markdown.
if exists(':Open') == 2
  nmap <buffer> <leader>p <Cmd>Open %<CR>
  let b:undo_ftplugin .= '|nunmap <buffer> <leader>p'
endif
