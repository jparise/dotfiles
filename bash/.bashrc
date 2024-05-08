# shellcheck disable=SC1090,SC1091,SC2039

[ -z "$PS1" ] && return

set -o notify

shopt -s cdspell        # `cd` spelling correction on directory names
shopt -s checkwinsize   # update the window size after each command
shopt -s cmdhist        # save multi-line commands in the same history entry
shopt -s extglob        # enable extended pattern matching features
shopt -s histappend     # append to the history file when shell exits

if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
    shopt -s dirspell   # completion spelling correction on directory names
    shopt -s globstar   # '**' matches all directories and files recursively
fi

umask 0022

# Default to en_US locale with UTF-8 encoding.
: "${LANG:="en_US.UTF-8"}"
: "${LANGUAGE:="en"}"
: "${LC_CTYPE:="en_US.UTF-8"}"
: "${LC_ALL:="en_US.UTF-8"}"
export LANG LANGUAGE LC_CTYPE LC_ALL

FIGNORE=".o:.class:.pyc:.egg-info:__pycache__"
HISTCONTROL=ignoreboth
HISTIGNORE="&:bg:fg:clear:exit:pwd"
PROMPT_COMMAND="history -a"
PROMPT_DIRTRIM=3
PS1='[\W]$([ \j -gt 0 ] && echo \*)\$ '

# Set up the Homebrew shell environment.
if [ -d "/opt/homebrew" ]; then
    # eval "$(/opt/homebrew/bin/brew shellenv)"
    export HOMEBREW_PREFIX="/opt/homebrew";
    export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar";
    export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX";
    export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin${PATH+:$PATH}";
    export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}:";
    export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}";

    # Additional environment variables
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_NO_ENV_HINTS=1
fi

# Add git branch and status in the prompt
if [ -f "$HOMEBREW_PREFIX/etc/bash_completion.d/git-prompt.sh" ]; then
    . "$HOMEBREW_PREFIX/etc/bash_completion.d/git-prompt.sh"
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWUPSTREAM=auto
    PS1="\$(__git_ps1 \"[%s] \")$PS1"
fi

# Some shells let us configure their window title. Take advantage of that to
# display the current working directory. Remote (ssh) shells also include the
# hostname.
if [[ $TERM == "xterm"* ]]; then
	if [ -n "$SSH_CONNECTION" ]; then
		PS1="\\[\\e]0;\\h:\\w\\a\\]$PS1"
	else
		PS1="\\[\\e]0;\\w\\a\\]$PS1"
	fi
fi

export EDITOR=vim
export VISUAL=vim

export PAGER=less
export MANPAGER='less -FiRs'
export LESS='-EX'

export DIFF_OPTIONS='-du'

export ERL_AFLAGS='-kernel shell_history enabled'

# macOS-specific environment flags
if [[ $OSTYPE == "darwin"* ]]; then
    export BASH_SILENCE_DEPRECATION_WARNING=1
    export GREP_OPTIONS='--binary-files=without-match'
fi

# Language-specific paths
if [ -d "$HOME/go/bin" ]; then
    PATH="$HOME/go/bin:$PATH"
fi
if [ -d "$HOME/.cargo/bin" ]; then
	PATH="$HOME/.cargo/bin:$PATH"
fi
if [ -d "$HOME/.mix/escripts" ]; then
	PATH="$HOME/.mix/escripts:$PATH"
fi

# Add preferred Homebrew locations to PATH when available.
if [ -n "$HOMEBREW_PREFIX" ]; then
    for PKG in binutils bison curl libpq ruby; do
        if [ -d "$HOMEBREW_PREFIX/opt/$PKG/bin" ]; then
            PATH="$HOMEBREW_PREFIX/opt/$PKG/bin:$PATH"
        fi
    done
    if [ -d "$HOMEBREW_PREFIX/opt/python/libexec/bin" ]; then
        PATH="$HOMEBREW_PREFIX/opt/python/libexec/bin:$PATH"
    fi
fi

# Lastly, add my personal ~/bin directory to the front of $PATH.
if [ -d "$HOME/bin" ]; then
	PATH="$HOME/bin:$PATH"
fi

# Apply any additional local settings. Ordering here is important.
[ -f ~/.bashrc.local ] && . ~/.bashrc.local
[ -f "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
[[ -n "$WEZTERM_EXECUTABLE" && -f ~/.config/wezterm/wezterm.sh ]] && . ~/.config/wezterm/wezterm.sh

# Set up fzf defaults when it's available.
if [ -x "$(command -v fzf)" ]; then
    export FZF_DEFAULT_OPTS="--height 40% --border"

    # Prefer fd- or ripgrep-based fzf searches when available.
    if [ -x "$(command -v fd)" ]; then
        export FZF_DEFAULT_COMMAND='fd --type f'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    elif [ -x "$(command -v rg)" ]; then
        export FZF_DEFAULT_COMMAND='rg --files'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi

    eval "$(fzf --bash)"
fi

# Support for programmatically changing the current iTerm profile
if [ -n "$ITERM_PROFILE" ]; then
    iterm_profile() {
        echo -en "\\033]50;SetProfile=$*\\a"
    }

    ssh() {
        trap "iterm_profile Default" RETURN
        iterm_profile ssh
        command ssh "$@"
    }
fi

# Execute a command and load its output into vim's quickfix list.
vimq() {
    vim -q <("$@")
}
complete -F _command vimq

# Perform a ripgrep search and load its results into vim's quickfix list.
vimgrep() {
    local args=(--vimgrep)
    args+=("$@")
    vim -q <(rg "${args[@]}")
}
complete -o bashdefault -o default vimgrep

# Open Notes with optional (file) search arguments
notes() {
    vim -c "Notes $*"
}

# Open NotesGrep with optional (content) search arguments
notesgrep() {
    vim -c "NotesGrep $*"
}

# Open GV with optional `git log` arguments
gv() {
    vim -c "GV $*"
}
[ "$(declare -Ff __git_complete)" ] && __git_complete gv git_log

# Aliases
alias n=notes
alias ng=notesgrep

# If ondir is available, set up its shell hooks.
if hash ondir 2>/dev/null; then
    cd() {
        # shellcheck disable=SC2006
        builtin cd "$@" && eval "`ondir \"$OLDPWD\" \"$PWD\"`"
    }

    pushd() {
        # shellcheck disable=SC2006
        builtin pushd "$@" && eval "`ondir \"$OLDPWD\" \"$PWD\"`"
    }

    popd() {
        # shellcheck disable=SC2006
        builtin popd "$@" && eval "`ondir \"$OLDPWD\" \"$PWD\"`"
    }

    # shellcheck disable=SC2006
    [ "$PWD" != "$HOME" ] && eval "`ondir /`"
fi
