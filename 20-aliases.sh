# ~/.bashrc.d/20-aliases.sh

# -----------------------------------------------------------------------------
# Filesystem
# -----------------------------------------------------------------------------

alias ll='ls -lahF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias mkdir='mkdir -pv'

# -----------------------------------------------------------------------------
# Navigation
# -----------------------------------------------------------------------------

alias c='clear'
alias cls='clear'

# -----------------------------------------------------------------------------
# Git
# -----------------------------------------------------------------------------

alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gca='git commit --amend'
alias gp='git push'
alias gl='git pull'
alias gf='git fetch --all --prune'
alias gd='git diff'
alias gds='git diff --staged'
alias gb='git branch'
alias gco='git checkout'
alias gsw='git switch'
alias glog='git log --oneline --graph --decorate --all'

# -----------------------------------------------------------------------------
# Editors
# -----------------------------------------------------------------------------

if command -v nvim >/dev/null 2>&1; then
    alias vim='nvim'
    alias vi='nvim'
fi

# -----------------------------------------------------------------------------
# Modern CLI replacements
# -----------------------------------------------------------------------------

if command -v batcat >/dev/null 2>&1; then
    alias bat='batcat'
fi

if command -v eza >/dev/null 2>&1; then
    alias ls='eza'
    alias ll='eza -lah --group-directories-first'
    alias la='eza -a --group-directories-first'
    alias tree='eza --tree'
fi

if command -v rg >/dev/null 2>&1; then
    alias grep='rg'
fi

# -----------------------------------------------------------------------------
# System
# -----------------------------------------------------------------------------

alias ports='ss -tulpn'
alias dfh='df -h'
alias duh='du -h'
alias mem='free -h'
