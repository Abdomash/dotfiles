#!/usr/bin/env bash
# Install system dependencies and stow dotfiles.
# Supports macOS (via Homebrew) and Debian/Ubuntu (apt).

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_PACKAGES=(nvim tmux bin alacritty opencode)

# ==========================================
# DEPENDENCIES
# ==========================================

# Shared utils
SHARED_CORE_DEPS=(git stow fzf ripgrep tmux tree-sitter-cli)

# Core utils
MACOS_CORE_DEPS=(fd node python go wget gnu-tar)
DEBIAN_CORE_DEPS=(fd-find nodejs npm python3 golang-go curl unzip tar gzip xclip)

# Neovim build dependencies (comment out if you don't need to build Neovim)
MACOS_BUILD_DEPS=(cmake ninja gettext)
DEBIAN_BUILD_DEPS=(make gcc cmake ninja-build gettext build-essential)

# ==========================================

# --- Install dependencies ---

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

  brew install "${SHARED_CORE_DEPS[@]}" "${MACOS_CORE_DEPS[@]}" "${MACOS_BUILD_DEPS[@]-}"

elif [[ "$os_name" == "Linux" ]]; then
  if [[ ! -f /etc/debian_version ]]; then
    echo "Unsupported Linux. This script supports Debian/Ubuntu."
    exit 1
  fi

  sudo apt update
  sudo apt install -y "${SHARED_CORE_DEPS[@]}" "${DEBIAN_CORE_DEPS[@]}" "${DEBIAN_BUILD_DEPS[@]-}"

else
  echo "Unsupported OS. This script supports macOS and Debian/Ubuntu."
  exit 1
fi

# --- Stow dotfiles ---

stow_exit_code=0

for pkg in "${STOW_PACKAGES[@]}"; do
  if stow --dir "$ROOT_DIR" --target "$HOME" "$pkg"; then
    echo "  [OK] $pkg"
  else
    echo "  [FAIL] $pkg"
    stow_exit_code=1
  fi
done

exit "$stow_exit_code"
