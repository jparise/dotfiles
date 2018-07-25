syn match SpellSkipMultiCaps "\<\p*\u\p*\u\p*\>" contains=@NoSpell
syn match SpellSkipEmails '<\?\w\+@\w\+\.\w\+>\?' contains=@NoSpell
syn match SpellSkipURLs "https\?:\/\/[^[:space:]]\+" contains=@NoSpell
