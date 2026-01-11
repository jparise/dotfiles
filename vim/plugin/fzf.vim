let s:cpo_save = &cpoptions
set cpoptions&vim

function! s:git_operation_in_progress(root) abort
  let git_dir = FugitiveGitDir(a:root)
  if empty(git_dir) | return 0 | endif

  return filereadable(git_dir.'/MERGE_HEAD') ||
        \filereadable(git_dir.'/REBASE_HEAD') ||
        \filereadable(git_dir.'/CHERRY_PICK_HEAD') ||
        \filereadable(git_dir.'/REVERT_HEAD')
endfunction

function! s:gitfiles(args) abort
  let root = FugitiveWorkTree()

  " If we weren't called as GitFiles?, simply list all files in the git repo.
  " Any additional function arguments will be passed to `git ls-files`.
  if a:args !=# '?'
    if empty(root)
      return fzf#run(fzf#wrap('FZF'))
    endif

    return fzf#run(fzf#wrap('gitfiles', {
          \ 'source':  'git ls-files -z --deduplicate '.a:args,
          \ 'dir':     root,
          \ 'options': [
          \   '-m', '--read0', '--scheme', 'path', '--prompt', 'GitFiles> ']
          \}))
  endif

  " We can't proceed unless we're in a git repository.
  if empty(root)
    echom getcwd().' is not in a git repository'
    return 0
  endif

  " List the modified files in the current working tree. Only include
  " untracked files if we're not in the middle of e.g. a merge operation.
  let modified = 'git -c color.status=always status --short --no-renames '.
        \ (s:git_operation_in_progress(root)
        \   ? '--untracked-files=no' : '--untracked-files=all')

  " List changes between the current branch and where it diverged from
  " the base branch. merge-base is used to find the common ancestor with
  " origin/HEAD, which works regardless of what the base branch is named.
  let committed = 'git diff --name-status --no-renames '.
        \ '$(git merge-base HEAD origin/HEAD)..'

  " Preview the file by showing the diff relative to either the local
  " working tree (uncommitted) or the merge-base with origin (committed).
  let preview_cmd = 'git diff --color '.
        \ '$(git diff --quiet HEAD -- {-1} && '.
        \   'echo "$(git merge-base HEAD origin/HEAD)..") '.
        \ '-- {-1} | sed 1,4d'

  let wrapped = fzf#wrap('gitfiles', {
  \ 'source': '('.modified.' && '.committed.") | awk '!filenames[$NF]++'",
  \ 'dir':    root,
  \ 'options': [
  \   '--ansi', '--multi', '--nth', '2..,..', '--tiebreak=index',
  \   '--scheme', 'path', '--prompt', 'GitFiles?> ',
  \   '--preview', preview_cmd, '--preview-window', 'right,50%,<70(up,40%)']
  \})

  " This replacement sink strips status characters from each line (leaving
  " just the filename) and then passes the lines to the s:common_sink()
  " function that will be added by fzf#wrap(). That way, we don't have to
  " reimplement all of the common action behavior.
  let wrapped.common_sink = remove(wrapped, 'sink*')
  function! wrapped.newsink(lines)
    let lines = extend(a:lines[0:0], map(a:lines[1:], 'trim(v:val[2:])'))
    return self.common_sink(lines)
  endfunction
  let wrapped['sink*'] = remove(wrapped, 'newsink')

  return fzf#run(wrapped)
endfunction

command! -nargs=? GitFiles  call s:gitfiles(<q-args>)

let &cpoptions = s:cpo_save
unlet s:cpo_save
