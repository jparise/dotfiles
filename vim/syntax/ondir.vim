if exists('b:current_syntax')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case match

syn match   ondirComment  "#.*" contains=@Spell
syn keyword ondirKeyword  final contained skipwhite nextgroup=ondirKeyword
syn keyword ondirKeyword  enter leave contained skipwhite nextgroup=ondirPath
syn match   ondirPath     "[^:]\+" contained display
syn match   ondirColon    ":" contained display

syn include @ondirShell   syntax/sh.vim
syn region  ondirContent  start="^\( \{4,}\|\t\)" end="^\ze\S.*$" keepend contained contains=@ondirShell

syn region  ondirSection  start="^\(final\|enter\|leave\)" end="^\ze\S.*$" fold contains=ondirKeyword,ondirPath,ondirColon,ondirContent

hi def link ondirComment  Comment
hi def link ondirKeyword  Keyword
hi def link ondirPath     Special
hi def link ondirColon    Operator

let b:current_syntax = 'ondir'

let &cpo = s:cpo_save
unlet s:cpo_save
