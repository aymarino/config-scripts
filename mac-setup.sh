#!/bin/bash

# Ensure we're in the same dir as the script, since some relative paths are used.
cd $(dirname "$0")

function exists() {
  echo "Checking if command '$1' exists..."
  command -v "$1" &> /dev/null
}

function ensure_exists() {
  if ! exists $1 ; then
    echo "'$1' not found, but was expected to be; exiting"
    exit 1
  fi
}

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
sh ./git-setup.sh

# Install Homebrew & packages
if ! exists brew ; then
  echo "'brew' not found: go to brew.sh and install ... "
  exit 1
fi

## Utilities ##

brew_install_login_app rectangle # gives Windows-style max/half screen shortcuts
brew_install_login_app maccy # Gives clipboard history
brew_install visual-studio-code
brew_install jq
brew_install fd
brew_install ripgrep
brew_install bat
brew_install tree
brew_install neovim
brew_install ghostty
brew_install git-delta

if brew_install fish ; then
  echo "--- Set fish to default shell:"
  echo "  add $(which fish) to /etc/shells"
  echo "  chsh -s $(which fish)"
  echo "and restart"
  exit 1
fi

if brew_install fzf ; then
  echo "Installing fzf key bindings and ** shell command completions"
  echo "Follow link and use instructions in README"
fi

if ! exists aws ; then
  brew install awscli # AWS CLI version 2
fi

# Rust
ensure_exists cargo # Install rustup: https://www.rust-lang.org/tools/install

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

## Custom shell scripts ##

# Add scripts to $HOME bin directory
BIN_DIR=$HOME/.scripts-bin
mkdir $BIN_DIR
cp bin/frg $BIN_DIR

## Config files ##

PLUG_SRC="${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim
if ! test -f ${PLUG_SRC}; then
  echo "Installing Plug for neovim"
  echo "Go to repo and install: https://github.com/junegunn/vim-plug"
fi

# Copy conf files
cp conf/.tmux.conf $HOME
cp conf/.alacritty.toml $HOME
cp conf/config.fish $HOME/.config/fish

mkdir $HOME/.config/nvim
cp conf/init.vim $HOME/.config/nvim # Then must open vim and `:PlugInstall`
