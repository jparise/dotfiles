if !exists('g:loaded_fzf')
  finish
endif

" Match colors to the current colorsheme
let g:fzf_colors = {
\ 'fg':      ['fg', 'Normal'],
\ 'bg':      ['bg', 'Normal'],
\ 'hl':      ['fg', 'Comment'],
\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
\ 'hl+':     ['fg', 'Statement'],
\ 'info':    ['fg', 'PreProc'],
\ 'border':  ['fg', 'Ignore'],
\ 'prompt':  ['fg', 'Conditional'],
\ 'pointer': ['fg', 'Exception'],
\ 'marker':  ['fg', 'Keyword'],
\ 'spinner': ['fg', 'Label'],
\ 'header':  ['fg', 'Comment']
\ }

let g:fzf_layout = {'down': '~25%'}

" nnoremap <leader>f :Files<CR>
" nnoremap <leader>\ :GFiles<CR>
" nnoremap <leader>m :GFiles?<CR>
" nnoremap <leader>b :Buffers<CR>
" nnoremap <leader>h :History<CR>
" nnoremap <leader>t :Tags<CR>
