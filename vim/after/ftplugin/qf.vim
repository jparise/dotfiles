setlocal statusline=%1*%t\ %2*%{jon#statusline#quickfix()}%=%4l/%-4L

nmap <silent> <buffer> <Left>  <Plug>(qf_older)
nmap <silent> <buffer> <Right> <Plug>(qf_newer)
nmap <silent> <buffer> { <Plug>(qf_previous_file)
nmap <silent> <buffer> } <Plug>(qf_next_file)
