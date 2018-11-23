let g:gutentags_define_advanced_commands = 1
let g:gutentags_exclude_filetypes = ['elixir', 'go']
let g:gutentags_file_list_command = {
\ 'markers': {
\   '.git': 'git ls-files',
\   '.hg': 'hg files',
\   }
\ }
