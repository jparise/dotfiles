let b:ale_fixers = ['black', 'isort', 'ruff', 'ruff_format']
let b:ale_linters = ['flake8', 'mypy', 'pyright', 'ruff', 'unimport']

if !exists('g:python_path')
  let cmd = "import sys; print('\\n'.join(p for p in sys.path if not p.endswith(('dynload', 'zip'))))"
  let g:python_path = split(system('python -c "' . cmd . '"'), "\n")
  if v:shell_error
    let g:python_path = []
  endif
end

execute 'setlocal path^=' . join(g:python_path, ',')
setlocal textwidth=79

let g:python_indent = {}
let g:python_indent.open_paren = 'shiftwidth()'
let g:python_indent.nested_paren = 'shiftwidth()'
let g:python_indent.continue = 'shiftwidth()'
let g:python_indent.closed_paren_align_last_line = v:false

" Matchit support using custom match function for indentation-based matching
if exists('g:loaded_matchit')
  " Syntax groups to skip (similar to matchit's b:match_skip)
  let s:match_skip = 'comment\|string'

  " Match cycles for wrap-around behavior
  let s:match_cycles = {
    \ 'if':    ['if', 'elif', 'else'],
    \ 'try':   ['try', 'except', 'else', 'finally'],
    \ 'for':   ['for', 'else'],
    \ 'while': ['while', 'else'],
  \ }
  let s:match_keywords = uniq(sort(flatten(values(s:match_cycles))))

  " Map continuation keywords to their block type and opening keyword pattern
  let s:match_blocks = {
    \ 'elif':    ['if', '^\s*if\>'],
    \ 'except':  ['try', '^\s*try\>'],
    \ 'finally': ['try', '^\s*try\>'],
    \ 'else':    ['', '^\s*\%(if\|try\|for\|while\)\>'],
  \ }

  function! s:PythonMatch(forward) abort
    let keyword = expand('<cword>')
    if empty(keyword) || index(s:match_keywords, keyword) < 0
      return []
    endif

    " Skip keywords in unsupported highlight groups.
    if synIDattr(synID(line('.'), col('.'), 1), 'name') =~? s:match_skip
      return []
    endif

    " We only want matches with the same indentation as our keyword.
    " Use a common skip expression to enforce along with our syntax check.
    let indent = indent('.')
    let skip = 'indent(".") != ' . indent . ' || synIDattr(synID(line("."), col("."), 1), "name") =~? "' . s:match_skip . '"'

    " Determine where this block starts
    let block_type = keyword
    let block_start = line('.')
    if has_key(s:match_blocks, keyword)
      let [block_type, pattern] = s:match_blocks[keyword]

      " Search backward for this block's opening keyword
      let block_start = searchpos(pattern, 'nbW', 0, 0, skip)[0]
      if block_start == 0
        return []
      endif

      " 'else' can belong to multiple blocks (if/try/for/while). Its type
      " is unknown at this point so we need to extract it from what we found.
      if empty(block_type)
        let block_type = matchstr(getline(block_start), '^\s*\zs\w\+')
      endif
    endif

    " Get the list of keywords to cycle through for this block type
    let cycle = get(s:match_cycles, block_type, [])
    if empty(cycle)
      return []
    endif

    " Find where block ends by scanning forward for:
    " - A line with less indent (dedent out of block), OR
    " - A different keyword type at same indent (e.g., 'try' after 'if'), OR
    " - Another opening keyword of same type at same indent (new block)
    let block_end = line('$')
    for scan_line in range(block_start + 1, block_end)
      let scan_indent = indent(scan_line)
      if scan_indent < indent
        let block_end = scan_line - 1
        break
      elseif scan_indent == indent
        let kw = matchstr(getline(scan_line), '^\s*\zs\w\+')
        if !empty(kw)
          " Different keyword type
          if index(s:match_keywords, kw) >= 0 && index(cycle, kw) < 0
            let block_end = scan_line - 1
            break
          " Another opening keyword - new block
          elseif kw ==# cycle[0]
            let block_end = scan_line - 1
            break
          endif
        endif
      endif
    endfor

    " Search for next/previous keyword at same indent within block boundaries
    let pattern = '^\s*\zs\%(' . join(cycle, '\|') . '\)\>'
    if a:forward
      let [lnum, col] = searchpos(pattern, 'nW', block_end, 0, skip)
      " If not found, wrap to first keyword
      if lnum == 0
        let save_pos = getpos('.')
        call cursor(block_start, indent + 1)
        let [lnum, col] = searchpos(pattern, 'cW', block_end, 0, skip)
        call setpos('.', save_pos)
      endif
    else
      let [lnum, col] = searchpos(pattern, 'nbW', block_start, 0, skip)
      " If not found, wrap to last keyword at same indent
      if lnum == 0
        let save_pos = getpos('.')
        call cursor(block_end, 1)
        let [lnum, col] = searchpos(pattern, 'bW', block_start, 0, skip)
        call setpos('.', save_pos)
      endif
    endif

    return lnum > 0 ? [lnum, col] : []
  endfunction

  let b:match_function = function('s:PythonMatch')
endif

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
let b:undo_ftplugin .= '|setlocal path< textwidth<'
let b:undo_ftplugin .= '|unlet b:ale_fixers b:ale_linters'
let b:undo_ftplugin .= '|unlet b:match_function'
