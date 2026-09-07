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
