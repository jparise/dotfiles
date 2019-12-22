if exists('b:current_syntax')
  finish
endif

runtime! syntax/ruby.vim
unlet b:current_syntax

syn keyword brewfileKeyword brew cask cask_args mas tap

hi def link brewfileKeyword Keyword

let b:current_syntax = 'brewfile'
