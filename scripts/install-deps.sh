#!/usr/bin/env bash

set -euo pipefail

INSTALL_NVIM_PACKAGE="${INSTALL_NVIM_PACKAGE:-1}"

OS_NAME="$(uname -s)"

if [[ "$OS_NAME" == "Darwin" ]]; then
  if ! xcode-select -p >/dev/null 2>&1; then
    xcode-select --install
    echo "Xcode CLI tools installation started. Re-run after it finishes."
    exit 1
  fi

  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Install from https://brew.sh and re-run."
    exit 1
  fi

  brew install stow fzf fd ripgrep cmake ninja gettext git tmux node python pipx go rustup-init
  if [[ "$INSTALL_NVIM_PACKAGE" == "1" ]]; then
    brew install neovim
  fi
  pipx ensurepath
  brew install --cask wezterm
  exit 0
fi

if [[ "$OS_NAME" == "Linux" ]] && [[ -f /etc/debian_version ]]; then
  sudo apt update
  sudo apt install -y make gcc ripgrep unzip git xclip cmake ninja-build gettext curl build-essential stow fzf fd-find tmux nodejs npm python3 python3-pip pipx golang-go cargo
  if [[ "$INSTALL_NVIM_PACKAGE" == "1" ]]; then
    sudo apt install -y neovim
  fi
  pipx ensurepath
  exit 0
fi

echo "Unsupported OS. This script supports macOS and Debian/Ubuntu."
exit 1
