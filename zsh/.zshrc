##### powerlevel10k #####
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

##### zsh options #####
setopt appendhistory autocd extendedglob nomatch interactivecomments
unsetopt beep

##### zsh history #####
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="${HOME}/.zsh_history"

##### zsh keybindings #####
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

##### aliases #####
alias code='codium'
alias grep='grep --color=auto'
alias ls='ls --color=auto --group-directories-first'
alias v='vim'
alias x='exit'

##### hooks #####
function _ls_hook() {
    emulate -L zsh
    ls
}

chpwd_functions=(${chpwd_functions[@]} '_ls_hook')

##### zoxide #####
eval "$(zoxide init zsh)"

##### zsh-autosuggestions #####
ZSH_AUTOSUGGEST_STRATEGY=(history)

##### zgen #####
# load zgen
source "${HOME}/.zgen/zgen.zsh"

# if the init scipt doesn't exist
if ! zgen saved; then
	echo 'Creating a zgen save'

	# plugins
  	zgen load romkatv/powerlevel10k powerlevel10k
	zgen load chriskempson/base16-shell
	zgen load zsh-users/zsh-autosuggestions

	zgen oh-my-zsh
	zgen oh-my-zsh plugins/bgnotify
	zgen oh-my-zsh plugins/dirhistory
	zgen oh-my-zsh plugins/git
	zgen oh-my-zsh plugins/history
	zgen oh-my-zsh plugins/pip

	zgen load zdharma/fast-syntax-highlighting

	# save all to init script
	zgen save
fi

##### completions #####
zstyle :compinstall filename "${HOME}/.zshrc"

autoload -Uz compinit
compinit

autoload -U +X bashcompinit && bashcompinit

##### powerlevel10k #####
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
