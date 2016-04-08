if (! $?USER) then
    setenv USER "$LOGNAME"
endif

set path = ($HOME/Bin $HOME/.gem/ruby/1.8/bin)
set path = ($path /usr/local/bin /usr/local/sbin)
set path = ($path /usr/bin /bin /usr/sbin /sbin /usr/X11/bin)

# Interactive shell?
if ($?prompt == 0) then
    exit 0
endif

# Shell variables
unset autologout
set echo_style = bsd
set filec
set fignore = (.o .class .pyc)
set history = 50
set savehist = 10
set nobeep
set notify

if ($?tcsh) then
    #   set symlinks = ignore
    bindkey "^W"    backward-delete-word
    bindkey -k up   history-search-backward
    bindkey -k down history-search-forward

    uncomplete *
    complete cd     'p/1/d/'
    complete pushd  'p/1/d/'
    complete popd   'p/1/d/'
    complete vi     'p/*/f:^{core,*.[oa]}/'
    complete vim    'p/*/f:^{core,*.[oa]}/'
    complete which  'p/1/c/'
    complete kill   'c/-/S/ c/%/j/'
    complete fg     'c/%/j/'
    complete bg     'c/%/j/'
    complete sudo   'p/1/c/'
endif

# Prompt setup
if ($?tcsh) then
    set prompt="[%c]$ "
else
    set prompt="(`hostname | cut -f1 -d.`) [\!]$ "
endif

unlimit coredumpsize

# Aliases
unalias *
alias   pwd 'echo $cwd'
alias   reload  'source ~/.cshrc ; source ~/.login'

# Optionally include any local settings.
if (-f "$HOME/.cshrc.local") then
    source $HOME/.cshrc.local
endif
