#!/usr/bin/env bash
# https://code.claude.com/docs/en/statusline

input=$(cat)

# Colors (ANSI)
RESET='\033[0m'
BOLD='\033[1m'
CYAN='\033[36m'
YELLOW='\033[33m'
GREEN='\033[32m'
BLUE='\033[34m'
MAGENTA='\033[35m'
RED='\033[31m'
DIM='\033[2m'
GRAY='\033[90m'
SEP="${GRAY}›${RESET}"

# Model name
model=$(echo "$input" | jq -r '.model.display_name // ""')

# Effort level (only present when the model supports reasoning effort)
effort=$(echo "$input" | jq -r '.effort.level // ""')

# Working directory: raw path for git, tilde-abbreviated for display
cwd_raw=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""')
cwd="$cwd_raw"
if [ -n "$HOME" ] && [[ "$cwd_raw" == "$HOME" || "$cwd_raw" == "$HOME/"* ]]; then
    cwd="~${cwd_raw#"$HOME"}"
fi

# Git branch
git_part=""
if [ -n "$cwd_raw" ]; then
    if branch=$(git -C "$cwd_raw" symbolic-ref --short HEAD 2>/dev/null \
                || git -C "$cwd_raw" describe --tags --exact-match HEAD 2>/dev/null \
                || git -C "$cwd_raw" rev-parse --short HEAD 2>/dev/null); then
        git_part="$branch"
    fi
fi

# Context percentage
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

ctx_part=""
if [ -n "$used_pct" ]; then
    pct=$(printf '%.0f' "$used_pct")
    # Color: green < 60%, yellow 60–84%, red >= 85%
    if [ "$pct" -ge 85 ]; then
        pct_color="$RED"
    elif [ "$pct" -ge 60 ]; then
        pct_color="$YELLOW"
    else
        pct_color="$GREEN"
    fi
    ctx_part="${pct_color}${pct}%${RESET}"
fi

# Assemble output
out=""

# Model, optional effort level, then context percentage
if [ -n "$model" ]; then
    out="${out}${CYAN}${model}${RESET}"
    if [ -n "$effort" ]; then
        out="${out} ${CYAN}[${effort}]${RESET}"
    fi
    if [ -n "$ctx_part" ]; then
        out="${out} ${SEP} ${ctx_part}"
    fi
fi

# Working directory
if [ -n "$cwd" ]; then
    out="${out} ${SEP} ${BLUE}${cwd}${RESET}"
fi

# Git branch
if [ -n "$git_part" ]; then
    out="${out} ${YELLOW}(${git_part})${RESET}"
fi

printf "%b" "$out"
