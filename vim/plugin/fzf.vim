let s:cpo_save = &cpoptions
set cpoptions&vim

function! s:get_git_root()
  let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  return v:shell_error ? '' : root
endfunction

function! s:git_operation_in_progress(root)
  return filereadable(a:root.'/.git/MERGE_HEAD') ||
        \filereadable(a:root.'/.git/rebase-merge') ||
        \filereadable(a:root.'/.git/rebase-apply') ||
        \filereadable(a:root.'/.git/CHERRY_PICK_HEAD')
endfunction

function! s:gitfiles(args)
  let root = s:get_git_root()
  if empty(root)
    echom 'Not in git repo'
    return 0
  endif

  " If we weren't called as GitFiles?, simply list all files in the git repo.
  " Any additional function arguments will be passed to `git ls-files`.
  if a:args !=# '?'
    return fzf#wrap({
    \ 'source':  'git ls-files '.a:args.' | uniq',
    \ 'dir':     root,
    \ 'options': '-m --prompt "GitFiles> "'
    \})
  endif

  " List changes between the current branch and its origin (e.g. master).
  let branch = 'git diff --name-status $(git merge-base origin/HEAD HEAD)..'

  " Also list modified files in the current working tree. Only include
  " untracked files if we're not in the middle of e.g. a merge operation.
  let modified = 'git -c color.status=always status --short '.
        \ (s:git_operation_in_progress(root)
        \   ? '--untracked-files=no' : '--untracked-files=all')

  let wrapped = fzf#wrap({
  \ 'source': branch.' && '.modified,
  \ 'dir':    root,
  \ 'options': [
  \   '--ansi', '--multi', '--nth', '2..,..', '--tiebreak=index',
  \   '--prompt', 'GitFiles?> ', '--preview',
  \   'sh -c "(git diff --color -- {-1} | sed 1,4d; cat {-1}) | head -500"']
  \})

  " This is a sink that strips status characters from the line (leaving just
  " the filename) and then passes the filename to the s:common_sink() function
  " that was added by fzf#wrap(). This way, we don't have to reimplement all
  " of the common action behavior.
  let wrapped.common_sink = remove(wrapped, 'sink*')
  function! wrapped.newsink(lines)
    let lines = extend(a:lines[0:0], map(a:lines[1:], 'trim(v:val[2:])'))
    return self.common_sink(lines)
  endfunction
  let wrapped['sink*'] = remove(wrapped, 'newsink')

  return wrapped
endfunction

command! -nargs=? GitFiles  call fzf#run(s:gitfiles(<q-args>))

let &cpoptions = s:cpo_save
unlet s:cpo_save
