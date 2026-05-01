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


3. Add this to your shell config:

```bash
export PATH="$HOME/bin:$PATH"
source "$HOME/dotfiles/scripts/aliases.sh"
```

### Installed dependencies

`install.sh` installs all deps by default, separated into groups:

- `CORE_DEPS`: shell tools and utils
    `git`, `stow`, `tmux`, `fzf`, `ripgrep`, etc.
- `NVIM_LSP_DEPS`: Neovim LSP deps
    `node`, `python`, `go`, `lua-language-server`, etc.
- `NVIM_BUILD_DEPS`: deps to build Neovim from source
    `cmake`, `ninja`, `gettext`, `gcc`, etc.

You can comment out any of these groups in `install.sh` if you don't want them.
