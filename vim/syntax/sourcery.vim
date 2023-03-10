if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'sourcery'
endif

runtime! syntax/swift.vim
unlet b:current_syntax

runtime! syntax/jinja.vim
unlet b:current_syntax

let b:current_syntax = 'sourcery'

if main_syntax == 'sourcery'
  unlet main_syntax
endif
