if exists('g:grep_loaded') || &compatible
  finish
endif
let g:grep_loaded = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

if executable('rg')
  set grepprg=rg\ --vimgrep
endif

" Inspired by https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
function! s:grep(kind, ...) abort
  silent doautocmd <nomodeline> User GrepStart
  silent let lines = system(join(extend([&grepprg], a:000), ' '))
  execute a:kind.'getexpr lines'
  if a:kind ==# 'c'
    call setqflist([], 'a', {'title': ':Grep '.join(a:000, ' ')})
  else
    call setloclist(0, [], 'a', {'title': ':Lgrep '.join(a:000, ' ')})
  endif
  silent doautocmd <nomodeline> User GrepFinish
endfunction

command! -nargs=+ -complete=file -bar Grep  call s:grep('c', <q-args>)
command! -nargs=+ -complete=file -bar Lgrep call s:grep('l', <q-args>)

let &cpoptions = s:cpo_save
unlet s:cpo_save
