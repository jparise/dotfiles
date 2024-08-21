scriptencoding utf-8

function! jon#statusline#fileprefix() abort
  let l:filename = expand('%')
  let l:prefix = fnamemodify(l:filename, ':~:.:h')

  if l:filename ==# '' || l:prefix ==# '.'
    return ''
  endif

  return l:prefix . '/'
endfunction

function! jon#statusline#fileinfo() abort
  return (&filetype !=# '' && &filetype !=# 'qf' ? ',' . &filetype : '') .
       \ (&fileencoding !=# '' && &fileencoding !=# 'utf-8' ? ',' . &fileencoding : '') .
       \ (&spell ? ',' . &spelllang : '')
endfunction

function! jon#statusline#async_jobs() abort
  if winwidth(0) <= 60 | return '' | endif

  let l:jobs = []

  if exists('b:gutentags_files') && !empty(gutentags#inprogress())
    call add(l:jobs, gutentags#statusline())
  endif
  if get(g:, 'grepping', 0)
    call add(l:jobs, 'grep')
  endif
  if get(g:, 'ale_enabled', 0) == 1 && ale#engine#IsCheckingBuffer(bufnr('')) 
    call add(l:jobs, 'lint')
  endif

  return join(l:jobs, ',')
endfunction

function! jon#statusline#lint_warnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:warnings = l:counts.total - l:all_errors
  return l:warnings == 0 ? '' : printf('%d ⁉', l:warnings)
endfunction

function! jon#statusline#lint_errors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  return l:all_errors == 0 ? '' : printf('%d ✗', l:all_errors)
endfunction

function! jon#statusline#quickfix() abort
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

function! jon#statusline#update_colorscheme() abort
  let l:base = s:hlget('StatusLine')

  " Bold and Italic
  call s:stylize('User1', l:base, {'bold': 1})
  call s:stylize('User2', l:base, {'italic': 1})

  " Warnings and Errors
  call s:colorize('User3', l:base, 'WarningMsg')
  call s:colorize('User4', l:base, 'ErrorMsg')
endfunction

function s:hlget(name) abort
  if has('nvim')
    return nvim_get_hl(0, {'name': a:name, 'link': v:false})
  endif

  return get(hlget(a:name, v:true), 0, {})
endfunction

function s:stylize(name, base, style) abort
  let l:highlight = copy(a:base)
  if has('nvim')
    let l:highlight['cterm'] = a:style
    call extend(l:highlight, a:style)
    return nvim_set_hl(0, a:name, l:highlight)
  endif

  let l:highlight['name'] = a:name
  for l:type in ['gui', 'term', 'cterm']
    let l:item = get(l:highlight, l:type, {})
    let l:highlight[l:type] = extend(l:item, a:style)
  endfor
  return hlset([l:highlight])
endfunction

function s:colorize(name, base, group) abort
  let l:highlight = s:hlget(a:group)
  if has('nvim')
    return nvim_set_hl(0, a:name, {
          \ 'ctermfg': get(l:highlight, 'ctermfg', 'NONE'),
          \ 'ctermbg': get(a:base, 'ctermbg', 'NONE'),
          \ 'fg': get(l:highlight, 'fg', 'NONE'),
          \ 'bg': get(a:base, 'bg', 'NONE'),
          \ })
  endif

  return hlset([{
        \ 'name': a:name,
        \ 'ctermfg': get(l:highlight, 'ctermfg', 'NONE'),
        \ 'ctermbg': get(a:base, 'ctermbg', 'NONE'),
        \ 'guifg': get(l:highlight, 'guifg', 'NONE'),
        \ 'guibg': get(a:base, 'guibg', 'NONE'),
        \ }])
endfunction
