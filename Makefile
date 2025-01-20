TARGETS = install-bash \
		  install-bat \
		  install-ctags \
		  install-direnv \
		  install-ghostty \
		  install-git \
		  install-pip \
		  install-vim \
		  install-wezterm

.PHONY: install $(TARGETS)

install: $(TARGETS)

install-bash:
	rm -f ~/.bash_profile ~/.bashrc ~/.inputrc
	ln -s `pwd`/bash/.bash_profile ~/.bash_profile
	ln -s `pwd`/bash/.bashrc ~/.bashrc
	ln -s `pwd`/bash/.inputrc ~/.inputrc

install-bat: ~/.config
	rm -f ~/.config/bat
	ln -s `pwd`/bat ~/.config/bat

install-ctags: ~/.config
	rm -f ~/.config/ctags
	ln -s `pwd`/ctags ~/.config/ctags

install-direnv: ~/.config
	rm -f ~/.config/direnv
	ln -s `pwd`/direnv ~/.config/direnv

install-ghostty: ~/.config
	rm -f ~/.config/ghostty
	ln -s `pwd`/ghostty ~/.config/ghostty

install-git: ~/.config
	rm -f ~/.config/git
	ln -s `pwd`/git ~/.config/git

install-pip: ~/.config
	rm -rf ~/.config/pip
	ln -s `pwd`/pip ~/.config/pip

install-vim: ~/.config vim/autoload/plug.vim
	rm -rf ~/.vim ~/.vimrc ~/.config/nvim
	ln -s `pwd`/vim ~/.vim
	ln -s `pwd`/vim/vimrc ~/.vimrc
	ln -s `pwd`/vim ~/.config/nvim
	mkdir -p ~/.cache/vim

install-wezterm: ~/.config
	rm -f ~/.config/wezterm
	ln -s `pwd`/wezterm ~/.config/wezterm

~/.config:
	mkdir -p ~/.config

vim/autoload/plug.vim:
	curl -fLo `pwd`/vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
