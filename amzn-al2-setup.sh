#!/bin/bash

# Ensure we're in the same dir as the script, since some relative paths are used.
cd $(dirname "$0")

source util/common.sh

RC_FILES="$HOME/.bashrc $HOME/.zshrc" # Set .rc files for both ZSH and Bash shell
source util/rc-setup.sh

function yum_install() {
  if ! exists $1 ; then
    sudo yum install $1
  fi
}

# Install utilities
yum_install jq

if ! exists fzf ; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

# Setup git config
ensure_exists git
sh ./util/git-setup.sh

# Add scripts to bin
add_script_to_bin git-repo-setup
add_script_to_bin_as auth-dev auth
add_script_to_bin set-ra-path

# Add ~/.scripts-bin to PATH
add_to_rc 01-scripts-bin.sh
