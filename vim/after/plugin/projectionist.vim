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
\       '*.m': {
\           'alternate': '{}.h',
\           'type': 'source'
\       },
\       '*.h': {
\           'alternate': ['{}.c', '{}.cc', '{}.m'],
\           'type': 'header'
\       },
\       '*.go': {
\           'alternate': '{}_test.go',
\           'type': 'source'
\       },
\       '*_test.go': {
\           'alternate': '{}.go',
\           'type': 'test'
\       },
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
