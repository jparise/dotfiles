let g:ctrlp_brief_prompt = 1
let g:ctrlp_types = ['fil', 'mru']

let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}
let g:ctrlp_working_path_mode = 'ra'

let g:ctrlp_mruf_exclude = '.*/tmp/.*\|.*/.git/.*'
let g:ctrlp_mruf_max = 100
let g:ctrlp_mruf_relative = 1

if executable('fd')
    let s:fallback_command = 'fd --type f --color never "" %s'
    let g:ctrlp_use_caching = 0
elseif executable('rg')
    let s:fallback_command = 'rg %s --files --color=never --glob ""'
    let g:ctrlp_use_caching = 0
elseif executable('ag')
    let s:fallback_command = 'ag %s -l --nocolor -g ""'
    let g:ctrlp_use_caching = 0
else
    let s:fallback_command = ''
    let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
endif

let g:ctrlp_user_command = {
\ 'types': {
\   1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
\   2: ['.hg', 'hg --cwd %s locate -I .'],
\  },
\  'fallback': s:fallback_command
\}
