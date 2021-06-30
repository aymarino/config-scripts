#!/bin/bash

# Ensure we're in the same dir as the script, since some relative paths are used.
cd $(dirname "$0")

RC_FILES="$HOME/.bashrc"
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

function apt_installed() {
  echo "Checking if package '$1' is installed..."
  dpkg -s $1 &> /dev/null
}

function apt_install() {
  if ! apt_installed $1 ; then
    echo "Installing package '$1' through apt..."
    sudo apt-get update
    sudo apt-get install $1 -y
  fi
}

ensure_exists git
sh ./git-setup.sh

# Essentials
apt_install build-essential

# Python environment. Both pipenv and pyenv have a weird, '.bashrc'-hacky installation.
apt_install python3
apt_install python3-pip
apt_install libssl-dev # Required by pyenv

if ! exists pipenv ; then
  pip install pipenv
  # 'pipenv' is install in user ~/.local/bin, which may not be sourced in .bashrc
  add_to_rc pipenv.sh
  ensure_exists pipenv
fi

if ! exists pyenv ; then
  rm -rf ~/.pyenv
  curl https://pyenv.run | bash
  add_to_rc pyenv.sh
  ensure_exists pyenv
fi

# Utilities
apt_install ripgrep
apt_install unzip
apt_install fzf
add_to_rc fzf.sh

# AWS CLI 2
if ! exists aws ; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install

  ensure_exists aws

  # Clean up
  rm awscliv2.zip
  rm -rf aws
fi

# Elastic Beanstalk CLI
if ! exists eb ; then
  pip install awsebcli
  ensure_exists eb
fi

# Jekyll
apt_install ruby-full
apt_install zlib1g-dev
if ! exists jekyll ; then
  sudo gem install jekyll bundler
  ensure_exists jekyll
fi
