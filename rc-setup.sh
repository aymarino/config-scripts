function source_rc_dir() {
  if [ ! -f $1 ]; then
    echo "$1 does not exist, skipping append..."
    return 0 # File does not exist
  fi

  rc_source_file="./rc-scripts/source-rc.sh"
  header=$(head -n 1 $rc_source_file)
  if ! grep -qxF "$header" $1 &> /dev/null ; then
    echo "Appending contents of '$rc_source_file' onto '$1'..."
    cat $rc_source_file >> $1
  fi

  if [[ ! $1 =~ "zsh" ]]; then
    echo "Sourcing '$1'..."
    source $1
  fi
}

function source_rcs() {
  for rc in $RC_FILES; do
    echo "Checking if we need to source '$RC_DIR' in '$rc'..."
    source_rc_dir $rc
  done
}

function add_to_rc() {
  RC_DIR=~/.scripts-rc
  echo "Copying '$1' to '$RC_DIR'..."
  mkdir -p $RC_DIR # '-p': ignore if already exists
  cp ./rc-scripts/$1 $RC_DIR

  source_rcs
}

function add_script_to_bin() {
  BIN_DIR=~/.scripts-bin
  echo "Adding '$1' to '$BIN_DIR'..."
  mkdir -p $BIN_DIR
  cp bin/$1 $BIN_DIR
}
