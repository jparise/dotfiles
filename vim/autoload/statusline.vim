scriptencoding utf-8

function! statusline#fileprefix() abort
  let l:filename = expand('%')
  let l:prefix = fnamemodify(l:filename, ':~:.:h')

  if l:filename ==# '' || l:prefix ==# '.'
    return ''
  endif

  return l:prefix . '/'
endfunction

function! statusline#fileinfo() abort
  return (&filetype !=# '' && &filetype !=# 'qf' ? ',' . &filetype : '') .
       \ (&fileencoding !=# '' && &fileencoding !=# 'utf-8' ? ',' . &fileencoding : '') .
       \ (&spell ? ',' . &spelllang : '')
endfunction

function! statusline#async_jobs() abort
  if winwidth(0) <= 60 | return '' | endif

  let l:jobs = []

  if exists('b:gutentags_files') && !empty(gutentags#inprogress())
    call add(l:jobs, gutentags#statusline())
  endif
  if get(b:, 'ferret_async', 0)
    call add(l:jobs, 'search')
  endif
  if get(g:, 'ale_enabled', 0) == 1 && ale#engine#IsCheckingBuffer(bufnr('')) 
    call add(l:jobs, 'lint')
  endif
  if get(g:, 'asyncrun_status', '') ==# 'running'
    call add(l:jobs, "'" . get(g:, 'asyncrun_info') . "'")
  endif

  return join(l:jobs, ',')
endfunction

function! statusline#lint_warnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:warnings = l:counts.total - l:all_errors
  return l:warnings == 0 ? '' : printf('%d ⁉', l:warnings)
endfunction

function! statusline#lint_errors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  return l:all_errors == 0 ? '' : printf('%d ✗', l:all_errors)
endfunction

function! statusline#quickfix() abort
  " qf_isLoc is maintained by the vim-qf plugin and is a fast way to write
  " this test. Alternatively: !empty(getloclist(0))
  let GetList = get(b:, 'qf_isLoc', 0)
        \ ? function('getloclist', [0])
        \ : function('getqflist', []) 

  let l:index = GetList({'nr': 0}).nr
  let l:total = GetList({'nr': '$'}).nr
  let l:title = qf#statusline#SetStatusline()

  return printf('(%d/%d) %s', l:index, l:total, l:title)
endfunction

function! statusline#ctrlp_progress(len) abort
  return '%2*» %3*' . a:len
endfunction

function! statusline#ctrlp_main(focus, byfname, regex, prev, item, next, marked) abort
  return '%2*» ' . a:item . ' %3*' . a:byfname . '%=' . fnamemodify(getcwd(), ':~') . ' '
endfunction

function! statusline#update_colorscheme() abort
  let l:bg = s:extract_colors('StatusLineNC', 'bg')

  " Light
  execute 'highlight User1 ' . s:highlight('StatusLine', l:bg)

  " Light (Bold) and Dark (Italic)
  execute 'highlight User2 ' . s:decorate('User1', 'bold')
  execute 'highlight User3 ' . s:decorate('StatusLineNC', 'italic')

  " Warnings and Errors
  execute 'highlight User4 ' . s:highlight('Label', l:bg)
  execute 'highlight User5 ' . s:highlight('ErrorMsg', l:bg)
endfunction

function! s:extract_highlight(group) abort
  redir => l:highlight
    silent execute '0verbose silent highlight ' . a:group
  redir END

  " Traverse links back to authoritative group.
  let l:links = matchlist(l:highlight, 'links to \(\S\+\)')
  if !empty(l:links)
    return s:extract_highlight(l:links[1])
  endif

  " Extract the highlighting details (the bit after "xxx")
  let l:matches = matchlist(l:highlight, '\<xxx\>\s\+\(.*\)')
  return l:matches[1]
endfunction

function! s:extract_colors(group, type) abort
  let l:highlight = s:extract_highlight(a:group)
  let l:cterm = s:extract_color(l:highlight, 'cterm' . a:type . '=\(\w\+\)')
  let l:gui   = s:extract_color(l:highlight, 'gui' . a:type . '=\(#\w\+\)')
  return [l:gui, l:cterm]
endfunction

function! s:extract_color(highlight, pattern) abort
  let l:matches = matchlist(a:highlight, a:pattern)
  return empty(l:matches) ? 'NONE' : l:matches[1]
endfunction

function! s:highlight(group, bg) abort
  let [l:guifg, l:ctermfg] = s:extract_colors(a:group, 'fg')
  return
        \ 'guifg=' . l:guifg . ' ctermfg=' . l:ctermfg . ' ' .
        \ 'guibg=' . a:bg[0] . ' ctermbg=' . a:bg[1]
endfunction

function s:decorate(group, attr) abort
  let l:original = s:extract_highlight(a:group)

  for l:type in ['gui', 'term', 'cterm']
    let l:matches = matchlist(
      \   l:original,
      \   '^\(\%([^ ]\+ \)*\)' .
      \   '\(' . l:type . '=[^ ]\+\)' .
      \   '\(\%( [^ ]\+\)*\)$'
      \ )
    if empty(l:matches)
      " No existing match so just add a:attr to it.
      let l:original .= ' ' . l:type . '=' . a:attr
    else
      " Existing match so only add a:attr if it's not already there.
      let [l:start, l:value, l:end] = l:matches[1:3]
      if l:value !~# '.*' . a:attr . '.*'
        let l:original = l:start . l:value . ',' . a:attr . l:end
      endif
    endif
  endfor

  " Remove newlines in case this came from a narrow window with wrapped output.
  return tr(l:original, "\r\n", '  ')
endfunction
