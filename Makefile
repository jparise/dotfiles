install: install-bash install-git install-hg install-ipython install-lldb \
		 install-tcsh install-vim

install-bash:
	rm -f ~/.inputrc
	ln -s `pwd`/.inputrc ~/.inputrc

install-git:
	rm -f ~/.gitconfig
	ln -s `pwd`/.gitconfig ~/.gitconfig

install-hg:
	rm -f ~/.hgignore ~/.hgrc
	ln -s `pwd`/.hgignore ~/.hgignore
	ln -s `pwd`/.hgrc ~/.hgrc

install-ipython:
	rm -rf ~/.ipython
	ln -s `pwd`/.ipython ~/.ipython

install-lldb:
	rm -f ~/.lldbinit
	ln -s `pwd`/.lldbinit ~/.lldbinit

install-tcsh:
	rm -f ~/.cshrc ~/.logic
	ln -s `pwd`/.cshrc ~/.cshrc
	ln -s `pwd`/.logic ~/.logic

install-vim:
	rm -rf ~/.vim ~/.vimrc
	ln -s `pwd`/.vim ~/.vim
	ln -s `pwd`/.vimrc ~/.vimrc
