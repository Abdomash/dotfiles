# dotfiles

This is my personal dotfiles repository. It contains neovim config and various useful terminal utils.

## Content


Simple symlink-based dotfiles with Stow.

- `nvim/` -> Neovim config (stow package)
- `tmux/` -> tmux config (stow package)
- `alacritty/` -> Alacritty config (stow package)
- `bin/` -> executables on PATH
- `opencode/` -> personal OpenCode config (stow package)
- `scripts/` -> setup/build scripts

## Install

1. Install Homebrew on MacOS

```/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"```

2. Install dependencies and stow packages:

```bash
git clone git@github.com:Abdomash/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"
bash install.sh
```

3. Build or install Neovim:

```bash scripts/build-neovim.sh```

or

```sudo apt install -y neovim```


4. Add this to your shell config (e.g. `~/.bashrc` or `~/.zshrc`):

```bash
export PATH="$HOME/bin:$PATH"
source "$HOME/dotfiles/scripts/aliases.sh"
```

## Manual Stow

If you already ran `install.sh` and just want to re-symlink after adding or moving files:

```bash
stow -R --dir . --target ~ nvim tmux bin alacritty opencode
```
