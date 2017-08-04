umask 022

tset -I -Q

setenv EDITOR 'mvim -f'
setenv VISUAL 'mvim -f'
setenv PAGER `which less`
setenv LESS -ErX
setenv DIFF_OPTIONS '-du'
setenv GREP_OPTIONS '--binary-files=without-match'

# Term setup
switch($TERM)
case 'xterm*':
    if ($?tcsh) then
        alias precmd 'echo -n "]1;`basename $cwd`"; echo -n "]2;$cwd"'
    endif
    breaksw
endsw

setenv COLORTERM $TERM
