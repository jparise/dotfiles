" If we find a local copy of the Elixir source code, use it for symbol lookups.
if isdirectory($HOME."/Code/elixir")
    let g:alchemist#elixir_erlang_src = $HOME."/Code"
endif
