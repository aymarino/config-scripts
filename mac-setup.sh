#!/bin/bash

# Ensure we're in the same dir as the script, since some relative paths are used.
cd $(dirname "$0")

source util/common.sh

RC_FILES="$HOME/.bashrc $HOME/.zshrc" # Set .rc files for both ZSH and Bash shell
source util/rc-setup.sh

function brew_installed() {
  echo "Checking if package '$1' is installed by brew..."
  brew list | grep --word-regexp --fixed-strings "$1" &> /dev/null
}

function brew_install() {
  if ! brew_installed $1 ; then
    echo "Installing '$1' with brew..."
    brew install $1
    return 0
  else
    return 1
  fi
}

function brew_install_login_app() {
  if ! brew_installed $1 ; then
    brew install --cask $1
    echo "Open $1 and enable 'Start at login' in preferences ..."
    read -p "Press enter to continue"
  fi
}

ensure_exists git
sh ./util/git-setup.sh

# Install Homebrew & packages
if ! exists brew ; then
  echo "'brew' not found; installing ..."
  # From official site: brew.sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$USER/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
  ensure_exists brew
fi

# Rust
ensure_exists cargo # Install rustup: https://www.rust-lang.org/tools/install
cargo install ripgrep
cargo install bat

## Utilities ##

brew_install_login_app mos # reverse scroll wheel direction
brew_install_login_app rectangle # gives Windows-style max/half screen shortcuts
brew_install_login_app maccy # Gives clipboard history
brew_install_login_app notunes
brew_install visual-studio-code
brew_install jq
brew_install fd
brew_install tree
brew_install tmux
brew_install alacritty
brew_install neovim
if brew_install fish ; then
  echo "--- Set fish to default shell:"
  echo "  add $(which fish) to /etc/shells"
  echo "  chsh -s $(which fish)"
  echo "and restart"
  exit 1
fi
if brew_install fzf ; then
  echo "Installing fzf key bindings and ** shell command completions"
  $(brew --prefix)/opt/fzf/install
fi

if ! exists aws ; then
  brew install awscli # AWS CLI version 2
fi

# Install python & pip
if ! exists python3 ; then
  brew_install python3
fi
ensure_exists pip3

# Utilities used for `update-vscode-settings` util
pip3 install pyyaml
pip3 install json5

# 'ssh-config' used by start-ec2-dev script
if ! exists ssh-config ; then
  pip3 install ssh-config
fi

## MacOS defaults ##

# TextEdit:
#  - create untitled document at lauch
#  - use plain text mode as default
defaults write com.apple.TextEdit NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false
defaults write com.apple.TextEdit RichText -int 0

# Dock:
#  - enable autohide
#  - set AppSwitcher to show up on all displays
if [[ $(defaults read com.apple.Dock appswitcher-all-displays) == "0" ]]; then
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.Dock appswitcher-all-displays -bool true
  killall Dock
fi

# Finder:
#  - show file extensions
defaults write -g AppleShowAllExtensions -bool true

## Shell scripts ##

# Add scripts to $HOME bin directory
add_script_to_bin start-ec2-dev
add_script_to_bin frg

# Add ~/.scripts-bin to bash PATH
add_to_rc 01-scripts-bin.sh

## Config files ##

PLUG_SRC="${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim
if ! test -f ${PLUG_SRC}; then
  echo "Installing Plug for neovim"
  curl -fLo ${PLUG_SRC} --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Copy conf files
cp conf/.tmux.conf $HOME
cp conf/.alacritty.toml $HOME
cp conf/config.fish $HOME/.config/fish
cp conf/init.vim $HOME/.config/nvim
