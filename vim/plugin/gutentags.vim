let g:gutentags_define_advanced_commands = 1
let g:gutentags_generate_on_empty_buffer = 1
let g:gutentags_file_list_command = {
\ 'markers': {
\   '.git': 'git ls-files',
\   '.hg': 'hg files',
\   }
\ }
