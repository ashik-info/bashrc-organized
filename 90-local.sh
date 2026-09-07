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
