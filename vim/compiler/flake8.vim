if exists('b:current_compiler')
  finish
endif
let b:current_compiler = 'flake8'

let s:cpo_save = &cpoptions
set cpoptions-=C

CompilerSet makeprg=flake8
CompilerSet errorformat=
      \%f:%l:%c:\ %t%n\ %m,
      \%f:%l:\ %t%n\ %m

let &cpoptions = s:cpo_save
unlet s:cpo_save
