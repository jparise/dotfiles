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

HISTCONTROL=ignoreboth
HISTIGNORE="&:bg:fg:clear:exit:pwd"
PROMPT_COMMAND="history -a"
PROMPT_DIRTRIM=3
PS1='[\W]\$ '

# Add git branch and status in the prompt
if [ -f /usr/local/etc/bash_completion.d/git-prompt.sh ]; then
    . /usr/local/etc/bash_completion.d/git-prompt.sh
elif [ -f /usr/local/git/contrib/completion/git-prompt.sh ]; then
    . /usr/local/git/contrib/completion/git-prompt.sh
fi
if [ "$(declare -Ff __git_ps1)" ]; then
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
export LESS='-ErX'

export DIFF_OPTIONS='-du'

export ERL_AFLAGS='-kernel shell_history enabled'

# macOS-specific environment flags
if [[ $OSTYPE == "darwin"* ]]; then
    export GREP_OPTIONS='--binary-files=without-match'
    export COCOAPODS_DISABLE_STATS=1
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_NO_AUTO_UPDATE=1
    export HOMEBREW_INSTALL_CLEANUP=1
fi

# Set up fzf defaults when it's available.
if [ -n "$(command -v fzf)" ]; then
    export FZF_DEFAULT_OPTS="
    --height 40% --border
    --color=bg+:#343d46,bg:#2b303b,spinner:#96b5b4,hl:#8fa1b3
    --color=fg:#a7adba,header:#8fa1b3,info:#ebcb8b,pointer:#96b5b4
    --color=marker:#96b5b4,fg+:#dfe1e8,prompt:#ebcb8b,hl+:#8fa1b3
    "

    # Prefer fd- or ripgrep-based fzf searches when available.
    if [ -n "$(command -v fd)" ]; then
        export FZF_DEFAULT_COMMAND='fd --type f'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    elif [ -n "$(command -v rg)" ]; then
        export FZF_DEFAULT_COMMAND='rg --files'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi
fi

# Set up GOROOT when we detect that Go is available.
if [ -n "$(command -v go)" ]; then
	GOROOT=$(go env GOROOT)
	export GOROOT
	PATH="$GOROOT/bin:$PATH"
	[ -d "$HOME/go/bin" ] && PATH="$HOME/go/bin:$PATH"
fi

# Add cargo's bin directory to the path.
if [ -d "$HOME/.cargo/bin" ]; then
	PATH="$HOME/.cargo/bin:$PATH"
fi

# Add preferred Homebrew locations to PATH when available.
for PKG in binutils bison curl ruby; do
    if [ -d "/usr/local/opt/$PKG/bin" ]; then
        PATH="/usr/local/opt/$PKG/bin:$PATH"
    fi
done
if [ -d "/usr/local/opt/python/libexec/bin" ]; then
    PATH="/usr/local/opt/python/libexec/bin:$PATH"
fi

# Lastly, add my personal ~/bin directory to the front of $PATH.
if [ -d "$HOME/bin" ]; then
	PATH="$HOME/bin:$PATH"
fi

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
xtitle() {
	if [[ $TERM == "xterm"* ]]; then
		echo -en "\\e]0;$*\\a"
	fi
}

# Set the iTerm2 profile
iterm_profile() {
	if [ "$TERM_PROGRAM" == iTerm.app ]; then
		echo -en "\\033]50;SetProfile=$*\\a"
	fi
}

# Use an alternate iTerm2 profile for ssh sessions
ssh() {
	iterm_profile Remote
	command ssh "$@"
	iterm_profile Default
}

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

# On macOS systems with the `curlie` curl wrapper installed, add support for
# fetching OAuth2 bearer tokens from the keychain. "Internet Passwords" are
# stored on a per-hostname basis (-s) with an 'oauth2' kind (-D). New tokens
# can be added to the keychain using:
#
#    security add-internet-password -a $USER -s $HOSTNAME -r http -D oauth2 -w
if [ -n "$(command -v curlie)" ] && [ -n "$(command -v security)" ]; then
    curlie() {
        args=("$@")
        host=$(echo "$@" | sed -En 's#.*://([^"/ ]+).*#\1#p')
        if [[ -n $host ]]; then
            token=$(security find-internet-password -s "$host" -r http -D oauth2 -w 2>/dev/null)
            if [[ -n $token ]]; then
                args+=(--oauth2-bearer "$token")
            fi
        fi
        command curlie "${args[@]}"
    }
fi

# Optionally include any additional local settings.
[ -f ~/.fzf.bash ] && . ~/.fzf.bash
[ -f ~/.bashrc.local ] && . ~/.bashrc.local
[ -f ~/.iterm2_shell_integration.bash ] && . ~/.iterm2_shell_integration.bash
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
