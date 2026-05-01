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
bash install.sh --build-neovim
```

This installs the core Neovim dependencies plus common language-server prerequisites:

- `git`, `fzf`, `ripgrep`, `fd`
- `node`, `npm`
- `python`, `pipx`
- `go`
- `cargo`/Rust tooling

### 2. **Add this to your shell config (e.g. `~/.bashrc`)**

```bash
export PATH="$HOME/dotfiles/bin:$PATH"
source "$HOME/dotfiles/scripts/aliases.sh"
```

## Scripts

- `install.sh` installs dependencies, stows packages, and verifies the install.
- `scripts/install-deps.sh` installs dependencies on macOS or Debian/Ubuntu.
- `scripts/build-neovim.sh` builds Neovim from source.
- `scripts/aliases.sh` contains shell aliases.

## Neovim

Neovim doesn't install LSPs, you can install them via:

```bash
sudo apt install -y lua-language-server rust-analyzer
npm install -g vtsls typescript typescript-language-server @tailwindcss/language-server vscode-langservers-extracted yaml-language-server
pipx install basedpyright
go install golang.org/x/tools/gopls@latest
```

Replace `apt` with `brew` on macOS.

## License

MIT License.
