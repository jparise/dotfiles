let b:ale_fixers = ['mix_format']
let b:ale_linters = ['credo', 'elixir-ls', 'mix']

if isdirectory(g:plug_home . '/.elixir-ls')
  let b:ale_elixir_elixir_ls_release = g:plug_home . '/.elixir-ls'
  let b:ale_elixir_elixir_ls_config = {'elixirLS': {'dialyzerEnabled': v:false}}

  nmap K <Plug>(ale_hover)
  nmap <c-]> <Plug>(ale_go_to_definition)
endif
