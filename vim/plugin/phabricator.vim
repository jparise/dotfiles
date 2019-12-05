if exists('g:loaded_phabricator') || v:version < 700 || &compatible
  finish
endif
let g:loaded_phabricator = 1

if !exists('g:fugitive_browse_handlers')
  let g:fugitive_browse_handlers = []
endif

if index(g:fugitive_browse_handlers, function('phabricator#fugitive_url')) < 0
  call insert(g:fugitive_browse_handlers, function('phabricator#fugitive_url'))
endif
