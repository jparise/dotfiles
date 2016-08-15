TARGETS = install-bash install-ctags install-git install-hg install-ipython \
		  install-lldb install-tcsh install-terminfo install-vim

TERMINFO_FILES := $(wildcard terminfo/*.terminfo)

.PHONY: install $(TARGETS) $(TERMINFO_FILES)

install: $(TARGETS)

install-bash:
	rm -f ~/.bash_profile ~/.bashrc ~/.inputrc
	ln -s `pwd`/bash/bash_profile ~/.bash_profile
	ln -s `pwd`/bash/bashrc ~/.bashrc
	ln -s `pwd`/bash/inputrc ~/.inputrc

install-ctags:
	rm -f ~/.ctags
	ln -s `pwd`/ctags/ctags ~/.ctags

install-git:
	rm -f ~/.gitconfig ~/.gitignore
	ln -s `pwd`/git/gitconfig ~/.gitconfig
	ln -s `pwd`/git/gitignore ~/.gitignore

install-hg:
	rm -f ~/.hgignore ~/.hgrc
	ln -s `pwd`/hg/hgignore ~/.hgignore
	ln -s `pwd`/hg/hgrc ~/.hgrc

install-ipython:
	rm -rf ~/.ipython
	ln -s `pwd`/ipython ~/.ipython

install-lldb:
	rm -f ~/.lldbinit
	ln -s `pwd`/lldb/lldbinit ~/.lldbinit

install-tcsh:
	rm -f ~/.cshrc ~/.login
	ln -s `pwd`/tcsh/cshrc ~/.cshrc
	ln -s `pwd`/tcsh/login ~/.login

install-terminfo: $(TERMINFO_FILES)

install-vim: ~/.config vim/autoload/plug.vim
	rm -rf ~/.vim ~/.vimrc
	ln -s `pwd`/vim ~/.vim
	ln -s `pwd`/vim/vimrc ~/.vimrc
	ln -s `pwd`/vim ~/.config/nvim

~/.config:
	mkdir -p ~/.config

$(TERMINFO_FILES):
	tic -o ~/.terminfo $@

vim/autoload/plug.vim:
	curl -fLo `pwd`/vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
