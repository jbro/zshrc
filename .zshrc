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

# Enable Powerlevel10k instant prompt. Should stay close to the top of ${ZDOTDIR}/.zshrc.
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

# Allow comments on the commandline,
# can be used to tag commands for easier searching
setopt INTERACTIVE_COMMENTS

# Change dir without using cd
setopt AUTOCD

# Apply gruvbox dark theme to ls and friends (generated with: vivid generate gruvbox-dark)
export LS_COLORS=$(<~/.config/zsh/lscolors-gruvbox)

# Plugin manager light
zsh_loaded_plugins=()
ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}
function plugin {
  local plugindir url initfile subdir
  for var in $@; do
    eval "$var"
  done

  plugindir="${ZPLUGINDIR}/${url:t2:r}"

  # Clone plugin if not installed
  if [ ! -d "$plugindir" ]; then
    git clone -q --recursive --shallow-submodules --depth=1 $url "$plugindir"
  fi

  if [ -n "$subdir" ]; then
    plugindir+="/$subdir"
  fi

  zsh_loaded_plugins+="${plugindir:t2:r}"
  if [ -z "$initfile" ]; then
    # Assume zsh plugin standard
    fpath+="$plugindir"
    source "$plugindir/${plugindir:t:r}.plugin.zsh"
  else
    source "$plugindir/$initfile"
  fi
}

# Very nice zsh theme
plugin url='https://github.com/romkatv/powerlevel10k.git' \
       initfile='powerlevel10k.zsh-theme'

# Setup asdf and direnv
plugin url='https://github.com/redxtech/zsh-asdf-direnv.git'

# Set the terminal title
plugin url='https://github.com/olets/zsh-window-title.git'

# Syntax highlight zsh one liners while typing
plugin url='https://github.com/zdharma-continuum/fast-syntax-highlighting.git'

# Auto completions
plugin url='https://github.com/clarketm/zsh-completions.git'

# Fish like suggestion based completion
WORDCHARS="" # All special characters are now word boundaries for alt+right-arrow
plugin url='https://github.com/zsh-users/zsh-autosuggestions.git'

# Show completions as we type
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
plugin url='https://github.com/marlonrichert/zsh-autocomplete.git'

# Let me know how to get missing commands
plugin url='https://github.com/ohmyzsh/ohmyzsh.git' \
       subdir='plugins/command-not-found'

# Super easy sudo prefixing
plugin url='https://github.com/ohmyzsh/ohmyzsh.git' \
       subdir='plugins/sudo'

# Borrow fzf plugin from Oh my zsh
if (( $+commands[fzf] )); then
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
    --color=bg+:#3c3836,bg:#1d2021,spinner:#8ec07c,hl:#83a598 \
    --color=fg:#bdae93,header:#83a598,info:#fabd2f,pointer:#8ec07c \
    --color=marker:#8ec07c,fg+:#ebdbb2,prompt:#fabd2f,hl+:#83a598"
plugin url='https://github.com/ohmyzsh/ohmyzsh.git' \
       subdir='plugins/fzf'
fi

# Borrow aws plugin from Oh my zsh
if (( $+commands[aws] )); then
plugin url='https://github.com/ohmyzsh/ohmyzsh.git' \
       subdir='plugins/aws'
fi

# Done loading plugins, so we no longer need the plugin function
unset -f plugin

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

if (( $+commands[gron] )); then
  alias norg="gron --ungron"
  alias ungron="gron --ungron"
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

# To customize prompt, run `p10k configure` or edit ${ZDOTDIR}/.p10k.zsh.
if [[ -f ${ZDOTDIR}/.p10k.zsh ]]; then
  source ${ZDOTDIR}/.p10k.zsh
  # Theme overrides
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=3
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION=' %Bλ%b'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=3
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
  typeset -g POWERLEVEL9K_TERM_SHELL_INTEGRATION=true
  p10k reload
fi
