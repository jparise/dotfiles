let g:gutentags_define_advanced_commands = 1
let g:gutentags_exclude_filetypes = ['git', 'gitcommit', 'go']
let g:gutentags_file_list_command = {
\ 'markers': {
\   '.git': 'git ls-files',
\   '.hg': 'hg files',
\   }
\ }
let g:gutentags_generate_on_new = 0
