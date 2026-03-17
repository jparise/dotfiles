scriptencoding utf-8

if exists('b:current_syntax')
  finish
endif

" Graph prefix
syn match gitlogMain /^● /
syn match gitlogBranch /^├ /

" Commit line components matched independently by pattern.
" Format: PREFIX DATE HASH [REFS] SUBJECT (AUTHOR)
syn match gitlogDate /\d\{4}-\d\{2}-\d\{2}/
syn match gitlogHash /\<[a-f0-9]\{7,}\>/ nextgroup=gitlogRefs skipwhite
syn match gitlogAuthor /([^()]*)$/
syn match gitlogRefs /([^()#!]\+)/ contained contains=gitlogRefHead,gitlogRefHeadArrow,gitlogRefTag

" Ref sub-groups
syn match gitlogRefHead /\<HEAD\>/ contained
syn match gitlogRefHeadArrow / -> / contained
syn match gitlogRefTag /tag: [^ ,)]\+/ contained
hi def link gitlogMain Special
hi def link gitlogBranch Comment
hi def link gitlogDate Number
hi def link gitlogHash Identifier
hi def link gitlogRefs Title
hi def link gitlogAuthor String
hi def link gitlogRefHead Keyword
hi def link gitlogRefHeadArrow Comment
hi def link gitlogRefTag gitlogRefs

let b:current_syntax = 'gitlog'
