
function exists() {
  command -v "$1" &> /dev/null || \
  ls /Applications/ | grep -i "$1.app" &> /dev/null
}

function brew_install() {
  if ! exists $1 ; then
    brew install $1
  fi
}

# Install Homebrew & packages
if ! exists brew ; then
  echo "'brew' not found; installing ..."
  # From official site: brew.sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew_install mos # reverse scroll wheel direction
brew_install rectangle # gives Windows-style max/half screen shortcuts
brew_install jq

sh ./git-setup.sh
