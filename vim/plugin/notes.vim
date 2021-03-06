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

if executable('fd')
  let s:source_cmd = 'fd -e md'
else
  let s:source_cmd = 'find . -name "*.md" 2> /dev/null | cut -c3- | sort'
endif

if executable('bat')
  let s:preview_cmd = 'bat --plain --color=always {}'
else
  let s:preview_cmd = 'cat {}'
endif

let s:create_key = 'ctrl-x'

function! s:handler(lines) abort
  if empty(a:lines) || a:lines == ['','','']
    return
  endif

  let query  = a:lines[0]
  let action = a:lines[1]

  " If the "create" key was pressed, or if no files were selected from the
  " list, create a new file named after the query string. Otherwise, open
  " all of the selected files.
  if action ==? s:create_key || len(a:lines) <= 2
    let files = [fnameescape(s:notes_dir.'/'.query.'.md')]
  else
    let files = a:lines[2:]
  endif

  let cmd = get(g:fzf_action, action, 'edit')
  for file in files
    execute cmd.' '.file
  endfor
endfunction

command! -nargs=* -bang Notes
  \ call fzf#run(fzf#wrap('Notes', {
  \   'dir':    s:notes_dir,
  \   'source': s:source_cmd,
  \   'sink*':  function('s:handler'),
  \   'options': [
  \     '--ansi', '--multi', '--exact', '--tiebreak=length,begin',
  \     '--prompt', 'Notes> ', '--info=hidden', '--print-query',
  \     '--expect', join(keys(g:fzf_action) + [s:create_key], ','),
  \     '--preview', s:preview_cmd, '--preview-window', ':75%:wrap',
  \     '--query', <q-args>]
  \ }, <bang>0))

let &cpoptions = s:cpo_save
unlet s:cpo_save
