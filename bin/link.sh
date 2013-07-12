#!/bin/sh

LN='ln -fhsv'

# Git
$LN $HOME/.dotfiles/.gitconfig $HOME/.gitconfig

# IPython
$LN $HOME/.dotfiles/.ipython $HOME/.ipython

# LLDB
$LN $HOME/.dotfiles/.lldbinit $HOME/.lldbinit

# Mercurial
$LN $HOME/.dotfiles/.hgrc $HOME/.hgrc

# bash
$LN $HOME/.dotfiles/.inputrc $HOME/.inputrc

# tcsh
$LN $HOME/.dotfiles/.cshrc $HOME/.cshrc
$LN $HOME/.dotfiles/.login $HOME/.login

# Vim
$LN $HOME/.dotfiles/.vim $HOME/.vim
$LN $HOME/.dotfiles/.vimrc $HOME/.vimrc
