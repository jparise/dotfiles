let g:neomake_error_sign = {'text': '✗', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '>>', 'texthl': 'NeomakeWarningSign'}

" Trigger a full mix build instead of just compiling the current file using
" elixirc. For background:
"   - https://github.com/neomake/neomake/issues/335
"   - https://github.com/neomake/neomake/pull/380
let g:neomake_elixir_mix_maker = {
      \ 'exe' : 'mix',
      \ 'args': ['compile', '--warnings-as-errors'],
      \ 'cwd': getcwd(),
      \ 'errorformat':
        \ '** %s %f:%l: %m,' .
        \ '%f:%l: warning: %m'
      \ }
let g:neomake_elixir_enabled_makers = ['mix']

" Automatically run the makers whenever a buffer is saved
if exists('g:loaded_neomake')
    autocmd! BufWritePost * Neomake
endif
