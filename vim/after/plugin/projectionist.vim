let g:projectionist_heuristics = {
\   'Makefile': {
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
\   },
\   '*.xcodeproj|*.xcworkspace': {
\       '*.m': {
\           'alternate': '{}.h',
\           'type': 'source'
\       },
\       '*.h': {
\           'alternate': '{}.m',
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
\           'alternate': 'tests/{dirname}/test_{basename}.py',
\           'type': 'source'
\       },
\       'tests/**/test_*.py': {
\           'alternate': '{}.py',
\           'type': 'test'
\       },
\   },
\   'mix.exs': {
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
