# Setup homebrew
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  path+=~/.local/bin
fi

#
if (( $+commands[fortune] )); then
  echo "\033[0;36m$(fortune -e -s)\033[0m\n"
fi

# Various Mac fixes
if [[ $(uname -o) == "Darwin" ]]; then
  export LC_ALL=en_US.UTF-8
  export LANG=en_US
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Emacs keybindings
bindkey -e

# Set up history
HISTFILE=${HOME}/.zhistory
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS

# When pressing up limit history to prefix
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# Allow comments on the commandline,
# can be used to tag commands for easier searching
setopt INTERACTIVE_COMMENTS

# Change dir without using cd
setopt AUTOCD

# Apply gruvbox dark theme to ls and friends (generated with: vivid generate gruvbox-dark)
export LS_COLORS=$(<~/.config/zsh/lscolors-gruvbox)

# Set up completion style like I want it
zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:commands' rehash 1

# Install zinit under .config/zsh
declare -A ZINIT
ZINIT[BIN_DIR]=~/.config/zsh/zinit/zinit.git
ZINIT[HOME_DIR]=~/.config/zsh/zinit

# Install zinit if not pressent
[ -d "${ZINIT[BIN_DIR]}" ] \
  || git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT[BIN_DIR]}"
source "${ZINIT[BIN_DIR]}/zinit.zsh"

# Quick light/load change
zload=light
# Default ice
deice=(ice wait lucid depth:1)

# load local zinit annex that can disable alias loading in zinit plugins
zinit $zload $ZDOTDIR/zinit-annex-noalias

# Very nice zsh theme
zinit ice depth:1
zinit $zload romkatv/powerlevel10k

# Setup asdf and direnv
zinit $deice
zinit $zload redxtech/zsh-asdf-direnv

# Set the terminal title
zinit $deice
zinit $zload olets/zsh-window-title

# Syntax highlight zsh one liners while typing
zinit $deice \
  noalias
zinit $zload zdharma-continuum/fast-syntax-highlighting

# Fish like suggestion based completion
# atload, make availiable in first prompt and use / as word delimiter
zinit $deice \
  atload'WORDCHARS=${WORDCHARS/\/}; _zsh_autosuggest_start'
zinit $zload zsh-users/zsh-autosuggestions

# Let me know how to get missing commands
zinit $deice
zinit snippet OMZP::command-not-found

# Super easy sudo prefixing
zinit $deice
zinit snippet OMZP::sudo

# Borrow fzf plugin from Oh my zsh
zinit $deice \
  has:'fzf' \
  atload'export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
    --color=bg+:#3c3836,bg:#1d2021,spinner:#8ec07c,hl:#83a598 \
    --color=fg:#bdae93,header:#83a598,info:#fabd2f,pointer:#8ec07c \
    --color=marker:#8ec07c,fg+:#ebdbb2,prompt:#fabd2f,hl+:#83a598"'
zinit snippet OMZP::fzf

# Borrow aws plugin from Oh my zsh
zinit $deice \
  has:'aws'
zinit snippet OMZP::aws

# Auto completions, should be the last plugin as it runs compinit
zinit $deice \
  atload:'zicompinit'
zinit $zload clarketm/zsh-completions

# Set up our favorite editor
if (( $+commands[nvim] )); then
  export EDITOR=nvim
  alias vim=nvim
fi

# Use exa as ls
if (( $+commands[exa] )); then
  alias ls="exa --classify"
  alias tree="exa --tree"
fi

# Delete to trash
if (( $+commands[trash] )); then
  alias rm=trash
fi

# Set bat theme
if (( $+commands[bat] )); then
  alias bat="bat --theme=gruvbox-dark"
fi

# Set up quick cd'ing to project dirs
quick_paths=(~/Projects)
for d in $quick_paths; do
  if [[ -d "$d" ]]; then
    cdpath+="$d"
  fi
done

# Add local software to $PATH
if [[ -d ~/local ]]; then
  uname_system="$(uname -s)"
  for d in ~/local/*; do
    [[ -d "$d/bin" ]] && path+="$d/bin"
    [[ -d "$d/bin-$uname_system" ]] && path+="$d/bin-$uname_system"
  done
fi

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
