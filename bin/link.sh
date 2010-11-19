#!/bin/sh

LN='ln -fhsv'

# Git
$LN $HOME/.dotfiles/.gitconfig $HOME/.gitconfig

# Vim
$LN $HOME/.dotfiles/.vim $HOME/.vim
$LN $HOME/.dotfiles/.vimrc $HOME/.vimrc
