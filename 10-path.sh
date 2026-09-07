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
