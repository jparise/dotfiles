let b:ale_fixers = ['black', 'isort']
let b:ale_linters = ['flake8', 'pyright']

if !exists('g:python_path')
  let cmd = "import sys; print('\\n'.join(p for p in sys.path if not p.endswith(('dynload', 'zip'))))"
  let g:python_path = split(system('python -c "' . cmd . '"'), "\n")
  if v:shell_error
    let g:python_path = []
  endif
end

execute 'setlocal path^=' . join(g:python_path, ',')
setlocal textwidth=79

let b:undo_ftplugin .= '|setlocal path< textwidth<'
