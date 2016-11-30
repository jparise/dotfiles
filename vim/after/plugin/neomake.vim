let g:neomake_error_sign = {'text': '✗', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '>>', 'texthl': 'NeomakeWarningSign'}

" Automatically run the makers whenever a buffer is saved
if exists('g:loaded_neomake')
    autocmd! BufWritePost * Neomake
endif
