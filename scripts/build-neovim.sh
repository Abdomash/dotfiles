#!/usr/bin/env bash

set -euo pipefail

NVIM_VERSION="v0.12.2"
NVIM_SRC_DIR="${HOME}/neovim"
NVIM_REPO_URL="https://github.com/neovim/neovim.git"

if [[ -e "$NVIM_SRC_DIR" && ! -d "$NVIM_SRC_DIR/.git" ]]; then
  echo "$NVIM_SRC_DIR exists but is not a git checkout."
  exit 1
fi

if [[ ! -d "$NVIM_SRC_DIR/.git" ]]; then
  git clone --depth 1 --branch "$NVIM_VERSION" "$NVIM_REPO_URL" "$NVIM_SRC_DIR"
else
  git -C "$NVIM_SRC_DIR" fetch --tags origin
  git -C "$NVIM_SRC_DIR" checkout "$NVIM_VERSION"
fi

make -C "$NVIM_SRC_DIR" distclean || true

git -C "$NVIM_SRC_DIR" checkout "$NVIM_VERSION"
make -C "$NVIM_SRC_DIR" CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make -C "$NVIM_SRC_DIR" install
