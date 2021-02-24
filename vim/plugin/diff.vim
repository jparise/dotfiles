" Diff context marker actions
" Originally from https://github.com/tpope/vim-unimpaired

if exists('g:diff_loaded') || &compatible
  finish
endif
let g:diff_loaded = 1

function! s:Context(reverse) abort
  call search('^\(@@ .* @@\|[<=>|]\{7}[<=>|]\@!\)', a:reverse ? 'bW' : 'W')
endfunction

function! s:ContextMotion(reverse) abort
  if a:reverse
    -
  endif
  call search('^@@ .* @@\|^diff \|^[<=>|]\{7}[<=>|]\@!', 'bWc')
  if getline('.') =~# '^diff '
    let end = search('^diff ', 'Wn') - 1
    if end < 0
      let end = line('$')
    endif
  elseif getline('.') =~# '^@@ '
    let end = search('^@@ .* @@\|^diff ', 'Wn') - 1
    if end < 0
      let end = line('$')
    endif
  elseif getline('.') =~# '^=\{7\}'
    +
    let end = search('^>\{7}>\@!', 'Wnc')
  elseif getline('.') =~# '^[<=>|]\{7\}'
    let end = search('^[<=>|]\{7}[<=>|]\@!', 'Wn') - 1
  else
    return
  endif
  if end > line('.')
    execute 'normal! V'.(end - line('.')).'j'
  elseif end == line('.')
    normal! V
  endif
endfunction

nnoremap <silent> <Plug>diffContextPrevious :<C-U>call <SID>Context(1)<CR>
nnoremap <silent> <Plug>diffContextNext     :<C-U>call <SID>Context(0)<CR>
xnoremap <silent> <Plug>diffContextPrevious :<C-U>exe 'normal! gv'<Bar>call <SID>Context(1)<CR>
xnoremap <silent> <Plug>diffContextNext     :<C-U>exe 'normal! gv'<Bar>call <SID>Context(0)<CR>
onoremap <silent> <Plug>diffContextPrevious :<C-U>call <SID>ContextMotion(1)<CR>
onoremap <silent> <Plug>diffContextNext     :<C-U>call <SID>ContextMotion(0)<CR>
