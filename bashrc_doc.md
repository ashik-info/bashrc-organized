## Modular Bash setup for a Linux development workstation.

### `~/.bashrc`

```bash
# ~/.bashrc

# Stop if shell is non-interactive.
case $- in
    *i*) ;;
      *) return ;;
esac

# -----------------------------------------------------------------------------
# History
# -----------------------------------------------------------------------------

HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT='%F %T  '

shopt -s histappend
shopt -s checkwinsize

# -----------------------------------------------------------------------------
# Load modular configuration
# -----------------------------------------------------------------------------

if [[ -d "$HOME/.bashrc.d" ]]; then
    shopt -s nullglob

    for file in "$HOME"/.bashrc.d/*.sh; do
        source "$file"
    done

    shopt -u nullglob
    unset file
fi
```

Directory:

```text
~/.bashrc.d/
├── 10-path.sh
├── 20-aliases.sh
├── 30-functions.sh
├── 40-development.sh
├── 50-docker.sh
├── 60-rust.sh
├── 70-node.sh
└── 90-local.sh
```

## `10-path.sh`

Keep all PATH manipulation centralized here.

```bash
# ~/.bashrc.d/10-path.sh

# -----------------------------------------------------------------------------
# PATH helpers
# -----------------------------------------------------------------------------

path_prepend() {
    [[ -d "$1" ]] || return 0

    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1:$PATH" ;;
    esac
}

path_append() {
    [[ -d "$1" ]] || return 0

    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$PATH:$1" ;;
    esac
}

# -----------------------------------------------------------------------------
# User binaries
# -----------------------------------------------------------------------------

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"

# Go
if [[ -n "${GOPATH:-}" ]]; then
    path_prepend "$GOPATH/bin"
elif [[ -d "$HOME/go/bin" ]]; then
    path_prepend "$HOME/go/bin"
fi

# Rust / Cargo
path_prepend "$HOME/.cargo/bin"

# PNPM
export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
path_prepend "$PNPM_HOME"

# Bun
path_prepend "$HOME/.bun/bin"

export PATH

unset -f path_prepend
unset -f path_append
```

## `20-aliases.sh`

Only simple command aliases should live here.

```bash
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
```

## `30-functions.sh`

Put functions here rather than complex aliases.

```bash
# ~/.bashrc.d/30-functions.sh

# -----------------------------------------------------------------------------
# Filesystem
# -----------------------------------------------------------------------------

mkcd() {
    if [[ $# -ne 1 ]]; then
        printf 'Usage: mkcd <directory>\n' >&2
        return 2
    fi

    mkdir -p -- "$1" && cd -- "$1"
}

up() {
    local levels="${1:-1}"
    local path=""

    if ! [[ "$levels" =~ ^[0-9]+$ ]]; then
        printf 'Usage: up [levels]\n' >&2
        return 2
    fi

    while (( levels > 0 )); do
        path+="../"
        ((levels--))
    done

    cd "$path" || return
}

# -----------------------------------------------------------------------------
# Networking
# -----------------------------------------------------------------------------

port() {
    if [[ $# -ne 1 ]]; then
        printf 'Usage: port <port-number>\n' >&2
        return 2
    fi

    ss -lntup | grep -E ":${1}([[:space:]]|$)"
}

killport() {
    if [[ $# -ne 1 ]]; then
        printf 'Usage: killport <port-number>\n' >&2
        return 2
    fi

    local pid

    pid="$(lsof -ti :"$1")"

    if [[ -z "$pid" ]]; then
        printf 'No process found on port %s\n' "$1"
        return 1
    fi

    kill "$pid"
}

# -----------------------------------------------------------------------------
# Archive helpers
# -----------------------------------------------------------------------------

extract() {
    if [[ ! -f "$1" ]]; then
        printf 'File not found: %s\n' "$1" >&2
        return 1
    fi

    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz)  tar xzf "$1" ;;
        *.tar.xz)  tar xJf "$1" ;;
        *.bz2)     bunzip2 "$1" ;;
        *.gz)      gunzip "$1" ;;
        *.tar)     tar xf "$1" ;;
        *.tbz2)    tar xjf "$1" ;;
        *.tgz)     tar xzf "$1" ;;
        *.zip)     unzip "$1" ;;
        *.7z)      7z x "$1" ;;
        *)
            printf 'Unsupported archive: %s\n' "$1" >&2
            return 2
            ;;
    esac
}
```

## `40-development.sh`

General development environment configuration.

```bash
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
```

One note: setting `LC_ALL` permanently can be too aggressive. If your system already has a valid locale, you can omit:

```bash
export LC_ALL=...
```

## `50-docker.sh`

Docker/Compose helpers.

```bash
# ~/.bashrc.d/50-docker.sh

command -v docker >/dev/null 2>&1 || return 0

# -----------------------------------------------------------------------------
# Docker
# -----------------------------------------------------------------------------

alias d='docker'
alias di='docker images'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dlog='docker logs'
alias dexec='docker exec -it'

# -----------------------------------------------------------------------------
# Docker Compose
# -----------------------------------------------------------------------------

if docker compose version >/dev/null 2>&1; then
    alias dc='docker compose'
    alias dcu='docker compose up'
    alias dcud='docker compose up -d'
    alias dcd='docker compose down'
    alias dcr='docker compose restart'
    alias dcb='docker compose build'
    alias dcps='docker compose ps'
    alias dcl='docker compose logs'
    alias dclf='docker compose logs -f'
fi

# -----------------------------------------------------------------------------
# Cleanup helpers
# -----------------------------------------------------------------------------

docker-clean() {
    docker container prune -f
    docker image prune -f
    docker network prune -f
}

docker-clean-all() {
    printf 'This removes unused containers, networks, images and build cache.\n'
    docker system prune -a
}

# -----------------------------------------------------------------------------
# Shell into a container
# -----------------------------------------------------------------------------

dsh() {
    if [[ $# -ne 1 ]]; then
        printf 'Usage: dsh <container>\n' >&2
        return 2
    fi

    local container="$1"

    docker exec -it "$container" bash 2>/dev/null ||
        docker exec -it "$container" sh
}
```

I would **not** automatically set `DOCKER_HOST` here unless you intentionally use rootless Docker exclusively.

If needed, put that machine-specific value in `90-local.sh`.

## `60-rust.sh`

Rust/Cargo-related environment.

```bash
# ~/.bashrc.d/60-rust.sh

# -----------------------------------------------------------------------------
# Rustup / Cargo
# -----------------------------------------------------------------------------

if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

# -----------------------------------------------------------------------------
# Cargo aliases
# -----------------------------------------------------------------------------

command -v cargo >/dev/null 2>&1 || return 0

alias cbuild='cargo build'
alias ccheck='cargo check'
alias crun='cargo run'
alias ctest='cargo test'
alias cfmt='cargo fmt'
alias cclippy='cargo clippy'
alias cclean='cargo clean'

# Run Clippy with warnings treated as errors.
alias cclippy-strict='cargo clippy --all-targets --all-features -- -D warnings'

# Format check suitable for CI.
alias cfmt-check='cargo fmt --all -- --check'

# -----------------------------------------------------------------------------
# Cargo helpers
# -----------------------------------------------------------------------------

cargo-ci() {
    cargo fmt --all -- --check &&
        cargo clippy --workspace --all-targets --all-features -- -D warnings &&
        cargo test --workspace --all-features
}
```

## `70-node.sh`

Node.js / NVM / PNPM setup.

```bash
# ~/.bashrc.d/70-node.sh

# -----------------------------------------------------------------------------
# NVM
# -----------------------------------------------------------------------------

export NVM_DIR="$HOME/.nvm"

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
fi

# Bash completion is optional.
if [[ -s "$NVM_DIR/bash_completion" ]]; then
    source "$NVM_DIR/bash_completion"
fi

# -----------------------------------------------------------------------------
# PNPM
# -----------------------------------------------------------------------------

export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"

case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# -----------------------------------------------------------------------------
# Package-manager aliases
# -----------------------------------------------------------------------------

command -v pnpm >/dev/null 2>&1 && {
    alias p='pnpm'
    alias pi='pnpm install'
    alias pa='pnpm add'
    alias pad='pnpm add --save-dev'
    alias pr='pnpm run'
    alias pd='pnpm dev'
    alias pb='pnpm build'
    alias pt='pnpm test'
}

command -v npm >/dev/null 2>&1 && {
    alias ni='npm install'
    alias nr='npm run'
}
```

### Optional: lazy-load NVM

NVM noticeably slows Bash startup. A better version for frequent terminal usage is:

```bash
# ~/.bashrc.d/70-node.sh

export NVM_DIR="$HOME/.nvm"
export PNPM_HOME="$HOME/.local/share/pnpm"

case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
esac

nvm() {
    unset -f nvm node npm npx

    # shellcheck source=/dev/null
    source "$NVM_DIR/nvm.sh"

    nvm "$@"
}

node() {
    unset -f nvm node npm npx
    source "$NVM_DIR/nvm.sh"
    node "$@"
}

npm() {
    unset -f nvm node npm npx
    source "$NVM_DIR/nvm.sh"
    npm "$@"
}

npx() {
    unset -f nvm node npm npx
    source "$NVM_DIR/nvm.sh"
    npx "$@"
}
```

I recommend this version if shell startup performance matters.

## `90-local.sh`

Machine-specific configuration belongs here.

Do **not** commit this file to a dotfiles repository if it contains workstation-specific configuration.

```bash
# ~/.bashrc.d/90-local.sh

# -----------------------------------------------------------------------------
# Machine-specific environment
# -----------------------------------------------------------------------------

# Example:
#
# export WORKSPACE="$HOME/workspace"
# export PROJECTS="$HOME/projects"
#
# export DOCKER_HOST="unix:///run/user/$(id -u)/docker.sock"
#
# export AWS_PROFILE="development"

# -----------------------------------------------------------------------------
# Local navigation
# -----------------------------------------------------------------------------

[[ -d "$HOME/workspace" ]] &&
    alias workspace='cd "$HOME/workspace"'

[[ -d "$HOME/workspace/web" ]] &&
    alias webwork='cd "$HOME/workspace/web"'

# -----------------------------------------------------------------------------
# Local-only PATH entries
# -----------------------------------------------------------------------------

if [[ -d "$HOME/.local/custom/bin" ]]; then
    export PATH="$HOME/.local/custom/bin:$PATH"
fi
```

## Recommended `.gitignore`

If `~/.bashrc.d` is managed as a dotfiles repository:

```gitignore
90-local.sh
*.local.sh
*.secret.sh
```

Do not store API keys, tokens, DB passwords, or cloud secrets directly in these Bash files.

For secrets, use a dedicated protected file:

```bash
# ~/.bashrc.d/95-secrets.sh

if [[ -r "$HOME/.config/shell/secrets.env" ]]; then
    set -a
    source "$HOME/.config/shell/secrets.env"
    set +a
fi
```

Then:

```bash
chmod 600 ~/.config/shell/secrets.env
```

Example:

```bash
# ~/.config/shell/secrets.env

DATABASE_URL='postgresql://localhost/example'
SOME_API_TOKEN='...'
```

## Create everything

```bash
mkdir -p ~/.bashrc.d

touch \
    ~/.bashrc.d/10-path.sh \
    ~/.bashrc.d/20-aliases.sh \
    ~/.bashrc.d/30-functions.sh \
    ~/.bashrc.d/40-development.sh \
    ~/.bashrc.d/50-docker.sh \
    ~/.bashrc.d/60-rust.sh \
    ~/.bashrc.d/70-node.sh \
    ~/.bashrc.d/90-local.sh
```

Validate before reloading:

```bash
bash -n ~/.bashrc

for file in ~/.bashrc.d/*.sh; do
    echo "Checking $file"
    bash -n "$file" || break
done
```

Then:

```bash
source ~/.bashrc
```

The most important separation is:

```text
10-path.sh          PATH only
20-aliases.sh       simple aliases
30-functions.sh     reusable shell functions
40-development.sh   generic dev environment
50-docker.sh        Docker tooling
60-rust.sh          Rust/Cargo
70-node.sh          Node/NVM/PNPM
90-local.sh         machine-specific overrides
```

This avoids the common problem where `.bashrc` becomes a large, order-dependent file that is difficult to debug.
