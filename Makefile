CONFIGS = bat ctags direnv ghostty git jj pip wezterm
TARGETS = agents bash vim $(CONFIGS)

.PHONY: install $(TARGETS)

install: $(TARGETS) ~/.hushlogin

~/.config ~/.cache/vim:
	mkdir -p $@

~/.hushlogin:
	touch $@

$(CONFIGS): | ~/.config
	@test ! -d $(HOME)/.config/$@ -o -L $(HOME)/.config/$@ \
		|| { echo "~/.config/$@ is a real directory; move or remove it"; exit 1; }
	ln -sfn $(CURDIR)/$@ $(HOME)/.config/$@

agents: SRC := $(CURDIR)/agents
agents:
	ln -sfn $(SRC) $(HOME)/.agents
# Claude Code
	mkdir -p $(HOME)/.claude/skills
	@find $(HOME)/.claude/skills -maxdepth 1 -type l ! -exec test -e {} \; -delete
	$(foreach d,$(wildcard $(SRC)/skills/*),ln -sfn $(d) $(HOME)/.claude/skills/$(notdir $(d)) &&) true

bash: SRC := $(CURDIR)/bash
bash:
	ln -sfn $(SRC)/.bash_profile ~/.bash_profile
	ln -sfn $(SRC)/.bashrc ~/.bashrc
	ln -sfn $(SRC)/.inputrc ~/.inputrc

vim: SRC := $(CURDIR)/vim
vim: | ~/.config ~/.cache/vim vim/autoload/plug.vim
	rm -rf ~/.vim ~/.config/nvim
	ln -sfn $(SRC) ~/.vim
	ln -sfn $(SRC) ~/.config/nvim
	ln -sfn $(SRC)/vimrc ~/.vimrc

vim/autoload/plug.vim:
	curl -fLo $(CURDIR)/vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
