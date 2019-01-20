scriptencoding utf-8

set rulerformat=%8(%4l:%-3v%)

set statusline=%1*
set statusline+=%{&modifiable&&&modified?'•':&readonly?'×':'\ '}
set statusline+=%{statusline#fileprefix()}
set statusline+=%2*%t
set statusline+=%<
set statusline+=%3*%(\ [%{statusline#fileinfo()}]%)
set statusline+=%=
set statusline+=%3*%(%{statusline#async_jobs()}\ \ %)
set statusline+=%4*%(%{statusline#lint_warnings()}\ %)
set statusline+=%5*%(%{statusline#lint_errors()}\ %)
set statusline+=%2*%4l:%-3v

augroup StatuslineRefresh
  autocmd!
  autocmd VimEnter,ColorScheme * call statusline#update_colorscheme()
  autocmd User ALEJobStarted,ALEFixPost,ALELintPost redrawstatus
  autocmd User AsyncRunStart,AsyncRunStop redrawstatus
  autocmd User FerretAsyncStart let b:ferret_async = 1 | redrawstatus
  autocmd User FerretAsyncFinish unlet b:ferret_async | redrawstatus
  autocmd User GutentagsUpdating,GutentagsUpdated redrawstatus 
augroup END
