# Emacs keybindings
bindkey -e

# Install zinit under .config/zsh
declare -A ZINIT
ZINIT[BIN_DIR]=~/.config/zsh/zinit/zinit.git
ZINIT[HOME_DIR]=~/.config/zsh/zinit
# Install zinit if not pressent
[ -d "${ZINIT[BIN_DIR]}" ] || git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT[BIN_DIR]}"
source "${ZINIT[BIN_DIR]}/zinit.zsh"

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

# Use directory delimiter as word delimiter,
# useful when using fish style completion
autoload -U select-word-style
select-word-style bash

# Allow comments on the commandline,
# can be used to tag commands for easier searching
setopt INTERACTIVE_COMMENTS

# Various Mac fixes
if [[ $(uname -o) == "Darwin" ]]; then
  LC_ALL=en_US.UTF-8
  LANG=en_US
fi

# Setup homebrew
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  PATH=~/.local/bin:$PATH
fi

# Set up our favorite editor
if (( $+commands[nvim] )); then
  EDITOR=nvim
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

# Set up quick cd'ing to project dirs
if [[ -d ~/Projects ]]; then
  cdpath+=(~/Projects)
fi

# Apply gruvbox dark theme to ls and friends (generated with: vivid generate gruvbox-dark)
LS_COLORS=$(<~/.config/zsh/lscolors-gruvbox)

# Set up completion style like I want it
zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:commands' rehash 1

# Very nice zsh theme
zinit ice depth=1
zinit light romkatv/powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source ~/.config/zsh/.p10k.zsh

# XXX hack to make asdf load bash completion
# Figure out where this goes
autoload bashcompinit
bashcompinit
# Setup asdf
zinit ice if'[[ -f  ~/.asdf/asdf.sh ]]'
zinit snippet OMZP::asdf

# Borrow aws plugin from Oh my zsh
zinit ice has aws
zinit snippet OMZP::aws

# Borrow fzf plugin from Oh my zsh
zinit ice has fzf
zinit snippet OMZP::fzf

# Load a bunch of additional completions
zinit ice depth=1
zinit light zsh-users/zsh-completions

# Set the terminal title
zinit ice depth=1
zinit light olets/zsh-window-title

# Fish like suggestion based completion
zinit ice depth=1
zinit light zsh-users/zsh-autosuggestions

# Let me know how to get missing commands
zinit snippet OMZP::command-not-found

# Easy open folders in forklift
zinit ice if'[[ -d /Applications/ForkLift.app ]]'
zinit snippet OMZP::forklift

# Super easy sudo prefixing
zinit snippet OMZP::sudo

# Aliases to open files in VSCode
zinit ice has code
zinit snippet OMZP::vscode

# Syntax hilight zsh oneliners while typing
zinit ice depth=1
zinit light zsh-users/zsh-syntax-highlighting

# Enable auto completions, should be one of the last things we do
autoload -Uz compinit
compinit
zinit cdreplay -q

#
if [ "$(tty)" != "/dev/tty1" ]; then
  echo "\033[0;36m$(fortune -e -s)\033[0m\n"
fi

