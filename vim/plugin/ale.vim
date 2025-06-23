scriptencoding utf8

let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_msg_format = '[%linter%%:code%] %s'
let g:ale_completion_enabled = 1
let g:ale_virtualtext_cursor = 0

let g:ale_floating_preview=1
let g:ale_hover_to_floating_preview=1
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']
let g:ale_sign_warning = '❭'

function! s:on_lsp_started() abort
  noremap <buffer> <CR>        <Plug>(ale_detail)
  noremap <buffer> K           <Plug>(ale_hover)
  noremap <buffer> g]          <Plug>(ale_go_to_definition)
  noremap <buffer> g<C-]>      <Plug>(ale_go_to_definition)
  noremap <buffer> <C-]>       <Plug>(ale_go_to_definition)
  noremap <buffer> <C-W>]      <Plug>(ale_go_to_definition_in_vsplit)
  noremap <buffer> <C-W><C-]>  <Plug>(ale_go_to_definition_in_vsplit)
endfunction

augroup LSPStartedGroup
  autocmd!
  autocmd User ALELSPStarted call s:on_lsp_started()
augroup END
