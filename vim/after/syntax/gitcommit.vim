" Mixed-case words (including all caps) [commit body and summary]
syn match gitcommitMixedCase  "\<\w\+\u\+\w*\>" contains=@NoSpell
syn match gitcommitMixedCaseC "\<\w\+\u\+\w*\>" contains=@NoSpell
      \ contained containedin=gitcommitSummary transparent

" Words with underscore or dot characters [commit body and summary]
syn match gitcommitUnderDots  "\<\w*[_.]\+\w*\>" contains=@NoSpell
syn match gitcommitUnderDotsC "\<\w*[_.]\+\w*\>" contains=@NoSpell
      \ contained containedin=gitcommitSummary transparent

" Words inside single quotes and backticks [commit body and summary]
syn match gitcommitQuoted "\(['`]\)\(.\{-}\)\1" contains=@NoSpell
syn match gitcommitQuotedC "\(['`]\)\(.\{-}\)\1" contains=@NoSpell
      \ contained containedin=gitcommitSummary transparent

" Email addresses and URLs [commit body only]
syn match gitcommitEmail "<\?\w\+@\w\+\.\w\+>\?" contains=@NoSpell
syn match gitcommitURL "https\?:\/\/[^[:space:])>]\+" contains=@NoSpell
hi link gitcommitEmail Label
hi link gitcommitURL Label

" JIRA-style issue references [commit body only]
syn match gitcommitIssue "\<\u\{3,}\-\(\d\|?\)\+" contains=@NoSpell
hi link gitcommitIssue Label

" Git hash references [commit body only]
syn match gitcommitHash "\<\x\{8,64}\>" contains=@NoSpell
hi link gitcommitHash Identifier
