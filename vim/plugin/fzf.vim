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

  " Find the merge-base with origin/HEAD to determine where the current
  " branch diverged, regardless of what the base branch is named.
  let result = FugitiveExecute(['merge-base', 'HEAD', 'origin/HEAD'])
  let merge_base = result.exit_status == 0 ? result.stdout[0] : ''

  " List the modified files in the current working tree. Only include
  " untracked files if we're not in the middle of e.g. a merge operation.
  let modified = 'git -c color.status=always status --short --no-renames '.
        \ (s:git_operation_in_progress(root)
        \   ? '--untracked-files=no' : '--untracked-files=all')

  " List changes between the current branch and where it diverged from the
  " base branch. Skip if we don't have a merge base (e.g. local-only repo).
  let committed = !empty(merge_base)
        \ ? 'git diff --name-status --no-renames '.merge_base.'..'
        \ : 'true'

  " Preview the file by showing the diff relative to either the local
  " working tree (uncommitted) or the merge-base with origin (committed).
  let preview_cmd = 'git diff --color '.
        \ (!empty(merge_base)
        \   ? '$(git diff --quiet HEAD -- {2..} && echo "'.merge_base.'..") '
        \   : '').
        \ '-- {2..} | sed 1,4d'

  return fzf#run(fzf#wrap('gitfiles', {
  \ 'source': '('.modified.' && '.committed.") | awk '!filenames[$NF]++'",
  \ 'dir':    root,
  \ 'options': [
  \   '--ansi', '--multi', '--nth', '2..,..', '--accept-nth', '2..',
  \   '--tiebreak=index', '--scheme', 'path', '--prompt', 'GitFiles?> ',
  \   '--preview', preview_cmd, '--preview-window', 'right,50%,<70(up,40%)']
  \}))
endfunction

command! -nargs=? GitFiles  call s:gitfiles(<q-args>)

let &cpoptions = s:cpo_save
unlet s:cpo_save
