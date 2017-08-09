if has('syntax')
  " Automatically rebuild custom spelling dictionary binaries when saving the
  " text versions.
  augroup SpellAutocmds
    autocmd!
    autocmd BufWritePost */vim/spell/*.add silent! :mkspell! %
  augroup END

  " Skip words containing multiple capital letters.
  syn match spellSkipMultiCaps "\<\p*\u\p*\u\p*\>" contains=@NoSpell

  " Skip words that contain at least one non-alphabetic character.
  syn match spellSkipNonWords "\<\p*\A\p*\>" contains=@NoSpell

  " Skip URLs.
  syn match spellSkipURLs "\w\+:\/\/[^[:space:]]\+" contains=@NoSpell
endif
