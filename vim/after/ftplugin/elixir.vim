let b:ale_fixers = ['mix_format']
let b:ale_linters = ['mix']

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|unlet b:ale_fixers b:ale_linters'

if exists('$LEXICAL_RELEASE') && isdirectory($LEXICAL_RELEASE)
  let b:ale_linters = add(b:ale_linters, 'lexical')
  let b:ale_elixir_lexical_release = $LEXICAL_RELEASE
  let b:undo_ftplugin .= '|unlet b:ale_elixir_lexical_release'
endif
