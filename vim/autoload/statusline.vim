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
  let l:bg = pinnacle#extract_bg('StatusLineNC')

  " Light
  execute 'highlight User1 ' .
      \ pinnacle#highlight({
      \   'bg': l:bg,
      \   'fg': pinnacle#extract_fg('StatusLine'),
      \ })

  " Light (Bold) and Dark (Italic)
  execute 'highlight User2 ' . pinnacle#embolden('User1')
  execute 'highlight User3 ' . pinnacle#italicize('StatusLineNC')

  " Warnings
  execute 'highlight User4 ' .
      \ pinnacle#highlight({
      \   'bg': l:bg,
      \   'fg': pinnacle#extract_fg('Label'),
      \ })

  " Errors
  execute 'highlight User5 ' .
      \ pinnacle#highlight({
      \   'bg': l:bg,
      \   'fg': pinnacle#extract_fg('ErrorMsg'),
      \ })
endfunction
