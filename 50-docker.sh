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
