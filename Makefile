install: bash git hg ipython lldb tcsh vim

bash:
	rm -f ~/.inputrc
	ln -s `pwd`/.inputrc ~/.inputrc

git:
	rm -f ~/.gitconfig
	ln -s `pwd`/.gitconfig ~/.gitconfig

hg:
	rm -f ~/.hgignore ~/.hgrc
	ln -s `pwd`/.hgignore ~/.hgignore
	ln -s `pwd`/.hgrc ~/.hgrc

ipython:
	rm -rf ~/.ipython
	ln -s `pwd`/.ipython ~/.ipython

lldb:
	rm -f ~/.lldbinit
	ln -s `pwd`/.lldbinit ~/.lldbinit

tcsh:
	rm -f ~/.cshrc ~/.logic
	ln -s `pwd`/.cshrc ~/.cshrc
	ln -s `pwd`/.logic ~/.logic

vim:
	rm -rf ~/.vim ~/.vimrc
	ln -s `pwd`/.vim ~/.vim
	ln -s `pwd`/.vimrc ~/.vimrc
