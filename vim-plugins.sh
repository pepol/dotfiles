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

#install_plugin "fugitive" "https://tpope.io/vim/fugitive.git"
#install_plugin "surround" "https://tpope.io/vim/surround.git"
##install_plugin "symlink" "https://github.com/aymericbeaumet/vim-symlink.git"  ## Causes issues with autocmd nesting
#install_plugin "bbye" "https://github.com/moll/vim-bbye.git"
#install_plugin "nerdtree" "https://github.com/preservim/nerdtree.git"
#install_plugin "devicons" "https://github.com/ryanoasis/vim-devicons.git"
#install_plugin "gitgutter" "https://github.com/airblade/vim-gitgutter.git"
install_plugin "ctrlp" "https://github.com/ctrlpvim/ctrlp.vim.git"
#install_plugin "nrrwrgn" "https://github.com/chrisbra/NrrwRgn.git"
#install_plugin "sort-motion" "https://github.com/christoomey/vim-sort-motion.git"
install_plugin "ale" "https://github.com/dense-analysis/ale.git"
#install_plugin "markdown-runner" "https://github.com/dbridges/vim-markdown-runner.git"
#install_plugin "tagbar" "https://github.com/preservim/tagbar.git"
#install_plugin "peekaboo" "https://github.com/junegunn/vim-peekaboo.git"
#install_plugin "taboo" "https://github.com/gcmt/taboo.vim.git"
#
#install_plugin "textobj-user" "https://github.com/kana/vim-textobj-user.git"
#install_plugin "textobj-indent" "https://github.com/kana/vim-textobj-indent.git"
#
#install_plugin "vlime" "https://github.com/vlime/vlime.git"
