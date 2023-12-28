let g:markdown_fenced_languages = [
\ 'bash=sh',
\ 'c',
\ 'cpp',
\ 'c++=cpp',
\ 'elixir',
\ 'erlang',
\ 'gradle=groovy',
\ 'groovy',
\ 'html',
\ 'ini=dosini',
\ 'java',
\ 'javascript',
\ 'js=javascript',
\ 'objc',
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
\]

setlocal linebreak
setlocal spell

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|setlocal linebreak< spell<'
let b:undo_ftplugin .= '|unlet g:markdown_fenced_languages'

" For macOS, add a markdown preview mapping.
if has('osx') && executable('open')
  command! -buffer Preview
        \ silent execute '!open -a "Marked 2.app" "' . expand('%') . '"' | redraw!
  let b:undo_ftplugin .= '|delcommand -buffer Preview'
endif
