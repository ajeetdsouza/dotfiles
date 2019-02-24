export TERM=xterm-256color

##### powerlevel9k #####
POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs dir_writable virtualenv anaconda ssh)
DEFAULT_USER="${USER}"

POWERLEVEL9K_HOME_ICON=''
POWERLEVEL9K_HOME_SUB_ICON=''
POWERLEVEL9K_FOLDER_ICON=''

##### history #####
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="${HOME}/.zsh_history"

##### base16-shell #####
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
	[ -s "$BASE16_SHELL/profile_helper.sh" ] && \
		eval "$("$BASE16_SHELL/profile_helper.sh")"

##### set opts #####
setopt appendhistory autocd extendedglob nomatch
unsetopt beep

zstyle :compinstall filename "${HOME}/.zshrc"

autoload -Uz compinit
compinit

##### keybindings #####
bindkey "^[[1;5C" forward-word # [Ctrl-RightArrow] - move forward one word
bindkey "^[[1;5D" backward-word # [Ctrl-RightArrow] - move forward one word

bindkey '^[[A' up-line-or-search # start typing + [Up-Arrow] - fuzzy find history forward
bindkey '^[[B' down-line-or-search # start typing + [Down-Arrow] - fuzzy find history backward

bindkey "^[[H" beginning-of-line # [Home] - go to beginning of line
bindkey "^[[F" end-of-line # # [End] - go to end of line

bindkey "^H" backward-kill-word # [Ctrl-Backspace] - delete word backward
bindkey "^[[3;5~" kill-word # [Ctrl+Delete] - delete word forward

bindkey "^[[3~" delete-char # [Delete] - delete forward

bindkey '^[[5~' up-line-or-history # [PageUp] - up a line of history
bindkey '^[[6~' down-line-or-history # [PageDown] - down a line of history

##### colorize all the things! #####
alias ls='ls --color --group-directories-first'
alias grep='grep --color'

##### zgen #####
source "${HOME}/.zgen/zgen.zsh"

# if the init scipt doesn't exist
if ! zgen saved; then
	echo "Creating a zgen save"

	# plugins
	zgen load bhilburn/powerlevel9k powerlevel9k.zsh-theme
	zgen load rupa/z
	zgen load zsh-users/zsh-autosuggestions

	zgen oh-my-zsh
	zgen oh-my-zsh plugins/bgnotify
	zgen oh-my-zsh plugins/dirhistory
	zgen oh-my-zsh plugins/history

	# completions
	zgen oh-my-zsh plugins/git
	zgen oh-my-zsh plugins/pip

	zgen load zdharma/fast-syntax-highlighting

	# save all to init script
	zgen save
fi

