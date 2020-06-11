# shellcheck source=/dev/null
[ -r ~/.bashrc ] && . ~/.bashrc

# Remap Ctrl-w to kill words using whitespace and slashes as word boundaries.
stty werase undef
bind '"\C-w": unix-filename-rubout'
