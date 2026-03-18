#!/usr/bin/env bash
# setup.sh — install dotfiles by creating symlinks following XDG standard.
# Usage:
#   ./setup.sh                  # interactive: prompts for each tool
#   ./setup.sh vim tmux git     # non-interactive: set up only specified tools
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# ---------------------------------------------------------------------------
# Colors (only when connected to a terminal)
# ---------------------------------------------------------------------------
if [ -t 1 ]; then
    COLOR_RED='\033[31;1m'
    COLOR_GREEN='\033[32;1m'
    COLOR_YELLOW='\033[33;1m'
    COLOR_CYAN='\033[36;1m'
    COLOR_RESET='\033[0m'
else
    COLOR_RED='' COLOR_GREEN='' COLOR_YELLOW='' COLOR_CYAN='' COLOR_RESET=''
fi

info()    { printf "${COLOR_GREEN}[INFO]${COLOR_RESET}  %s\n" "$*"; }
warn()    { printf "${COLOR_YELLOW}[WARN]${COLOR_RESET}  %s\n" "$*"; }
error()   { printf "${COLOR_RED}[ERROR]${COLOR_RESET} %s\n" "$*"; }
success() { printf "${COLOR_CYAN}[OK]${COLOR_RESET}    %s\n" "$*"; }

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# Rename an existing path to <path>.old and print a warning.
backup_if_needed() {
    local target="$1"
    # Nothing there → nothing to do
    [ -e "$target" ] || [ -L "$target" ] || return 0
    # Already one of our own symlinks → skip
    if [ -L "$target" ]; then
        local dest
        dest="$(readlink "$target")"
        [[ "$dest" == "$DOTFILES_DIR"* ]] && return 0
    fi
    local backup="${target}.$(date +%Y%m%d_%H%M%S).old"
    warn "Found existing ${target} — renaming to ${backup}"
    mv "$target" "$backup"
}

# Copy file $1 to $2, creating parent directories as needed.
# Returns 0 if copied, 1 if target already exists (skipped).
make_copy() {
    local source="$1"
    local target="$2"
    if [ -e "$target" ]; then
        info "$target already exists — skipping."
        return 1
    fi
    mkdir -p "$(dirname "$target")"
    cp "$source" "$target"
    success "Copied to $target from $source"
}

# Create a symlink: $2 -> $1  (source is inside this repo)
make_link() {
    local source="$1"
    local target="$2"
    backup_if_needed "$target"
    mkdir -p "$(dirname "$target")"
    ln -sf "$source" "$target"
    success "Linked $target -> $source"
}

# Returns 0 if version $1 >= $2 (both in X.Y[.Z] form)
version_ge() {
    printf '%s\n%s\n' "$2" "$1" | sort -V -C
}

# Prints the current platform: mac, linux, or win
detect_platform() {
    local platform
    case "$(uname -s)" in
        Darwin)                platform="mac"   ;;
        Linux)                 platform="linux" ;;
        MINGW*|CYGWIN*|MSYS*)  platform="win"   ;;
        *)                     warn "Unknown platform '$(uname -s)' — assuming linux." ; platform="linux" ;;
    esac
    echo "$platform"
}

# ---------------------------------------------------------------------------
# Per-tool setup functions
# ---------------------------------------------------------------------------

setup_git() {
    if ! command -v git >/dev/null 2>&1; then
        warn "git not found — skipping."
        return
    fi
    local ver platform
    ver="$(git --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')"
    platform="$(detect_platform)"
    info "git $ver"
    info "Setting up git in ${XDG_CONFIG_HOME}/git/"
    backup_if_needed "${HOME}/.gitconfig"
    backup_if_needed "${HOME}/.gitignore_global"
    make_link "${DOTFILES_DIR}/git/config" "${XDG_CONFIG_HOME}/git/config"
    make_link "${DOTFILES_DIR}/git/ignore" "${XDG_CONFIG_HOME}/git/ignore"
    make_link "${DOTFILES_DIR}/git/config.platform.${platform}" "${XDG_CONFIG_HOME}/git/config.platform"

    local local_config="${XDG_CONFIG_HOME}/git/config.local"
    if make_copy "${DOTFILES_DIR}/git/config.local.template" "$local_config"; then
        info "Add your local settings to ${local_config}."
    fi
}

install_tpm() {
    local tpm_dir="$1/plugins/tpm"
    if ! command -v git >/dev/null 2>&1; then
        warn "git not available — TPM not installed. Clone manually:"
        warn "  git clone https://github.com/tmux-plugins/tpm $tpm_dir"
        return
    fi
    if [ ! -d "$tpm_dir" ]; then
        info "Cloning TPM into $tpm_dir..."
        git clone --depth=1 https://github.com/tmux-plugins/tpm "$tpm_dir"
    fi
    info "Installing tmux plugins..."
    tmux start-server \; set-environment -g TMUX_PLUGIN_MANAGER_PATH "$1/plugins/"
    if "$tpm_dir/bin/install_plugins"; then
        success "Tmux plugins installed."
    else
        warn "Tmux plugin installation failed — run prefix+I inside tmux to retry."
    fi
}

setup_tmux() {
    if ! command -v tmux >/dev/null 2>&1; then
        warn "tmux not found — skipping."
        return
    fi
    local ver
    ver="$(tmux -V | grep -oE '[0-9]+\.[0-9]+([a-z]?)' | head -1)"
    info "tmux $ver"
    if version_ge "$ver" "3.2"; then
        info "Setting up tmux in ${XDG_CONFIG_HOME}/tmux/"
        backup_if_needed "${HOME}/.tmux.conf"
        backup_if_needed "${HOME}/.tmux"
        make_link "${DOTFILES_DIR}/tmux/tmux.conf" "${XDG_CONFIG_HOME}/tmux/tmux.conf"
        install_tpm "${XDG_CONFIG_HOME}/tmux"
    else
        warn "tmux $ver is too old (XDG and #{current_file} require >= 3.2) — skipping."
    fi
}

install_vim_plug() {
    local vimrc="$1"
    info "Installing vim plugins..."
    vim -es -u "$vimrc" -i NONE -c "PlugInstall" -c "qa!" || true
    success "Vim plugins installed."
}

setup_vim() {
    if ! command -v vim >/dev/null 2>&1; then
        warn "vim not found — skipping."
        return
    fi
    local ver xdg_support
    ver="$(vim --version | head -1 | grep -oE '[0-9]+\.[0-9]+')"
    xdg_support="$(vim --clean -es +':exec "! echo" has("patch-9.1.0327")' +:q 2>/dev/null)"
    info "vim $ver"
    local vim_dir vimrc
    if [ "$xdg_support" = "1" ]; then
        info "Setting up vim in ${XDG_CONFIG_HOME}/vim/"
        backup_if_needed "${HOME}/.vimrc"
        backup_if_needed "${HOME}/.vim"
        backup_if_needed "${HOME}/.viminfo"
        vim_dir="${XDG_CONFIG_HOME}/vim"
        vimrc="${XDG_CONFIG_HOME}/vim/vimrc"
    else
        warn "patch 9.1.0327 not present — linking to ~/.vimrc"
        vim_dir="${HOME}/.vim"
        vimrc="${HOME}/.vimrc"
    fi
    make_link "${DOTFILES_DIR}/vim/vimrc" "$vimrc"
    for f in "${DOTFILES_DIR}/vim/skeletons/"*; do
        make_copy "$f" "${vim_dir}/skeletons/$(basename "$f")" || true
    done
    install_vim_plug "$vimrc"
}

setup_zsh() {
    if ! command -v zsh >/dev/null 2>&1; then
        warn "zsh not found — skipping."
        return
    fi
    local ver
    ver="$(zsh --version | grep -oE '[0-9]+\.[0-9]+')"
    info "zsh $ver"
    make_link "${DOTFILES_DIR}/zsh/zshrc" "${HOME}/.zshrc"
}

setup_bash() {
    local ver platform
    ver="$(bash --version | head -1 | grep -oE '[0-9]+\.[0-9]+')"
    platform="$(detect_platform)"
    info "bash $ver"
    [ "$platform" = "mac" ] && make_link "${DOTFILES_DIR}/bash/bash_profile" "${HOME}/.bash_profile"
    make_link "${DOTFILES_DIR}/bash/bashrc.${platform}" "${HOME}/.bashrc"
}

setup_screen() {
    if ! command -v screen >/dev/null 2>&1; then
        warn "screen not found — skipping."
        return
    fi
    local ver
    ver="$(screen --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' | head -1)"
    info "screen $ver"
    make_link "${DOTFILES_DIR}/screen/screenrc" "${HOME}/.screenrc"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

ALL_TOOLS=(git tmux vim zsh bash screen)
TOOLS_TO_SETUP=()

if [ $# -gt 0 ]; then
    # Non-interactive: tools given on command line
    TOOLS_TO_SETUP=("$@")
else
    # Interactive: ask for each tool
    echo ""
    info "Interactive setup. Choose which tools to configure."
    echo ""
    for tool in "${ALL_TOOLS[@]}"; do
        printf "${COLOR_GREEN}  Setup %-8s? [y/N] ${COLOR_RESET}" "$tool"
        read -r -n 1 reply
        echo
        [[ "$reply" =~ ^[Yy]$ ]] && TOOLS_TO_SETUP+=("$tool")
    done
    echo ""
fi

for tool in "${TOOLS_TO_SETUP[@]}"; do
    echo ""
    info "--- $tool ---"
    case "$tool" in
        git)    setup_git    ;;
        tmux)   setup_tmux   ;;
        vim)    setup_vim    ;;
        zsh)    setup_zsh    ;;
        bash)   setup_bash   ;;
        screen) setup_screen ;;
        *)      warn "Unknown tool '${tool}' — skipping." ;;
    esac
done

echo ""
info "Done."
