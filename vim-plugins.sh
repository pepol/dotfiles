#!/bin/bash

PLUGIN_DIRECTORY=~/.vim/pack/pepol/start

install_plugin() {
  plugin_name=$1
  plugin_repository=$2

  if [[ ! -d $PLUGIN_DIRECTORY/$plugin_name ]]; then
    git clone $plugin_repository $PLUGIN_DIRECTORY/$plugin_name
    echo "Plugin $plugin_name successfully installed into $PLUGIN_DIRECTORY"
  else
    echo "Plugin $plugin_name already installed"
  fi
  vim -u NONE -c "helptags $PLUGIN_DIRECTORY/$plugin_name/doc" -c q
}

# main
mkdir -p $PLUGIN_DIRECTORY

install_plugin "devicons" "https://github.com/ryanoasis/vim-devicons.git"
install_plugin "gitgutter" "https://github.com/airblade/vim-gitgutter.git"
install_plugin "ctrlp" "https://github.com/ctrlpvim/ctrlp.vim.git"
install_plugin "nrrwrgn" "https://github.com/chrisbra/NrrwRgn.git"
install_plugin "ale" "https://github.com/dense-analysis/ale.git"
install_plugin "peekaboo" "https://github.com/junegunn/vim-peekaboo.git"
install_plugin "cue" "https://github.com/jjo/vim-cue.git"
install_plugin "jsonnet" "https://github.com/google/vim-jsonnet.git"
install_plugin "yats" "https://github.com/HerringtonDarkholme/yats.vim.git"

#install_plugin "markdown-runner" "https://github.com/dbridges/vim-markdown-runner.git"
#install_plugin "fugitive" "https://tpope.io/vim/fugitive.git"
#install_plugin "surround" "https://tpope.io/vim/surround.git"
