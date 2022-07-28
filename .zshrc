bindkey -e

declare -A ZINIT
ZINIT[BIN_DIR]=~/.config/zsh/zinit/zinit.git
ZINIT[HOME_DIR]=~/.config/zsh/zinit
[ -d "${ZINIT[BIN_DIR]}" ] || git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT[BIN_DIR]}"
source "${ZINIT[BIN_DIR]}/zinit.zsh"

zinit ice depth=1
zinit light romkatv/powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

zinit ice depth=1
zinit light zsh-users/zsh-completions

zinit ice depth=1
zinit light 3v1n0/zsh-bash-completions-fallback

autoload bashcompinit
bashcompinit

autoload compinit
compinit

zinit ice depth=1
zinit light zsh-users/zsh-autosuggestions
bindkey '^[[1;3C' forward-word # Alt right
bindkey '^[[1;3D' backward-word # Alt left

bindkey "^[[3~" delete-char # Delete

zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*' group-name ''
. /usr/share/LS_COLORS/dircolors.sh
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

zstyle ':completion:*:commands' rehash 1

zinit ice depth=1
zinit light AnimiVulpis/zsh-terminal-title

complete -C '/usr/bin/aws_completer' aws

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# Use directory delimiter as word delimiter
autoload -U select-word-style
select-word-style bash

export HISTFILE=${HOME}/.zhistory
export HISTSIZE=10000
export SAVEHIST=10000
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS

setopt INTERACTIVE_COMMENTS

export EDITOR=nvim

alias ssh="TERM=xterm-256color ssh"

alias vim=nvim

alias ls="exa --classify"
alias tree="exa --tree"

source <(grc-rs --aliases)

cdpath=(~/work ~/projects)

export PATH=~/.local/bin:$PATH

if [ "$(tty)" != "/dev/tty1" ]; then
  echo "\033[0;35m$(fortune -e -s)\033[0m\n"
fi

