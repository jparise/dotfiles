" Improved text list recognition for formatoption+=n
setlocal formatlistpat=^\\s*
setlocal formatlistpat+=[
setlocal formatlistpat+=\\[({]\\?                   " Opening punctuation
setlocal formatlistpat+=\\(
setlocal formatlistpat+=[0-9]\\+                    " Number
setlocal formatlistpat+=\\\|[iIvVxXlLcCdDmM]\\+     " Roman numberals
setlocal formatlistpat+=\\\|[a-zA-Z]                " Single letter
setlocal formatlistpat+=\\)
setlocal formatlistpat+=[\\]:.)}                    " Closing punctuation
setlocal formatlistpat+=]
setlocal formatlistpat+=\\s\\+
setlocal formatlistpat+=\\\|^\\s*[-+o*]\\s\\+       " ASCII-style bullets

" Move between paragraphs, landing on text instead of blank lines.
nnoremap <buffer> <expr> { len(getline(line('.')-1)) > 0 ? '{+' : '{-'
nnoremap <buffer> <expr> } len(getline(line('.')+1)) > 0 ? '}-' : '}+'
