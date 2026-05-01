#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_PACKAGES=(nvim tmux bin alacritty opencode)

if [[ $# -ne 0 ]]; then
  echo "Usage: install.sh"
  exit 1
fi

install_deps() {
  local os_name
  os_name="$(uname -s)"

  if [[ "$os_name" == "Darwin" ]]; then
    local -a CORE_DEPS=(stow fzf fd ripgrep git tmux wget gnu-tar node python go)
    # Comment out NVIM_BUILD_DEPS if you do not build Neovim from source.
    local -a NVIM_BUILD_DEPS=(cmake ninja gettext)

    if ! xcode-select -p >/dev/null 2>&1; then
      xcode-select --install
      echo "Xcode CLI tools installation started. Re-run after it finishes."
      exit 1
    fi

    if ! command -v brew >/dev/null 2>&1; then
      echo "Homebrew not found. Install it first: https://brew.sh"
      exit 1
    fi

    brew install "${CORE_DEPS[@]}" "${NVIM_BUILD_DEPS[@]-}"
    return
  fi

  if [[ "$os_name" == "Linux" && -f /etc/debian_version ]]; then
    local -a CORE_DEPS=(git xclip stow fzf fd-find ripgrep tmux curl unzip tar gzip nodejs npm python3 golang-go)
    # Comment out NVIM_BUILD_DEPS if you do not build Neovim from source.
    local -a NVIM_BUILD_DEPS=(make gcc unzip cmake ninja-build gettext curl build-essential)

    sudo apt update
    sudo apt install -y "${CORE_DEPS[@]}" "${NVIM_BUILD_DEPS[@]-}"
    return
  fi

  echo "Unsupported OS. This script supports macOS and Debian/Ubuntu."
  exit 1
}

stow_packages() {
  local -a succeeded=()
  local -a failed=()
  local pkg

  for pkg in "${STOW_PACKAGES[@]}"; do
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
