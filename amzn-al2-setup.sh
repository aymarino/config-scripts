
function exists() {
  command -v "$1" &> /dev/null
}

function yum_install() {
  if ! exists $1 ; then
    sudo yum install $1
  fi
}

yum_install jq

sh ./git-setup.sh
