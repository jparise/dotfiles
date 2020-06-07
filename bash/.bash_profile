# shellcheck source=/dev/null
[ -r ~/.bashrc ] && . ~/.bashrc

# Remap Ctrl-w to kill words using whitespace and slashes as word boundaries.
stty werase undef
bind '"\C-w": unix-filename-rubout'

# Map Ctrl-z in the shell to restore the suspended process.
stty susp undef
bind '"\C-z": "fg\n"'
