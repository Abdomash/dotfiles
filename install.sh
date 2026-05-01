#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(nvim tmux wezterm bin alacritty opencode)

if [[ $# -ne 0 ]]; then
  echo "Usage: install.sh"
  exit 1
fi

install_deps() {
  local os_name
  os_name="$(uname -s)"

  if [[ "$os_name" == "Darwin" ]]; then
    if ! xcode-select -p >/dev/null 2>&1; then
      xcode-select --install
      echo "Xcode CLI tools installation started. Re-run after it finishes."
      exit 1
    fi

    if ! command -v brew >/dev/null 2>&1; then
      echo "Homebrew not found. Install it first: https://brew.sh"
      exit 1
    fi

    brew install stow fzf fd ripgrep cmake ninja gettext git tmux node python pipx go rustup-init lua-language-server rust-analyzer
    brew install --cask wezterm
    pipx ensurepath
    return
  fi

  if [[ "$os_name" == "Linux" && -f /etc/debian_version ]]; then
    sudo apt update
    sudo apt install -y make gcc ripgrep unzip git xclip cmake ninja-build gettext curl build-essential stow fzf fd-find tmux nodejs npm python3 python3-pip pipx golang-go cargo lua-language-server rust-analyzer
    pipx ensurepath
    return
  fi

  echo "Unsupported OS. This script supports macOS and Debian/Ubuntu."
  exit 1
}

stow_packages() {
  local -a succeeded=()
  local -a failed=()
  local pkg

  for pkg in "${PACKAGES[@]}"; do
    if stow --dir "$ROOT_DIR" --target "$HOME" "$pkg"; then
      succeeded+=("$pkg")
    else
      failed+=("$pkg")
    fi
  done

  echo
  echo "Stow complete."

  if [[ ${#succeeded[@]} -gt 0 ]]; then
    echo "Succeeded: ${succeeded[*]}"
  fi

  if [[ ${#failed[@]} -gt 0 ]]; then
    echo "Failed: ${failed[*]}"
    return 1
  fi
}

install_deps
stow_packages
