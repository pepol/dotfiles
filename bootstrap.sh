#!/bin/sh

PROG=$0
CONFDIRBASE=`dirname $PROG`
WORKDIR=`pwd`
CONFDIR=$WORKDIR/$CONFDIRBASE

mkdir -p ~/.backup-configs

# Vim
[[ -f ~/.vimrc ]] && mv ~/.vimrc ~/.backup-configs/vimrc
ln -s $CONFDIR/vimrc ~/.vimrc

# Git
[[ -f ~/.gitconfig ]] && mv ~/.gitconfig ~/.backup-configs/gitconfig
ln -s $CONFDIR/gitconfig ~/.gitconfig

# Tmux
[[ -f ~/.tmux.conf ]] && mv ~/.tmux.conf ~/.backup-configs/tmux.conf
ln -s $CONFDIR/tmux.conf ~/.tmux.conf

# ZSH
[[ -f ~/.zshrc ]] && mv ~/.zshrc ~/.backup-configs/zshrc
ln -s $CONFDIR/zshrc ~/.zshrc

# SSH
mkdir -p ~/.ssh && chmod 700 ~/.ssh
[[ -f ~/.ssh/config ]] && mv ~/.ssh/config ~/.backup-configs/ssh_config
ln -s $CONFDIR/ssh_config ~/.ssh/config

# Emacs
mkdir -p ~/.emacs.d
[[ -f ~/.emacs.d/early-init.el ]] && mv ~/.emacs.d/early-init.el ~/.backup-configs/emacs-early-init.el
ln -s $CONFDIR/emacs/early-init.el ~/.emacs.d/early-init.el
[[ -f ~/.emacs.d/init.el ]] && mv ~/.emacs.d/init.el ~/.backup-configs/emacs-init.el
ln -s $CONFDIR/emacs/init.el ~/.emacs.d/init.el
