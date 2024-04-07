function add_script_to_bin_as() {
    BIN_DIR=~/.scripts-bin
    echo "Adding '$1' to '$BIN_DIR' as '$2'..."
    mkdir -p $BIN_DIR
    cp bin/$1 $BIN_DIR/$2
}

function add_script_to_bin() {
  add_script_to_bin_as $1 $1
}
