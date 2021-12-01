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

zinit ice depth=1
zinit light agkozak/zsh-z

zinit ice depth=1
zinit light marlonrichert/zsh-autocomplete
zstyle ':autocomplete:*' recent-dirs zsh-z
zstyle ':autocomplete:*' widget-style menu-select
zstyle ':autocomplete:*' min-input 1
zstyle ':completion:*:commands' rehash 1

zinit ice depth=1
zinit light 3v1n0/zsh-bash-completions-fallback

zinit ice depth=1
zinit light zsh-users/zsh-completions

bindkey -e

export HISTFILE=${ZDOTDIR:-$HOME}/.zhistory
export HISTSIZE=10000
export SAVEHIST=10000
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS

setopt INTERACTIVE_COMMENTS

export EDITOR=nvim

alias ssh="kitty +kitten ssh"

alias vim=nvim

alias ls="exa --classify"
alias tree="ls --tree"

source <(grc-rs --aliases)

cdpath=(~/work ~/projects)

export PATH=~/.local/bin:$PATH

echo "\033[0;35m$(fortune -e -s)\033[0m\n"

