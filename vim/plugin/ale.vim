scriptencoding utf8

let g:ale_lint_on_enter = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_msg_format = '[%linter%%:code%] %s'
let g:ale_completion_enabled = 1

let g:ale_floating_preview=1
let g:ale_hover_to_floating_preview=1
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']

function! s:on_lsp_started() abort
  nmap <buffer> <CR>  <Plug>(ale_detail)
  nmap <buffer> K     <Plug>(ale_hover)
  nmap <buffer> <c-]> <Plug>(ale_go_to_definition)
endfunction

augroup LSPStartedGroup
  autocmd!
  autocmd User ALELSPStarted call s:on_lsp_started()
augroup END
