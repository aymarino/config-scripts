#!/bin/bash

# Ensure we're in the same dir as the script, since some relative paths are used.
cd $(dirname "$0")

source common.sh

RC_FILES="$HOME/.bashrc $HOME/.zshrc" # Set .rc files for both ZSH and Bash shell
source rc-setup.sh

function yum_install() {
  if ! exists $1 ; then
    sudo yum install $1
  fi
}

# Install utilities
# TODO: install fzf
yum_install jq

# Setup git config
ensure_exists git
sh ./git-setup.sh

# Add scripts to bin
add_script_to_bin git-repo-setup

# Add ~/.scripts-bin to PATH
add_to_rc scripts-bin.sh
