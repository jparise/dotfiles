# Dotfiles

This repository contains my public [dotfiles](https://dotfiles.github.io/).
Feel free to borrow anything you like.

Installation is handled by the included Makefile. `make install` should take
care of everything, but note that any existing configuration files will be
removed _without_ making backup copies.

## atom

Atom packages aren't stored in source control but the set of installed
packages is maintained in `atom/packages.cson` with the help of the [Package
Sync](https://atom.io/packages/package-sync) package.

## bash

Local settings can be placed in a file named `$HOME/.bashrc.local`.

## tcsh

Local settings can be placed in a file named `$HOME/.cshrc.local`.

## vim

[vim-plug](https://github.com/junegunn/vim-plug) is used for plugin
management. There is a Makefile rule that downloads `autoload/plug.vim` to
bootstrap the system. You'll need to run `:PlugInstall` to install the
individual plugins themselves.
