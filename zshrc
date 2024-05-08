#zmodload zsh/zprof
# Start load benchmarking
zmodload zsh/datetime
_zshrc_bench_start=$EPOCHREALTIME

# Setup homebrew
if [[ -f /opt/homebrew/bin/brew ]]; then
  # Generated with /opt/homebrew/bin/brew shellenv
  export HOMEBREW_PREFIX="/opt/homebrew";
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
  export HOMEBREW_REPOSITORY="/opt/homebrew";
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
  export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
fi

# Various Mac fixes
if [[ $OSTYPE == "darwin"* ]]; then
  export LC_ALL=en_US.UTF-8
  export LANG=en_US
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ${ZDOTDIR}/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Mark in benchmark when prompt appears
_zshrc_bench_prompt=$EPOCHREALTIME

# asdf
if [ -d ~/.asdf ]; then
  source ~/.asdf/asdf.sh
  fpath=(${ASDF_DIR}/completions $fpath)
fi

# Lazy load helper functions
fpath=("${ZDOTDIR}/functions" $fpath)
autoload -Uz $fpath[1]/*(.:t)

# Lazy load OS specific helper functions
if [[ -d "${ZDOTDIR}/functions/$(uname -o)" ]]; then
  fpath=("${ZDOTDIR}/functions/$(uname -o)" $fpath)
  autoload -Uz $fpath[1]/*(.:t)
fi

# Lazy load local helper function
if [[ -d "${ZDOTDIR}/local/functions" ]]; then
  fpath=("${ZDOTDIR}/local/functions" $fpath)
  autoload -Uz $fpath[1]/*(.:t)
fi

# Source local env variables
if [[ -f "${ZDOTDIR}/local/env" ]]; then
  source "${ZDOTDIR}/local/env"
fi

# Load local completions
if [[ -d "${ZDOTDIR}/local/completions" ]]; then
  fpath=("${ZDOTDIR}/local/completions" $fpath)
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

# Allow comments on the commandline, can be used to tag commands for easier searching
setopt INTERACTIVE_COMMENTS

# Change dir without using cd
setopt AUTOCD

# Apply gruvbox dark theme to ls and friends (generated with: vivid generate gruvbox-dark)
export LS_COLORS=$(<~/.config/zsh/lscolors-gruvbox)

# When pressing up limit history to prefix
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# Alt plus left and right move by word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# Optimize completion cache once per day
autoload -Uz compinit
setopt EXTENDEDGLOB
if [[ ${ZDOTDIR}/.zcompdump(#qN.mh-20) ]]; then
  compinit -C
else
  compinit
  touch "${ZDOTDIR}/.zcompdump"
  zcompile "${ZDOTDIR}/.zcompdump"
fi
unsetopt EXTENDEDGLOB

# Set up completion style like I want it
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZDOTDIR/.zcompcache"
zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:commands' rehash 1

# Set up plug-in path
ZPLUGINDIR="${ZDOTDIR}/plugins"

# Very nice zsh theme
plugin url='https://github.com/romkatv/powerlevel10k.git' \
       initfile='powerlevel10k.zsh-theme'

# Fish like suggestion based completion
WORDCHARS="" # All special characters are now word boundaries for alt+right-arrow
plugin url='https://github.com/zsh-users/zsh-autosuggestions.git'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HISTORY_IGNORE='(cd|ls|vim) *'

# Set the terminal title
plugin url='https://github.com/olets/zsh-window-title.git'

# Let me know how to get missing commands
plugin url='https://github.com/ohmyzsh/ohmyzsh.git' \
       subdir='plugins/command-not-found'

# Super easy sudo prefixing
plugin url='https://github.com/ohmyzsh/ohmyzsh.git' \
       subdir='plugins/sudo'

# Borrow aws plugin from oh-my-zsh
plugin url='https://github.com/ohmyzsh/ohmyzsh.git' \
       subdir='plugins/aws'

# jq repl
plugin url='https://github.com/reegnz/jq-zsh-plugin.git'

# enhanced cd
plugin url='https://github.com/jbro/enhancd.git' \
       branch='cdpath'

# Borrow fzf plugin from Oh my zsh
if (( $+commands[fzf] )); then
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
    --color=bg+:#3c3836,bg:#1d2021,spinner:#8ec07c,hl:#83a598 \
    --color=fg:#bdae93,header:#83a598,info:#fabd2f,pointer:#8ec07c \
    --color=marker:#8ec07c,fg+:#ebdbb2,prompt:#fabd2f,hl+:#83a598"
plugin url='https://github.com/ohmyzsh/ohmyzsh.git' \
       subdir='plugins/fzf'
fi

# Auto completions (Put plugins with completions we want to use below this)
plugin url='https://github.com/clarketm/zsh-completions.git'

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
quick_paths=(~/Projects ~/projects)
for d in $quick_paths; do
  if [[ -d "$d" ]]; then
    cdpath+="$d"
  fi
done

# Enable direnv Part I
# ref: https://github.com/romkatv/powerlevel10k#how-do-i-initialize-direnv-when-using-instant-prompt
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

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

# Enable direnv Part II
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

# Mark for benchmark when config was done loading
_zshrc_bench_done=$EPOCHREALTIME

# Helper to generate benchmark report
function _zshrc_bench_report {
  local time_to_prompt=$((_zshrc_bench_prompt - _zshrc_bench_start))
  local time_to_load=$((_zshrc_bench_done - _zshrc_bench_start))

  echo "Plugins:"
  for p in $zsh_loaded_plugins; do
    printf "  $p:;%6.1f ms\n" $(( $_zshrc_bench_plugins[$p] * 1000))
  done | column -t -c 2 -s ';'
  echo
  echo "Snippets:"
  for s in $zsh_loaded_snippets; do
    printf "  $s:;%6.1f ms\n" $(( $_zshrc_bench_plugins[$s] * 1000))
  done | column -t -c 2 -s ';'
  echo
  printf 'Time to prompt: %6.1f ms\n' $(( $time_to_prompt * 1000 ))
  printf 'Time to load:   %6.1f ms\n'  $(( $time_to_load * 1000 ))
}

# Memoize benchmark report
eval "function zshrc_benchmark { echo '$(_zshrc_bench_report)' }"

# Clean up benchmark variables and function
unset -f -m "_zshrc_bench_*"
unset -m "_zshrc_bench_*"

#zprof
