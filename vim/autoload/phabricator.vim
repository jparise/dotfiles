function! phabricator#root_from_url(url) abort
  " Start by assuming the Phabricator hostname starts with 'phabricator', and
  " then add any additional patterns from the 'g:phabricator_domains' list.
  let domain_pattern = 'phabricator.*'
  let domains = get(g:, 'phabricator_domains', [])
  call map(copy(domains), 'substitute(v:val, "/$", "", "")')
  for domain in domains
    let domain_pattern .= '\|' . escape(split(domain, '://')[-1], '.')
  endfor
  let base = matchstr(a:url, '^\%(https\=://\|git://\|git@\|ssh://code@\|ssh://git@\)\=\zs\('.domain_pattern.'\)\/diffusion[/:][^/]\{-\}\ze[/:].\{-\}\%(\.git\)\=$')
  if !empty(base)
    return 'https://' . tr(base, ':', '/')
  endif
  return ''
endfunction

function! phabricator#fugitive_url(...) abort
  if a:0 == 1 || type(a:1) == type({})
    let opts = a:1
    let root = phabricator#root_from_url(get(opts, 'remote', ''))
  else
    return ''
  endif
  if empty(root)
    return ''
  endif
  let path = substitute(opts.path, '^/', '', '')
  if path =~# '^\.git/refs/heads/'
    return root . '/history/' . path[16:-1]
  elseif path =~# '^\.git/refs/tags/'
    return root . '/history/;' . path[15:-1]
  elseif path =~# '^\.git\>'
    return root
  endif
  let commit = opts.commit
  if commit =~# '^\d\=$'
    return ''
  endif
  let branch = FugitiveHead()
  if get(opts, 'type', '') ==# 'tree' || opts.path =~# '/$'
    let url = substitute(root . '/browse/' . branch . '/' . path, '/$', '', 'g')
  elseif get(opts, 'type', '') ==# 'blob' || opts.path =~# '[^/]$'
    let escaped_commit = substitute(commit, '#', '%23', 'g')
    let url = root . '/browse/' . branch . '/' . path . ';' . escaped_commit
    if get(opts, 'line2') && opts.line1 == opts.line2
      let url .= '$' . opts.line1
    elseif get(opts, 'line2')
      let url .= '$' . opts.line1 . '-' . opts.line2
    endif
  else
    let url = substitute(root, '/diffusion/', '/r', '') . commit
  endif
  return url
endfunction
