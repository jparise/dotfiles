scriptencoding utf-8

if exists('g:gitlog_loaded') || &compatible
  finish
endif
let g:gitlog_loaded = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Pattern matching a commit line: date + short hash
let s:commit_line = '\v^[^0-9]*\d{4}-\d{2}-\d{2}\s+\zs[a-f0-9]+'

function! s:warn(msg) abort
  echohl WarningMsg | echomsg a:msg | echohl None
endfunction

function! s:sha(...) abort
  return matchstr(get(a:000, 0, getline('.')), s:commit_line)
endfunction

function! s:scratch() abort
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nomodeline
endfunction

function! s:path(path) abort
  let rel = FugitivePath(a:path, '')
  return empty(rel) ? '.' : rel
endfunction

" Run a command list directly without a shell; return stdout lines.
function! s:run(args) abort
  let lines = []
  if has('nvim')
    let job = jobstart(a:args, {
          \ 'stdout_buffered': 1,
          \ 'on_stdout': {id, data, e -> extend(lines, data)}
          \ })
    call jobwait([job])
    if !empty(lines) && empty(lines[-1])
      call remove(lines, -1)
    endif
  else
    let job = job_start(a:args, {
          \ 'out_cb': {ch, line -> add(lines, line)},
          \ 'out_mode': 'nl',
          \ 'err_io': 'null'
          \ })
    while job_status(job) ==# 'run'
      sleep 10m
    endwhile
  endif
  return lines
endfunction

" Annotate flat log lines with ● (mainline) or ├ (branch).
" Input lines have format "%h %p<TAB>rest"; output prefixes rest with ● or ├.
function! s:flatten(lines) abort
  let main = ''
  let result = []
  for line in a:lines
    let tab = stridx(line, "\t")
    if tab < 0
      call add(result, line)
      continue
    endif
    let parts = split(line[:tab-1], ' ')
    let sha = parts[0]
    let prefix = (empty(main) || sha ==# main) ? '● ' : '├ '
    let main = get(parts, 1, '')
    call add(result, prefix . line[tab+1:])
  endfor
  return result
endfunction

function! s:split() abort
  let w = get(filter(range(1, winnr('$')), 'getwinvar(v:val, "gitlog")'), 0)
  if w
    execute w . 'wincmd w'
    enew
  else
    execute (&columns > 160 ? 'vertical' : '') 'botright new'
  endif
  let w:gitlog = 1
endfunction

function! s:type(visual) abort
  if a:visual
    let shas = filter(map(getline("'<", "'>"), 's:sha(v:val)'), '!empty(v:val)')
    if len(shas) < 2
      return [0, 0]
    endif
    return ['diff', FugitiveShellCommand(['diff', shas[-1], shas[0]])]
  endif

  let sha = s:sha()
  if !empty(sha)
    return ['commit', FugitiveFind(sha)]
  endif

  return [0, 0]
endfunction

function! s:open(visual, focus) abort
  let [type, target] = s:type(a:visual)

  if empty(type)
    return s:warn('not a commit line')
  endif

  call s:split()
  call s:scratch()
  if type ==# 'commit'
    execute 'edit' escape(target, ' ')
  elseif type ==# 'diff'
    let lines = systemlist(target)
    setlocal modifiable
    silent %delete _
    if !empty(lines)
      call setline(1, lines)
    endif
    setlocal nomodifiable
    setfiletype diff
  endif
  nnoremap <silent> <buffer> q :close<CR>
  if !a:focus
    wincmd p
  endif
endfunction

function! s:dot() abort
  let sha = s:sha()
  return empty(sha) ? '' : ':Git  ' . sha . "\<S-Left>\<Left>"
endfunction

function! s:jump(pattern, count) abort
  for i in range(abs(a:count))
    call search(a:pattern, a:count > 0 ? 'W' : 'bW')
  endfor
endfunction

function! s:jump_main(count) abort
  call s:jump('^●', a:count)
endfunction

function! s:jump_ref(count) abort
  call s:jump('\v^.{2}\d{4}-\d{2}-\d{2} [a-f0-9]{7,} \([^()#!]+\)', a:count)
endfunction

function! s:filter(pattern) abort
  if empty(a:pattern)
    if exists('b:gitlog_saved')
      setlocal modifiable
      silent %delete _
      call setline(1, b:gitlog_saved)
      setlocal nomodifiable
      unlet b:gitlog_saved
      silent execute 'file' fnameescape(b:gitlog_name)
    endif
    echo ''
    return
  endif
  if !exists('b:gitlog_saved')
    let b:gitlog_saved = getline(1, '$')
  endif
  let op = a:pattern =~# '[A-Z]' ? '=~#' : '=~?' " smartcase
  let lines = filter(copy(b:gitlog_saved), 'v:val ' . op . ' a:pattern')
  if empty(lines)
    call s:warn('no matches: ' . a:pattern)
    return
  endif
  setlocal modifiable
  silent %delete _
  call setline(1, lines)
  setlocal nomodifiable
  let @/ = (a:pattern =~# '[A-Z]') ? '\C' . a:pattern : '\c' . a:pattern
  silent execute 'file' fnameescape(b:gitlog_name . ' [' . a:pattern . ']')
endfunction

function! s:close() abort
  let w = get(filter(range(1, winnr('$')), 'getwinvar(v:val, "gitlog")'), 0)
  if w
    execute w . 'wincmd w'
    close
  endif
endfunction

function! s:help() abort
  echo 'o: open  gb: browse  f: filter  ]]/[[: main  ]r/[r: refs  ?: help  q: quit'
endfunction

function! s:quit() abort
  call s:close()
  " If closing this tab would leave only a single empty buffer (e.g.
  " `vim -c GitLog`), quit vim entirely instead.
  if tabpagenr('$') <= 2
    let bufs = getbufinfo({'buflisted': 1})
    if len(bufs) <= 1 && (empty(bufs) || (bufs[0].name ==# '' && !bufs[0].changed))
      quitall
    endif
  endif
  tabclose
endfunction

function! s:maps() abort
  nnoremap <silent> <buffer>          ?     :call <SID>help()<CR>
  nnoremap <silent> <buffer>          <CR>  :call <SID>open(0, 0)<CR>
  nnoremap <silent> <buffer>          o     :call <SID>open(0, 1)<CR>
  xnoremap <silent> <buffer>          <CR>  :<C-U>call <SID>open(1, 0)<CR>
  xnoremap <silent> <buffer>          o     :<C-U>call <SID>open(1, 1)<CR>
  nnoremap <silent> <buffer>          x     :call <SID>close()<CR>
  nnoremap          <buffer> <expr>   .     <SID>dot()
  nnoremap <silent> <buffer>          gb    :call <SID>gbrowse()<CR>
  nnoremap <silent> <buffer>          yc    :let @+=<SID>sha() \| echo @+<CR>
  nnoremap <silent> <buffer> <nowait> q    :call <SID>quit()<CR>
  nnoremap <silent> <buffer> <nowait> gq   :call <SID>quit()<CR>

  " Filtering
  nnoremap          <buffer> f     :call <SID>filter(input('filter: '))<CR>
  nnoremap <silent> <buffer> <BS>  :call <SID>filter('')<CR>

  " Navigation
  nnoremap <silent> <buffer> ]] :<C-U>call <SID>jump_main(v:count1)<CR>
  nnoremap <silent> <buffer> [[ :<C-U>call <SID>jump_main(-v:count1)<CR>
  nnoremap <silent> <buffer> ]r :<C-U>call <SID>jump_ref(v:count1)<CR>
  nnoremap <silent> <buffer> [r :<C-U>call <SID>jump_ref(-v:count1)<CR>

  " Move and preview
  nnoremap <silent> <buffer> <C-N> j:call <SID>open(0, 0)<CR>
  nnoremap <silent> <buffer> <C-P> k:call <SID>open(0, 0)<CR>
endfunction

function! s:gbrowse() abort
  let sha = s:sha()
  if empty(sha)
    return s:warn('not a commit line')
  endif
  execute 'GBrowse' sha
endfunction

function! s:list(opts, flat) abort
  " Limit default output to keep flatten() fast on large repos. Can be
  " overridden by passing --max-count=N. On repos without a commit-graph
  " file, cold-cache loads are also slower; run `git commit-graph write
  " --reachable` once to speed those up.
  let has_count = !empty(filter(copy(a:opts), 'v:val =~# ''^--max-count\|^-[0-9]'''))
  let fmt = (a:flat ? '%h %p%x09' : '') . '%cd %h%d %s (%an)'
  let git = get(g:, 'fugitive_git_executable', 'git')
  let args = [git, '-C', FugitiveWorkTree(), '--literal-pathspecs',
        \ 'log', '--color=never', '--date=short', '--topo-order',
        \ '--decorate-refs=refs/heads/',
        \ '--decorate-refs=refs/tags/',
        \ '--decorate-refs=refs/remotes/origin/HEAD',
        \ '--format=' . fmt]
        \ + (has_count ? [] : ['--max-count=10000'])
        \ + a:opts

  let b:gitlog_name = trim(fnamemodify(FugitiveWorkTree(), ':t') . ' ' . join(a:opts))
  silent execute 'file' fnameescape(b:gitlog_name)
  setlocal nowrap tabstop=8 cursorline iskeyword+=#
  call FugitiveDetect(@#)

  let lines = s:run(args)
  if a:flat
    let lines = s:flatten(lines)
  endif

  setlocal modifiable
  silent %delete _
  if !empty(lines)
    call setline(1, lines)
  endif
  setlocal nomodifiable
  setfiletype gitlog
  call s:maps()
  redraw
endfunction

function! s:gitlog(bang, args) abort
  if !exists('g:loaded_fugitive') || empty(FugitiveGitDir())
    return s:warn('not a git repository')
  endif

  try
    let [opts, paths] = s:split_pathspec(s:shellwords(a:args))
    let stripped = filter(copy(opts), 'v:val =~# ''^--\(oneline\|graph\|format\)''')
    call filter(opts, 'index(stripped, v:val) < 0')
    if !empty(stripped)
      call s:warn('ignored unsupported: ' . join(stripped, ', '))
    endif

    if a:bang
      let current = expand('%')
      if empty(current)
        throw 'untracked buffer'
      endif
      call add(opts, '--follow')
      let paths = ['--', s:path(current)]
    elseif empty(paths)
      " Move non-flag arguments that resolve to paths behind --.
      let files = filter(copy(opts), 'v:val !~# "^-" && (isdirectory(v:val) || filereadable(v:val))')
      if !empty(files)
        call filter(opts, 'index(files, v:val) < 0')
        call map(files, 's:path(v:val)')
        let paths = ['--'] + files
      endif
    else
      let paths = ['--'] + map(paths[1:], 's:path(v:val)')
    endif

    execute (tabpagenr() - 1) . 'tabnew'
    call s:scratch()
    call s:list(opts + paths, !a:bang)
  catch
    return s:warn(v:exception)
  endtry
endfunction

" Shell word splitting (from gv.vim)
function! s:trim(arg) abort
  let arg = substitute(a:arg, '\s*$', '', '')
  return arg =~# "^'.*'$" ? substitute(arg[1:-2], "''", '', 'g')
     \ : arg =~# '^".*"$' ? substitute(substitute(arg[1:-2], '""', '', 'g'), '\\"', '"', 'g')
     \ : substitute(substitute(arg, '""\|''''', '', 'g'), '\\ ', ' ', 'g')
endfunction

function! s:shellwords(arg) abort
  let words = []
  let contd = 0
  for token in split(a:arg, '\%(\%(''\%([^'']\|''''\)\+''\)\|\%("\%(\\"\|[^"]\)\+"\)\|\%(\%(\\ \|\S\)\+\)\)\s*\zs')
    let trimmed = s:trim(token)
    if contd
      let words[-1] .= trimmed
    else
      call add(words, trimmed)
    endif
    let contd = token !~# '\s\+$'
  endfor
  return words
endfunction

function! s:split_pathspec(args) abort
  let idx = index(a:args, '--')
  if idx < 0
    return [a:args, []]
  elseif idx == 0
    return [[], a:args]
  endif
  return [a:args[0 : idx - 1], a:args[idx :]]
endfunction

command! -bang -nargs=* -complete=customlist,fugitive#CompleteObject
      \ GitLog call s:gitlog(<bang>0, <q-args>)

let &cpoptions = s:cpo_save
unlet s:cpo_save
