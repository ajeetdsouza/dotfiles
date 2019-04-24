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

##### set opts #####
setopt appendhistory autocd extendedglob nomatch
unsetopt beep

zstyle :compinstall filename "${HOME}/.zshrc"

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
alias exa='exa --group-directories-first'
alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
eval $(dircolors -b "${HOME}/.zgen/trapd00r/LS_COLORS-master/LS_COLORS")

function _exa_hook() {
    emulate -L zsh
    exa
}

chpwd_functions=(${chpwd_functions[@]} "_exa_hook")

##### zgen #####
source "${HOME}/.zgen/zgen.zsh"

# if the init scipt doesn't exist
if ! zgen saved; then
	echo "Creating a zgen save"

	# plugins
	zgen load bhilburn/powerlevel9k powerlevel9k.zsh-theme
	zgen load chriskempson/base16-shell
	zgen load rupa/z
	zgen load trapd00r/LS_COLORS
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

autoload -U +X bashcompinit && bashcompinit
eval "$(stack --bash-completion-script stack)"
