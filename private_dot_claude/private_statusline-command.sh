#!/usr/bin/env bash
# Claude Code statusline: model, cwd, worktree/branch, context %, 5h/7d rate limits.
set -u

input=$(cat)

model=$(printf '%s' "$input" | jq -r '.model.display_name // "unknown"')
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // "."')
dir_name=$(basename "$cwd")

# Worktree/branch: prefer worktree info from the JSON payload; otherwise ask git.
worktree_name=$(printf '%s' "$input" | jq -r '.worktree.name // empty')
worktree_branch=$(printf '%s' "$input" | jq -r '.worktree.branch // empty')

if [ -n "$worktree_name" ]; then
  if [ -n "$worktree_branch" ]; then
    branch="$worktree_name/$worktree_branch"
  else
    branch="$worktree_name"
  fi
else
  branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
fi
[ -z "$branch" ] && branch="no-git"

used=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')
five=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Dimmed ANSI palette (terminal already dims the statusline further).
RESET=$'\033[0m'
DIM=$'\033[2m'
CYAN=$'\033[2;36m'
GREEN=$'\033[2;32m'
MAGENTA=$'\033[2;35m'
YELLOW=$'\033[2;33m'
RED=$'\033[2;31m'
SEP="${DIM}|${RESET}"

parts=()
parts+=("$(printf "${CYAN}%s${RESET}" "$model")")
parts+=("$(printf "${GREEN}%s${RESET}" "$dir_name")")
parts+=("$(printf "${MAGENTA}%s${RESET}" "$branch")")

if [ -n "$used" ]; then
  bar_width=10
  filled=$(awk -v u="$used" -v w="$bar_width" 'BEGIN{f=int((u/100)*w+0.5); if(f<0)f=0; if(f>w)f=w; print f}')
  empty=$((bar_width - filled))
  filled_bar=$(printf "%${filled}s" "" | tr ' ' '█')
  empty_bar=$(printf "%${empty}s" "" | tr ' ' '░')
  bar="${filled_bar}${empty_bar}"

  if awk -v u="$used" 'BEGIN{exit !(u>=80)}'; then
    CTX_COLOR="$RED"
  elif awk -v u="$used" 'BEGIN{exit !(u>=50)}'; then
    CTX_COLOR="$YELLOW"
  else
    CTX_COLOR="$GREEN"
  fi

  parts+=("$(printf "${CTX_COLOR}ctx [%s] %.0f%%${RESET}" "$bar" "$used")")
fi

limits=""
if [ -n "$five" ]; then
  limits="5h $(printf '%.0f' "$five")%"
fi
if [ -n "$week" ]; then
  if [ -n "$limits" ]; then
    limits="$limits, 7d $(printf '%.0f' "$week")%"
  else
    limits="7d $(printf '%.0f' "$week")%"
  fi
fi
if [ -n "$limits" ]; then
  parts+=("$(printf "${DIM}%s${RESET}" "$limits")")
fi

out=""
for p in "${parts[@]}"; do
  if [ -z "$out" ]; then
    out="$p"
  else
    out="$out $SEP $p"
  fi
done

printf '%s' "$out"
