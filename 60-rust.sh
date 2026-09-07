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
