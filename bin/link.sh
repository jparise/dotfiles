#!/bin/sh

LN='ln -fhsv'

# Git
$LN $HOME/.dotfiles/.gitconfig $HOME/.gitconfig

# Mercurial
$LN $HOME/.dotfiles/.hgrc $HOME/.hgrc

# Vim
$LN $HOME/.dotfiles/.vim $HOME/.vim
$LN $HOME/.dotfiles/.vimrc $HOME/.vimrc
