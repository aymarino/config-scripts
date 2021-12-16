#!/bin/bash

# Ensure we're in the same dir as the script, since some relative paths are used.
cd $(dirname "$0")

RC_FILES="$HOME/.bashrc $HOME/.zshrc" # Set .rc files for both ZSH and Bash shell
source rc-setup.sh

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
  fi
}

ensure_exists git
sh ./git-setup.sh

# Install Homebrew & packages
if ! exists brew ; then
  echo "'brew' not found; installing ..."
  # From official site: brew.sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Utilities
brew_install mos # reverse scroll wheel direction
brew_install rectangle # gives Windows-style max/half screen shortcuts
brew_install maccy # Gives clipboard history
brew_install jq
if ! exists fzf ; then
  brew_install fzf
  $(brew --prefix)/opt/fzf/install # Installs key bindings and `**` command completion
fi

if ! exists aws ; then
  brew install awscli # AWS CLI version 2
fi

# Install python & pip
if ! exists python3 ; then
  brew_install python3
fi
ensure_exists pip3

# 'ssh-config' used by start-ec2-dev script
if ! exists ssh-config ; then
  pip3 install ssh-config
fi

# Add scripts to bin
add_script_to_bin start-ec2-dev
add_script_to_bin open-vscode-remote

# Add ~/.scripts-bin to PATH
add_to_rc scripts-bin.sh
