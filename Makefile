install: install-bash install-git install-hg install-ipython install-lldb \
		 install-tcsh install-vim

install-bash:
	rm -f ~/.inputrc
	ln -s `pwd`/bash/inputrc ~/.inputrc

install-git:
	rm -f ~/.gitconfig
	ln -s `pwd`/git/gitconfig ~/.gitconfig

install-hg:
	rm -f ~/.hgignore ~/.hgrc
	ln -s `pwd`/hg/hgignore ~/.hgignore
	ln -s `pwd`/hg/hgrc ~/.hgrc

install-ipython:
	rm -rf ~/.ipython
	ln -s `pwd`/ipython ~/.ipython

install-lldb:
	rm -f ~/.lldbinit
	ln -s `pwd`/llbdb/lldbinit ~/.lldbinit

install-tcsh:
	rm -f ~/.cshrc ~/.login
	ln -s `pwd`/tcsh/cshrc ~/.cshrc
	ln -s `pwd`/tcsh/login ~/.login

install-vim: vim/autoload/plug.vim
	rm -rf ~/.vim ~/.vimrc
	ln -s `pwd`/vim ~/.vim
	ln -s `pwd`/vim/vimrc ~/.vimrc

vim/autoload/plug.vim:
	curl -fLo `pwd`/vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
