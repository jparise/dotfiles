let b:ale_fixers = ['mix_format']
let b:ale_linters = ['mix']

if exists('$LEXICAL_RELEASE') && isdirectory($LEXICAL_RELEASE)
  let b:ale_linters = add(b:ale_linters, 'lexical')
  let b:ale_elixir_lexical_release = $LEXICAL_RELEASE
endif
