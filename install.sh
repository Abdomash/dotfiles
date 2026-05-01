#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_NVIM=0

if [[ $# -gt 1 ]]; then
  echo "Usage: install.sh [--build-nvim]"
  exit 1
fi

if [[ $# -eq 1 ]]; then
  if [[ "$1" == "--build-nvim" ]]; then
    BUILD_NVIM=1
  else
    echo "Unknown option: $1"
    echo "Usage: install.sh [--build-nvim]"
    exit 1
  fi
fi

install_deps() {
  if [[ $BUILD_NVIM -eq 1 ]]; then
    INSTALL_NVIM_PACKAGE=0 "${ROOT_DIR}/scripts/install-deps.sh"
    return
  fi

  bash "${ROOT_DIR}/scripts/install-deps.sh"
}

build_neovim() {
  bash "${ROOT_DIR}/scripts/build-neovim.sh"
}

stow_packages() {
  local packages=(nvim tmux wezterm bin alacritty opencode)
  for pkg in "${packages[@]}"; do
    if ! stow --simulate "$pkg" >/dev/null 2>&1; then
      echo "Stow conflict detected for package: $pkg"
      echo "Resolve conflicts and re-run."
      exit 1
    fi
  done

  for pkg in "${packages[@]}"; do
    stow "$pkg"
  done
}

verify_install() {
  local fail=0

  if [[ ! -d "$HOME/.config/nvim" ]]; then
    echo "Missing: $HOME/.config/nvim"
    fail=1
  fi

  if [[ ! -f "$HOME/.tmux.conf" ]]; then
    echo "Missing: $HOME/.tmux.conf"
    fail=1
  fi

  if [[ ! -f "$HOME/.wezterm.lua" ]]; then
    echo "Missing: $HOME/.wezterm.lua"
    fail=1
  fi

  if [[ ! -f "$HOME/.config/alacritty/alacritty.toml" ]]; then
    echo "Missing: $HOME/.config/alacritty/alacritty.toml"
    fail=1
  fi

  # Make these warnings instead of errors since the user may not have all of these installed
  local cmds=(nvim tmux wezterm fzf alacritty)
  for cmd in "${cmds[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo "Warning: $cmd is not installed or not in PATH."
    fi
  done

  if [[ $fail -ne 0 ]]; then
    echo "Verification failed."
    exit 1
  fi

  echo "Install verified."
}

install_deps

if [[ $BUILD_NVIM -eq 1 ]]; then
  build_neovim
fi

stow_packages
verify_install
