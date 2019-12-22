if exists('current_compiler')
  finish
endif
let current_compiler = 'gradlew'

CompilerSet makeprg=./gradlew
CompilerSet errorformat=
      \%E[ant:scalac]\ %f:%l:\ error:\ %m,
      \%W[ant:scalac]\ %f:%l:\ warning:\ %m,
      \%E%.%#:compile%\\w%#Java%f:%l:\ error:\ %m,%-Z%p^,%-C%.%#,
      \%W%.%#:compile%\\w%#Java%f:%l:\ warning:\ %m,%-Z%p^,%-C%.%#,
      \%E%f:%l:\ error:\ %m,%-Z%p^,%-C%.%#,
      \%W%f:%l:\ warning:\ %m,%-Z%p^,%-C%.%#,
      \%E%f:\ %\\d%\\+:\ %m\ @\ line\ %l\\,\ column\ %c.,%-C%.%#,%Z%p^,
      \%E%>%f:\ %\\d%\\+:\ %m,%C\ @\ line\ %l\\,\ column\ %c.,%-C%.%#,%Z%p^,
      \%-G%.%#
