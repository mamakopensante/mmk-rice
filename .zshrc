# If not running interactively, don't do anything

[[ $- != *i* ]] && return

# Exports

export VISUAL='nvim'
export EDITOR='nvim'
export BROWSER='google-chrome-stable'
export SUDO_PROMPT='Password pls: '

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

# Load Engine

autoload -Uz compinit && compinit

zstyle ':completion:*:*:killall:*' command 'ps -e -o comm='
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} 'di=1;34' 
zstyle ':completion:*' matcher-list \
		'm:{a-zA-Z}={A-Za-z}' \
		'+r:|[._-]=* r:|=*' \
		'+l:|=*'
zstyle ':completion:*:warnings' format "%B%F{red}No matches for:%f %F{magenta}%d%b"
zstyle ':completion:*:descriptions' format '%F{yellow}[-- %d --]%f'
zstyle ':vcs_info:*' formats ' %B%s-[%F{magenta}%f %F{yellow}%b%f]-'

# Waiting dots

expand-or-complete-with-dots() {
  echo -n "\e[31m…\e[0m"
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots

# History

HISTFILE=~/.zhistory
HISTSIZE=5000
SAVEHIST=5000
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Cool options

setopt AUTOCD              # change directory just by typing its name
setopt PROMPT_SUBST        # enable command substitution in prompt
setopt MENU_COMPLETE       # Automatically highlight first element of completion menu
setopt LIST_PACKED		   # The completion menu takes less space.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD    # Complete from both ends of a word.

# Prompt

PROMPT='%B%F{blue}%~%f%b $(if [[ $EUID -eq 0 ]]; then echo "#"; else echo "$"; fi) '
RPROMPT='%*'

# command not found

command_not_found_handler() {
	printf "%s%s? I don't know what is it\n" "$acc" "$0" >&2
    return 127
}

# Plugins

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# Bindkeys

bindkey -r '^H'
bindkey -r '^Q'
bindkey -r '^U'
bindkey -r '^V'
bindkey -r '^W'
bindkey -r '^['
bindkey -r '^[[5~'
bindkey -r '^[[6~'
bindkey -r '^[OA'
bindkey -r '^[OB'
bindkey -r '^[OC'
bindkey -r '^[OD'
bindkey -r '^H'

bindkey '^I' expand-or-complete-with-dots
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[3~' delete-char
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^H' backward-kill-word

# Alias

alias ls='ls --color=always -a'
alias grep='grep --color=always'
alias cmatrix='cmatrix -u 10'
alias hour='tty-clock -s -c -C 2'
alias pinga='ping -c2 google.com'
alias vim='nvim'

# Autostart

if [[ -z "$DISPLAY" && "$(tty)" == "/dev/tty1" ]]; then
    exec startx
fi
