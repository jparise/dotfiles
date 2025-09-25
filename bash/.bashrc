# shellcheck shell=bash
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
export LANG="en_US.UTF-8"

FIGNORE=".o:.class:.pyc:.egg-info:__pycache__"
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="&:bg:fg:clear:exit:pwd"
HISTSIZE=5000
PROMPT_COMMAND="history -a"
PROMPT_DIRTRIM=3
PS1='[\W]$([ \j -gt 0 ] && echo \*)\$ '

# Set up the Homebrew shell environment.
if [ -d "/opt/homebrew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Additional environment variables
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_NO_ENV_HINTS=1
fi

# Add git branch and status in the prompt
if [ -f "$HOMEBREW_PREFIX/etc/bash_completion.d/git-prompt.sh" ]; then
    . "$HOMEBREW_PREFIX/etc/bash_completion.d/git-prompt.sh"
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWUPSTREAM=auto
    PS1='$(__git_ps1 "[%s] ")'$PS1
fi

# For remote (ssh) sessions, add the hostname to the prompt and also display
# the current working directory in the window title in compatible terminals.
if [ -n "$SSH_CONNECTION" ]; then
    PS1='(\h) '$PS1
    [[ $TERM == "xterm"* ]] && PS1='\[\e]0;\h:\w\a\]'$PS1
fi

EDITOR="$(command -v vim 2>/dev/null || command -v vi)"
VISUAL=$EDITOR
export EDITOR VISUAL

export PAGER=less
export MANPAGER='less -FiRs'
export LESS='-ERX'

export DIFF_OPTIONS='-du'

# macOS-specific environment flags
if [[ $OSTYPE == "darwin"* ]]; then
    export BASH_SILENCE_DEPRECATION_WARNING=1
    export CLICOLOR=1
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

# Source any additional local scripts. Ordering here is important.
[ -f "$HOME/.bashrc.local" ] && . "$HOME/.bashrc.local"
[ -f "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
[ -f "$WEZTERM_CONFIG_DIR/wezterm.sh" ] && . "$WEZTERM_CONFIG_DIR/wezterm.sh"

# Set up direnv when it's available.
if hash direnv 2>/dev/null; then
    export DIRENV_LOG_FORMAT=$'\e[2mdirenv: %s\e[0m'
    eval "$(direnv hook bash)"
fi

# Set up fzf defaults when it's available.
if [ -x "$(command -v fzf)" ]; then
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

# Perform a ripgrep search and load its results into vim's quickfix list.
vimgrep() {
    [[ $# -eq 0 ]] && return

    # Form a quickfix list title string based on the command line,
    # quoting any arguments that contain spaces.
    local title="rg"
    for arg in "$@"; do
        [[ $arg =~ \  ]] && title+=" \"$arg\"" || title+=" $arg"
    done

    vim -q <(rg --vimgrep "$@") -c "call setqflist([], 'a', {'title' : '$title'})"
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

# Remap Ctrl-w to kill words using whitespace and slashes as word boundaries.
stty werase undef
bind '"\C-w": unix-filename-rubout'

# Disable START/STOP (Ctrl-q / Ctrl-s) output control.
stty -ixon
