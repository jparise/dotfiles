" Attempt to read the Phabricator API token from a local key file.
let s:api_key_file = expand('~/.config/phabricator/api.key')
if empty(get(g:, 'phabricator_api_token')) && filereadable(s:api_key_file)
  let lines = readfile(s:api_key_file)
  if !empty(lines)
    let g:phabricator_api_token = lines[0]
  endif
endif
