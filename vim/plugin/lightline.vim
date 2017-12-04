scriptencoding utf-8

let g:lightline = {
\ 'colorscheme': 'base16_ocean',
\ 'active': {
\   'left': [
\     ['mode', 'paste'],
\     ['filename'],
\     ['ctrlpmark']
\   ],
\   'right': [
\     ['lineinfo'],
\     ['lint_warnings', 'lint_errors', 'gitbranch'],
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
\ 'component_function': {
\   'mode': 'LightlineMode',
\   'filename': 'LightlineFilename',
\   'fileinfo': 'LightlineFileinfo',
\   'gitbranch': 'fugitive#head'
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
\ }
\ }

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
    let l:pathname = fnamemodify(l:pathname, ':~')
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

function! LightlineLintWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:all_non_errors == 0 ? '' : printf('%d W', l:all_non_errors)
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

augroup LightlineLint
  autocmd!
  autocmd User ALELint call lightline#update()
augroup END
