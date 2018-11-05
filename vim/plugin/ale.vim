scriptencoding utf-8

let g:ale_sign_error = '✗'
let g:ale_sign_warning = '>>'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_msg_format = '[%linter%%:code%] %s'
let g:ale_fixers = {
\ 'elixir': ['mix_format'],
\ 'python': ['isort'],
\ }
let g:ale_linters = {
\ 'python': ['flake8']
\ }

if isdirectory(g:plug_home . '/.elixir-ls')
  let g:ale_elixir_elixir_ls_release = g:plug_home . '/.elixir-ls'
  let g:ale_elixir_elixir_ls_config = {'elixirLS': {'dialyzerEnabled': v:false}}
endif
