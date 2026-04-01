setlocal shiftwidth=2

" vim-plug-aware maps
if exists('g:plugs')
  if !exists('*s:plug_spec')
    function! s:plug_spec() abort
      let name = matchstr(getline('.'), "Plug\\s\\+['\"]\\zs[^'\"]*\\ze['\"]")
      let name = fnamemodify(substitute(name, '\.git$', '', ''), ':t')
      return get(g:plugs, name, {})
    endfunction

    function! s:plug_gf() abort
      let spec = s:plug_spec()
      if has_key(spec, 'dir')
        execute 'edit' fnameescape(spec.dir)
      else
        call vimgoto#Find('gF')
      endif
    endfunction

    function! s:plug_gx() abort
      let spec = s:plug_spec()
      if has_key(spec, 'uri')
        let url = substitute(spec.uri, '\.git$\|git::@', '', 'g')
      else
        let url = expand('<cfile>')
      endif
      if !empty(url)
        call netrw#BrowseX(url)
      endif
    endfunction
  endif

  nnoremap <buffer> gf <Cmd>call <SID>plug_gf()<CR>
  nnoremap <buffer> gx <Cmd>call <SID>plug_gx()<CR>
endif

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|setlocal shiftwidth<'
let b:undo_ftplugin .= '|silent! nunmap <buffer> gx'
let b:undo_ftplugin .= '|silent! nunmap <buffer> gf'
