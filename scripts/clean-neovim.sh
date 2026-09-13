#!/usr/bin/env bash

set -euo pipefail

rm -rf \
  "${XDG_CACHE_HOME:-$HOME/.cache}/nvim" \
  "${XDG_DATA_HOME:-$HOME/.local/share}/nvim" \
  "${XDG_STATE_HOME:-$HOME/.local/state}/nvim" \
  "$HOME/neovim"

echo "Removed Neovim caches, plugins, state, and source."
