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
