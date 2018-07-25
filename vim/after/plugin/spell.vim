if has('syntax')
  " Automatically rebuild custom spelling dictionary binaries when saving the
  " text versions.
  augroup SpellAutocmds
    autocmd!
    autocmd BufWritePost */vim/spell/*.add silent! :mkspell! %
  augroup END
endif
