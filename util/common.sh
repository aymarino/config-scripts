# Common utility functions used by setup scripts

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
