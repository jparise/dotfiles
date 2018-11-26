scriptencoding utf-8

let g:lightline = {
\ 'colorscheme': get(g:, 'colors_name', '') ==# 'base16-ocean' ? 'base16_ocean' : 'jellybeans',
\ 'separator': {'left': "\uE0B0", 'right': "\uE0B2"},
\ 'subseparator': {'left': "\uE0B1", 'right': "\uE0B3"},
\ 'tabline_separator': {'left': ''},
\ 'tabline_subseparator': {'left': ''},
\ 'active': {
\   'left': [
\     ['mode', 'paste'],
\     ['gitbranch'],
\     ['filename', 'ctrlpmark'],
\   ],
\   'right': [
\     ['lineinfo', 'lint_warnings', 'lint_errors'],
\     ['ctrlppath', 'fileinfo', 'spell'],
\     ['gutentags', 'lint']
\   ]
\ },
\ 'inactive': {
\   'left': [
\     ['filename']
\   ],
\   'right': [
\     ['lineinfo']
\   ]
\ },
\ 'component_function': {
\   'mode': 'LightlineMode',
\   'filename': 'LightlineFilename',
\   'fileinfo': 'LightlineFileinfo',
\   'gitbranch': 'LightlineGitBranch',
\   'gutentags': 'LightlineGutentags',
\   'lint': 'LightlineLint',
\ },
\ 'component_expand': {
\   'ctrlpmark': 'LightlineCtrlPMark',
\   'ctrlppath': 'LightlineCtrlPPath',
\   'lint_warnings': 'LightlineLintWarnings',
\   'lint_errors': 'LightlineLintErrors'
\ },
\ 'component_type': {
\   'lint_warnings': 'warning',
\   'lint_errors': 'error'
\ },
\ 'mode_map':{
\   'n': 'N', 'i': 'I', 'R': 'R', 'v': 'V', 'V': 'V', "\<C-v>": 'V',
\   'c': 'C', 's': 'S', 'S': 'S', "\<C-s>": 'S', 't': 'T',
\ }
\ }

function! LightlineMode() abort
  return &filetype ==# 'ctrlp' ? "\u22EF" : lightline#mode()
endfunction

function! LightlineFilename() abort
  if &filetype ==# 'ctrlp'
    if exists('g:lightline.ctrlp_progress')
      return g:lightline.ctrlp_progress
    else
      return g:lightline.ctrlp_item
    endif
  elseif &filetype ==# 'help'
    return expand('%:t')
  endif

  let l:pathname = expand('%')
  if l:pathname ==# '' || l:pathname ==# '.'
    let l:pathname = '[No Name]'
  else
    let l:pathname = fnamemodify(l:pathname, ':~:.')
  endif

  let l:readonly = &readonly ? ' [RO]' : ''
  let l:modified = &modified ? ' [+]' : ''
  return l:pathname . l:readonly . l:modified
endfunction

function! LightlineCtrlPMark() abort
  return &filetype ==# 'ctrlp' ? g:lightline.ctrlp_marked : ''
endfunction

function! LightlineCtrlPPath() abort
  return &filetype ==# 'ctrlp' ? fnamemodify(getcwd(), ':~') : ''
endfunction

function! LightlineFileinfo() abort
  return strlen(&filetype) ? &filetype : '' .
        \ strlen(&fileencoding) && &fileencoding !=# 'utf-8' ? ',' . &fileencoding : ''
endfunction

function! LightlineGitBranch() abort
  let l:branch = FugitiveHead()
  return l:branch !=# '' ? "\uE0A0 " . l:branch : ''
endfunction

function! LightlineLint() abort
  if get(g:, 'ale_enabled', 0) != 1 || getbufvar(bufnr(''), 'ale_linted', 0) == 0
    return ''
  endif
  return ale#engine#IsCheckingBuffer(bufnr('')) ? 'lint' : ''
endfunction

function! LightlineLintWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:warnings = l:counts.total - l:all_errors
  return l:warnings == 0 ? '' : printf('%d ⁉', l:warnings)
endfunction

function! LightlineLintErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  return l:all_errors == 0 ? '' : printf('%d ✗', l:all_errors)
endfunction

function! LightlineGutentags() abort
  return exists('b:gutentags_files') ? gutentags#statusline() : ''
endfunction

" CtrlP Integration
let g:ctrlp_status_func = {
\ 'main': 'CtrlPStatusFuncMain',
\ 'prog': 'CtrlPStatusFuncProg',
\ }
function! CtrlPStatusFuncMain(focus, byfname, regex, prev, item, next, marked) abort
  unlet g:lightline.ctrlp_progress
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_marked = a:marked
  return lightline#statusline(0)
endfunction
function! CtrlPStatusFuncProg(len) abort
  let g:lightline.ctrlp_progress = a:len
  return lightline#statusline(0)
endfunction

augroup LightlineAutoCommands
  autocmd!
  autocmd User ALEJobStarted call lightline#update()
  autocmd User ALELintPost call lightline#update()
  autocmd User GutentagsUpdating call lightline#update()
  autocmd User GutentagsUpdated call lightline#update()
augroup END
