[ -z "$PS1" ] && return

set -o notify

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dirspell
shopt -s extglob
shopt -s globstar
shopt -s histappend

umask 0022

# Default to en_US locale with UTF-8 encoding.
: ${LANG:="en_US.UTF-8"}
: ${LANGUAGE:="en"}
: ${LC_CTYPE:="en_US.UTF-8"}
: ${LC_ALL:="en_US.UTF-8"}
export LANG LANGUAGE LC_CTYPE LC_ALL

HISTCONTROL=ignoreboth
HISTIGNORE="&:bg:fg:clear:exit"
PROMPT_COMMAND="history -a"
PROMPT_DIRTRIM=3
PS1="[\W]\$ "

# Some shells let us configure their window title. Take advantage of that to
# display the current working directory. Remote (ssh) shels also include the
# hostname.
if [[ $TERM == "xterm"* ]]; then
	if [ -n "$SSH_CONNECTION" ]; then
		PS1="\[\e]0;\h:\w\a\]$PS1"
	else
		PS1="\[\e]0;\w\a\]$PS1"
	fi
fi

export EDITOR=vim
export VISUAL=vim

export PAGER=less
export MANPAGER='less -FiRs'
export LESS='-ErX'

export DIFF_OPTIONS='-du'
export GREP_OPTIONS='--binary-files=without-match'

export ERL_AFLAGS='-kernel shell_history enabled'

# Set up GOROOT when we detect that Go is available.
if [ -n "$(command -v go)" ]; then
	export GOROOT=$(go env GOROOT)
	PATH="$GOROOT/bin:$PATH"
fi

# Add preferred Homebrew locations to PATH when available.
if [ -d "/usr/local/opt/bison/bin" ]; then
	PATH="/usr/local/opt/bison/bin/:$PATH"
fi
if [ -d "/usr/local/opt/python/libexec/bin" ]; then
	PATH="/usr/local/opt/python/libexec/bin:$PATH"
fi

# Lastly, add my personal ~/[Bb]in directory to the front of $PATH.
if [ -d "$HOME/Bin" ]; then
	PATH="$HOME/Bin:$PATH"
elif [ -d "$HOME/bin" ]; then
	PATH="$HOME/bin:$PATH"
fi

# Remap Ctrl-w to kill words using whitespace and slashes as word boundaries.
stty werase undef
bind '"\C-w": unix-filename-rubout'

# Basic shell completions
complete -A export     printenv
complete -A variable   export local readonly unset
complete -A enabled    builtin
complete -A alias      alias unalias
complete -A function   function
complete -A helptopic  help
complete -A setopt     set
complete -A shopt      shopt
complete -A directory  mkdir rmdir
complete -A directory   -o default cd pushd

complete -A stopped -P '%' bg
complete -A job -P '%'     fg jobs disown

# Set the xterm title
function xtitle()
{
	if [[ $TERM == "xterm"* ]]; then
		echo -en "\e]0;$*\a"
	fi
}

# Set the iTerm2 profile
function iterm_profile()
{
	if [ "$TERM_PROGRAM" == iTerm.app ]; then
		echo -en "\033]50;SetProfile=$*\a"
	fi
}

# Optionally include any additional local settings.
[ -f $HOME/.bashrc.local ] && . $HOME/.bashrc.local
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion