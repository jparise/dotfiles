TARGETS = install-bash \
		  install-bat \
		  install-ctags \
		  install-git \
		  install-hg \
		  install-ipython \
		  install-pip \
		  install-proselint \
		  install-tcsh \
		  install-terminfo \
		  install-vim \
		  install-vscode \
		  install-wezterm

TERMINFO_FILES := $(wildcard terminfo/*.ti)
UNAME := $(shell uname -s)

.PHONY: install $(TARGETS) $(TERMINFO_FILES)

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

install-git:
	rm -f ~/.gitconfig ~/.gitignore
	ln -s `pwd`/git/.gitconfig ~/.gitconfig
	ln -s `pwd`/git/.gitignore ~/.gitignore

install-hg:
	rm -f ~/.hgignore ~/.hgrc
	ln -s `pwd`/hg/.hgignore ~/.hgignore
	ln -s `pwd`/hg/.hgrc ~/.hgrc

install-ipython:
	rm -rf ~/.ipython
	ln -s `pwd`/ipython ~/.ipython

install-pip: ~/.config
	rm -rf ~/.config/pip
	ln -s `pwd`/pip ~/.config/pip

install-proselint: ~/.config
	rm -rf ~/.config/proselint
	ln -s `pwd`/proselint ~/.config/proselint

install-tcsh:
	rm -f ~/.cshrc ~/.login
	ln -s `pwd`/tcsh/.cshrc ~/.cshrc
	ln -s `pwd`/tcsh/.login ~/.login

install-terminfo: $(TERMINFO_FILES)

install-vim: ~/.config vim/autoload/plug.vim
	rm -rf ~/.vim ~/.vimrc ~/.config/nvim
	ln -s `pwd`/vim ~/.vim
	ln -s `pwd`/vim/vimrc ~/.vimrc
	ln -s `pwd`/vim ~/.config/nvim
	mkdir -p ~/.cache/vim

install-vscode: ~/.config
ifeq ($(UNAME),Darwin)
	mkdir -p ~/Library/Application\ Support/Code
	rm -rf ~/Library/Application\ Support/Code/User
	ln -s `pwd`/vscode ~/Library/Application\ Support/Code/User
else
	mkdir -p ~/.config/Code
	rm -rf ~/.config/Code/User
	ln -s `pwd`/vscode ~/.config/Code/User
endif

install-wezterm: ~/.config
	rm -f ~/.config/wezterm
	ln -s `pwd`/wezterm ~/.config/wezterm

~/.config:
	mkdir -p ~/.config

$(TERMINFO_FILES):
	tic -o ~/.terminfo $@

vim/autoload/plug.vim:
	curl -fLo `pwd`/vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
