if has('syntax')
    " Skip capitalized words, words with at least one non-alphabetic
    " character, and the "'s" word suffix.
    syn match spellSkipWords +\<\p*[^A-Za-z \t]\p*\>\|'s+ contains=@NoSpell

    " Skip URLs.
    syn match spellSkipURLs "\w\+:\/\/[^[:space:]]\+" contains=@NoSpell
endif
