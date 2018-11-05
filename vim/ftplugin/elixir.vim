let b:ale_fixers = ['mix_format']

if isdirectory(g:plug_home . '/.elixir-ls')
  let b:ale_elixir_elixir_ls_release = g:plug_home . '/.elixir-ls'
  let b:ale_elixir_elixir_ls_config = {'elixirLS': {'dialyzerEnabled': v:false}}
endif
