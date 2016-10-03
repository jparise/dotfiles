# Dotfiles

This repository contains my public [dotfiles](https://dotfiles.github.io/).
Feel free to borrow anything you like.

Installation is handled by the included Makefile. `make install` should take
care of everything, but note that any existing configuration files will be
removed _without_ making backup copies.

## bash

Local settings can be placed in a file named `$HOME/.bashrc.local`.

## tcsh

Local settings can be placed in a file named `$HOME/.cshrc.local`.

## vim

[vim-plug](https://github.com/junegunn/vim-plug) is used for plugin
management. There is a Makefile rule that downloads `autoload/plug.vim` to
bootstrap the system. You'll need to run `:PlugInstall` to install the
individual plugins themselves.

On Mac OS X, the patched [Powerline fonts][] are assumed to be available.
This lets us enabled [vim-airline][]'s support for [Powerline][] symbols.
In particular, we use [Menlo for Powerline][] in GUI mode if available.

[Menlo for Powerline]: https://github.com/abertsch/Menlo-for-Powerline
[vim-airline]: https://github.com/vim-airline/vim-airline
[Powerline]: https://github.com/powerline/powerline
[Powerline fonts]: https://github.com/powerline/fonts
