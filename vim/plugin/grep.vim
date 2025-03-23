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
  let args = expandcmd(join(a:000, ' '))
  let lines = system(&grepprg . ' ' . args)
  execute a:kind . 'getexpr lines'
  if a:kind ==# 'c'
    call setqflist([], 'a', {'title': ':Grep ' . args})
  else
    call setloclist(0, [], 'a', {'title': ':Lgrep ' . args})
  endif
  silent doautocmd <nomodeline> User GrepFinish
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  call s:grep('c', <f-args>)
command! -nargs=+ -complete=file_in_path -bar Lgrep call s:grep('l', <f-args>)

let &cpoptions = s:cpo_save
unlet s:cpo_save
