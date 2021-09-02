let g:markdown_fenced_languages = [
\ 'bash=sh',
\ 'c++=cpp',
\ 'elixir',
\ 'erlang',
\ 'gradle=groovy',
\ 'groovy',
\ 'html',
\ 'ini=dosini',
\ 'java',
\ 'python',
\ 'sh',
\ 'viml=vim',
\]

if has('linebreak')
  setlocal linebreak
endif

if has('syntax')
  setlocal spell
endif

" For macOS, add a markdown preview mapping.
if has('osx') && executable('open')
  command! -buffer Preview
        \ silent execute '!open -a "Marked 2.app" "' . expand('%') . '"' | redraw!
endif
