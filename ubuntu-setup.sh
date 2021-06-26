
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
    sudo apt-get install $1
  fi
}

ensure_exists git
sh ./git-setup.sh

# Essentials
apt_install build-essential

# TODO: Python: python3, pip, pipenv, pyenv (?)

# Utilities
apt_install ripgrep

# AWS CLI 2
if ! exists aws ; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  ensure_exists aws
  rm awscliv2.zip
  # rm -rf aws # confirm
fi

# Elastic Beanstalk CLI
if ! exists eb ; then
  pip install awsebcli
fi

# Jekyll
apt_install ruby-full
apt_install zlib1g-dev
if ! exists jekyll ; then
  sudo gem install jekyll bundler
fi
