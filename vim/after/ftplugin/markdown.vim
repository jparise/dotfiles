let g:markdown_fenced_languages = [
\ 'bash=sh',
\ 'c++=cpp',
\ 'elixir',
\ 'erlang',
\ 'html',
\ 'ini=dosini',
\ 'java',
\ 'python',
\ 'viml=vim',
\]

if has('syntax')
  setlocal spell
endif

" For macOS, add a markdown preview mapping.
if has('osx') && executable('open')
  nnoremap <silent> <buffer> <leader>p
  \ :silent exe '!open -a "Marked 2.app" ' . shellescape(expand('%'))<CR><C-l>
endif
