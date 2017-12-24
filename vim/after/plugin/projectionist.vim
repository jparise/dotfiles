let g:projectionist_heuristics = {
\   '*': {
\       '*.c': {
\           'alternate': '{}.h',
\           'type': 'source'
\       },
\       '*.cc': {
\           'alternate': '{}.h',
\           'type': 'source'
\       },
\       '*.h': {
\           'alternate': ['{}.c', '{}.cc'],
\           'type': 'header'
\       },
\       'src/main/java/*.java': {
\           'alternate': 'src/test/java/{}Test.java',
\           'type': 'source'
\       },
\       'src/test/java/*Test.java': {
\           'alternate': 'src/main/java/{}.java',
\           'type': 'test'
\       },
\       '*.py': {
\           'alternate': 'tests/{dirname}/test_{basename}.py',
\           'type': 'source'
\       },
\       'tests/**/test_*.py': {
\           'alternate': '{}.py',
\           'type': 'test'
\       },
\       'lib/*.ex': {
\           'alternate': 'test/{}_test.exs',
\           'type': 'source'
\       },
\       'test/*_test.exs': {
\           'alternate': 'lib/{}.ex',
\           'type': 'test'
\       }
\   }
\}
