
function exists() {
  command -v "$1" &> /dev/null
}

function ensure_exists() {
  if ! exists $1 ; then
    echo "'$1' not found, but was expected to be; exiting"
    exit 1
  fi
}

ensure_exists git
sh ./git-setup.sh

# Python: python3, pip, pipenv, pyenv (?)

if ! exists aws ; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  ensure_exists aws
  rm awscliv2.zip
fi

# Elastic beanstalk CLI
# Jekyll
