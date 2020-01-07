set rulerformat=%8(%4l:%-3v%)

set statusline=%1*
set statusline+=%(\%w\ %)
set statusline+=%{jon#statusline#fileprefix()}
set statusline+=%2*%t
set statusline+=%<
set statusline+=%3*%(\ [%{jon#statusline#fileinfo()}%R%M]%)
set statusline+=%=
if has('timers') && (has('nvim') || (exists('*job_start')))
  set statusline+=%3*%(%{jon#statusline#async_jobs()}\ \ %)
  set statusline+=%4*%(%{jon#statusline#lint_warnings()}\ %)
  set statusline+=%5*%(%{jon#statusline#lint_errors()}\ %)
endif
set statusline+=%1*%4l:%-3v

augroup StatuslineRefresh
  autocmd!
  autocmd VimEnter,ColorScheme * call jon#statusline#update_colorscheme()
  autocmd User ALEJobStarted,ALEFixPost,ALELintPost redrawstatus
  autocmd User GrepStart let g:grepping = 1 | redrawstatus
  autocmd User GrepFinish unlet g:grepping | redrawstatus
  autocmd User GutentagsUpdating,GutentagsUpdated redrawstatus 
augroup END
