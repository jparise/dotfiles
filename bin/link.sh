#!/bin/sh

LN='ln -fhsv'

# Vim
$LN $HOME/.dotfiles/vim $HOME/.vim
$LN $HOME/.dotfiles/vim/vimrc $HOME/.vimrc
