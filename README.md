# dotfiles

This is my personal dotfiles repository. It contains neovim config and various useful terminal utils.

## Structure

Simple symlink-based dotfiles with Stow.

- `nvim/` -> Neovim config (stow package)
- `tmux/` -> tmux config (stow package)
- `wezterm/` -> WezTerm config (stow package)
- `alacritty/` -> Alacritty config (stow package)
- `bin/` -> executables on PATH
- `scripts/` -> setup/build scripts

## Usage

> [!WARNING]
> You need `brew` for macOS:
>
> ```bash
> bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
> ```

### 1. **Installation**

```bash
git clone git@github.com:Abdomash/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"
bash install.sh
```

Neovim is separate:
`bash scripts/build-neovim.sh`
`brew install neovim` or `sudo apt install -y neovim`

### 2. **Add this to your shell config (e.g. `~/.bashrc`)**

```bash
export PATH="$HOME/dotfiles/bin:$PATH"
source "$HOME/dotfiles/scripts/aliases.sh"
```

## Scripts

- `install.sh` installs dependencies and stows packages.
- `scripts/build-neovim.sh` builds Neovim from source.
- `scripts/aliases.sh` contains shell aliases.

## License

MIT License.
