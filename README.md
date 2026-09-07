# Modular Bash Configuration

This directory contains modular Bash configuration files loaded automatically from `~/.bashrc`.

## Structure

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

## Purpose

* `10-path.sh` — PATH configuration
* `20-aliases.sh` — shell aliases
* `30-functions.sh` — reusable Bash functions
* `40-development.sh` — general development environment
* `50-docker.sh` — Docker and Compose helpers
* `60-rust.sh` — Rust and Cargo configuration
* `70-node.sh` — Node.js, NVM, and PNPM configuration
* `90-local.sh` — machine-specific overrides

Files are loaded in lexical order, so numeric prefixes control initialization order.

## Loader

Add the following to `~/.bashrc`:

```bash
if [[ -d "$HOME/.bashrc.d" ]]; then
    shopt -s nullglob

    for file in "$HOME"/.bashrc.d/*.sh; do
        source "$file"
    done

    shopt -u nullglob
    unset file
fi
```

## Validate

Before reloading:

```bash
bash -n ~/.bashrc

for file in ~/.bashrc.d/*.sh; do
    bash -n "$file" || break
done
```

Reload the shell configuration:

```bash
source ~/.bashrc
```

## Local Configuration

Keep machine-specific settings in:

```text
90-local.sh
```

If this directory is version-controlled, exclude local or secret files:

```gitignore
90-local.sh
*.local.sh
*.secret.sh
```

Do not store API keys, passwords, or other secrets directly in committed shell configuration files.
