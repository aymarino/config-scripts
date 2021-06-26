
# TODO: use 'brew list' instead of grepping through Applications?
function exists() {
  command -v "$1" &> /dev/null || \
  ls /Applications/ | grep -i "$1.app" &> /dev/null
}

function ensure_exists() {
  if ! exists $1 ; then
    echo "'$1' not found, but was expected to be; exiting"
    exit 1
  fi
}

function brew_install() {
  if ! exists $1 ; then
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

brew_install mos # reverse scroll wheel direction
brew_install rectangle # gives Windows-style max/half screen shortcuts
brew_install jq

if ! exists aws ; then
  brew install awscli # AWS CLI version 2
fi

# Install python & pip
brew_install python3
ensure_exists pip3

# 'ssh-config' used by start-ec2-dev script
if ! exists ssh-config ; then
  pip3 install ssh-config
fi

# TODO:
# * Put ./bin in .zshrc & .bashrc idempotently
