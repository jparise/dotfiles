let g:projectionist_heuristics = {
\   'Makefile|Makefile.am': {
\       '*.c': {
\           'alternate': '{}.h',
\           'type': 'source'
\       },
\       '*.cc': {
\           'alternate': '{}.h',
\           'type': 'source'
\       },
\       '*.cpp': {
\           'alternate': '{}.h',
\           'type': 'source'
\       },
\       '*.h': {
\           'alternate': ['{}.c', '{}.cc', '{}.cpp'],
\           'type': 'header'
\       },
\   },
\   'src/': {
\       '*.go': {
\           'alternate': '{}_test.go',
\           'type': 'source'
\       },
\       '*_test.go': {
\           'alternate': '{}.go',
\           'type': 'test'
\       },
\   },
\   '*.gradle': {
\       'src/main/java/*.java': {
\           'alternate': 'src/test/java/{}Test.java',
\           'type': 'source'
\       },
\       'src/test/java/*Test.java': {
\           'alternate': 'src/main/java/{}.java',
\           'type': 'test'
\       },
\       'src/main/kotlin/*.kt': {
\           'alternate': 'src/test/kotlin/{}Test.kt',
\           'type': 'source'
\       },
\       'src/test/kotlin/*Test.kt': {
\           'alternate': 'src/main/kotlin/{}.kt',
\           'type': 'test'
\       },
\   },
\   'setup.py': {
\       '*.py': {
\           'alternate': [
\             'tests/{dirname}/test_{basename}.py',
\             '{dirname|dirname}/tests/{dirname|basename}/test_{basename}.py',
\           ],
\           'type': 'source'
\       },
\       'tests/**/test_*.py': {
\           'alternate': '{}.py',
\           'type': 'test'
\       },
\       '**/test_*.py': {
\           'alternate': '{dirname|dirname|dirname}/{dirname|basename}/{basename}.py',
\           'type': 'test'
\       },
\   },
\   'mix.exs': {
\       'lib/*.ex': {
\           'alternate': 'test/{}_test.exs',
\           'compiler': 'mix',
\           'type': 'source'
\       },
\       'test/*_test.exs': {
\           'alternate': 'lib/{}.ex',
\           'compiler': 'exunit',
\           'type': 'test'
\       }
\   }
\}

function! s:activate() abort
  for [root, value] in projectionist#query('compiler')
    try
      execute 'compiler ' . value
    catch /^Vim\%((\a\+)\)\=:E666/
    endtry
    break
  endfor
endfunction

augroup ProjectionistCustom
  autocmd!
  autocmd User ProjectionistActivate call s:activate()
augroup END
