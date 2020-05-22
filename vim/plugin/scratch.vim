if exists('g:scratch_loaded') || &compatible
  finish
endif
let g:scratch_loaded = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Redirect the output of a Vim or external command into a scratch buffer
" https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
function! s:scratch(cmd, rng, start, end)
  " Close any existing scratch windows.
  for win in range(1, winnr('$'))
    if getwinvar(win, 'scratch')
      execute win . 'windo close'
    endif
  endfor
  if a:cmd =~# '^!' " external command
    let cmd = a:cmd =~# ' %'
          \ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
          \ : matchstr(a:cmd, '^!\zs.*')
    if a:rng == 0
      let output = systemlist(cmd)
    else
      let joined_lines = join(getline(a:start, a:end), '\n')
      let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
      let output = systemlist(cmd . ' <<< $' . cleaned_lines)
    endif
  else " vim command
    redir => output
    execute a:cmd
    redir END
    let output = split(output, "\n")
  endif
  vnew
  let w:scratch = 1
  setlocal buftype=nofile filetype=scratch bufhidden=wipe nobuflisted noswapfile nomodeline
  call setline(1, output)
endfunction

command! -nargs=1 -complete=command -bar -range Scratch silent call s:scratch(<q-args>, <range>, <line1>, <line2>)

let &cpoptions = s:cpo_save
unlet s:cpo_save
