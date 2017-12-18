scriptencoding utf-8

let g:lightline = {
\ 'colorscheme': 'base16_ocean',
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
\     ['ctrlppath', 'fileinfo', 'spell']
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
\ 'tabline': {'left': [['buffers']], 'right': [['bufnum']]},
\ 'component_function': {
\   'mode': 'LightlineMode',
\   'filename': 'LightlineFilename',
\   'fileinfo': 'LightlineFileinfo',
\   'gitbranch': 'LightlineGitBranch'
\ },
\ 'component_expand': {
\   'buffers': 'lightline#bufferline#buffers',
\   'ctrlpmark': 'LightlineCtrlPMark',
\   'ctrlppath': 'LightlineCtrlPPath',
\   'lint_warnings': 'LightlineLintWarnings',
\   'lint_errors': 'LightlineLintErrors'
\ },
\ 'component_type': {
\   'buffers': 'tabsel',
\   'lint_warnings': 'warning',
\   'lint_errors': 'error'
\ },
\ 'mode_map':{
\   'n': 'N', 'i': 'I', 'R': 'R', 'v': 'V', 'V': 'V', "\<C-v>": 'V',
\   'c': 'C', 's': 'S', 'S': 'S', "\<C-s>": 'S', 't': 'T',
\ }
\ }

let g:lightline#bufferline#filename_modifier = ':t:.'
let g:lightline#bufferline#modified = '+'
let g:lightline#bufferline#min_buffer_count = 2
let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#unicode_symbols = 1
let g:lightline#bufferline#unnamed = '[No Name]'
let g:lightline#bufferline#number_map = {
\ 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴',
\ 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹'}

nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)

function! LightlineMode() abort
  return expand('%:t') ==# 'ControlP' ? 'CtrlP' : lightline#mode()
endfunction

function! LightlineFilename() abort
  let l:filename = expand('%:t')

  if l:filename ==# 'ControlP'
    if exists('g:lightline.ctrlp_progress')
      return g:lightline.ctrlp_progress
    else
      return g:lightline.ctrlp_item
    endif
  elseif l:filename ==# '__Tagbar__'
    return ''
  elseif &filetype ==# 'help'
    return l:filename
  endif

  let l:pathname = expand('%')
  if l:pathname ==# '' || l:pathname ==# '.'
    let l:pathname = '[No Name]'
  else
    let l:pathname = fnamemodify(l:pathname, ':~:.')
  endif

  let l:readonly = &readonly && &filetype !=# 'help' ? ' [RO]' : ''
  let l:modified = &modified ? ' [+]' : ''
  return l:pathname . l:readonly . l:modified
endfunction

function! LightlineCtrlPMark() abort
  return expand('%:t') =~# 'ControlP' ? g:lightline.ctrlp_marked : ''
endfunction

function! LightlineCtrlPPath() abort
  return expand('%:t') =~# 'ControlP' ? fnamemodify(getcwd(), ':~') : ''
endfunction

function! LightlineFileinfo() abort
  return strlen(&filetype) ? &filetype : '' .
        \ strlen(&fileencoding) && &fileencoding !=# 'utf-8' ? ',' . &fileencoding : ''
endfunction

function! LightlineGitBranch() abort
  let l:branch = fugitive#head()
  return l:branch !=# '' ? "\uE0A0 " . l:branch : ''
endfunction

function! LightlineLintWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:all_non_errors == 0 ? '' : printf('%d ⁉', l:all_non_errors)
endfunction

function! LightlineLintErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  return l:all_errors == 0 ? '' : printf('%d ✗', l:all_errors)
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
  autocmd User ALELint call lightline#update()
augroup END
