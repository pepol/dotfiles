#!/bin/bash

PLUGIN_DIRECTORY=~/.vim/pack/pepol/start

install_plugin() {
  plugin_name=$1
  plugin_repository=$2

  if [[ ! -d $PLUGIN_DIRECTORY/$plugin_name ]]; then
    git clone $plugin_repository $PLUGIN_DIRECTORY/$plugin_name
    vim -u NONE -c "helptags $PLUGIN_DIRECTORY/$plugin_name/doc" -c q
    echo "Plugin $plugin_name successfully installed into $PLUGIN_DIRECTORY"
  else
    echo "Plugin $plugin_name already installed"
  fi
}

# main
mkdir -p $PLUGIN_DIRECTORY

install_plugin "fugitive" "https://tpope.io/vim/fugitive.git"
install_plugin "surround" "https://tpope.io/vim/surround.git"
install_plugin "symlink" "https://github.com/aymericbeaumet/vim-symlink.git"
install_plugin "bbye" "https://github.com/moll/vim-bbye.git"
