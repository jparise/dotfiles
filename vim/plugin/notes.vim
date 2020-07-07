if exists('g:notes_loaded') || &compatible
  finish
endif
let g:notes_loaded = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

let s:notes_dir = '~/Notes'
if !isdirectory(expand(s:notes_dir))
  finish
endif

if executable('bat')
  let s:preview_cmd = 'bat --plain --color=always {}'
else
  let s:preview_cmd = 'cat {}'
endif

function! s:handler(lines) abort
  if empty(a:lines) || a:lines == ['','','']
    return
  endif

  let query  = a:lines[0]
  let action = a:lines[1]

  " Open the files that were selected from the list. Otherwise, create a new
  " Markdown file in the notes directory named after the query string.
  if len(a:lines) > 2
    let files = a:lines[2:]
  else
    let files = [fnameescape(s:notes_dir.'/'.query.'.md')]
  endif

  let cmd = get(g:fzf_action, action, 'edit')
  for file in files
    execute cmd.' '.file
  endfor
endfunction

command! -nargs=* -bang Notes
  \ call fzf#run(fzf#wrap('Notes', {
  \   'dir':    s:notes_dir,
  \   'sink*':  function('s:handler'),
  \   'options': [
  \     '--ansi', '--multi', '--exact', '--tiebreak=length,begin',
  \     '--prompt', 'Notes> ', '--info=hidden', '--print-query',
  \     '--query', <q-args>, '--expect', join(keys(g:fzf_action), ','),
  \     '--preview', s:preview_cmd, '--preview-window', ':75%:wrap']
  \ }, <bang>0))

let &cpoptions = s:cpo_save
unlet s:cpo_save
