# ~/.bashrc.d/40-development.sh

# -----------------------------------------------------------------------------
# Default editor
# -----------------------------------------------------------------------------

if command -v nvim >/dev/null 2>&1; then
    export EDITOR='nvim'
    export VISUAL='nvim'
elif command -v vim >/dev/null 2>&1; then
    export EDITOR='vim'
    export VISUAL='vim'
fi

# -----------------------------------------------------------------------------
# Pager
# -----------------------------------------------------------------------------

export PAGER='less'
export LESS='-R'

# -----------------------------------------------------------------------------
# Go
# -----------------------------------------------------------------------------

export GOPATH="${GOPATH:-$HOME/go}"
export GO111MODULE='on'

# -----------------------------------------------------------------------------
# Development defaults
# -----------------------------------------------------------------------------

export TERM="${TERM:-xterm-256color}"

# Prefer UTF-8 where available.
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# -----------------------------------------------------------------------------
# ripgrep
# -----------------------------------------------------------------------------

if command -v rg >/dev/null 2>&1; then
    export RIPGREP_CONFIG_PATH="${RIPGREP_CONFIG_PATH:-$HOME/.config/ripgrep/config}"
fi
