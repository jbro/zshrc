# vim: ft=zsh
# Load zsh profiling module (use ZSH_PROFILE=1 zsh to enable)
[[ -v ZSH_PROFILE ]] && zmodload zsh/zprof

# Store all current variable names in an array, so we can see which new ones were added
typeset -a _zshrcX_var_names=(${(k)parameters})

# Start load benchmarking
zmodload zsh/datetime
_zshrc_bench_start=$EPOCHREALTIME

# Environment variables
export EDITOR=vim

# Source os env variables
_zshrc_ostype=${OSTYPE%%[^a-zA-Z]*}
if [[ -f "${ZDOTDIR}/env/$_zshrc_ostype" ]]; then
  source "${ZDOTDIR}/env/$_zshrc_ostype"
fi

# Source local env variables
if [[ -f "${ZDOTDIR}/env/local" ]]; then
  source "${ZDOTDIR}/env/local"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ${ZDOTDIR}/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Mark in benchmark when prompt appears
_zshrc_bench_prompt=$EPOCHREALTIME

# Setup homebrew
if [[ -f /opt/homebrew/bin/brew ]]; then
  # Generated with /opt/homebrew/bin/brew shellenv
  export HOMEBREW_PREFIX="/opt/homebrew";
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
  export HOMEBREW_REPOSITORY="/opt/homebrew";
  fpath[1,0]="/opt/homebrew/share/zsh/site-functions";
  eval "$(/usr/bin/env PATH_HELPER_ROOT="/opt/homebrew" /usr/libexec/path_helper -s)"
  [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

  # load homebrew's command not found
  source $HOMEBREW_REPOSITORY/Library/Homebrew/command-not-found/handler.sh
fi

# asdf
if (( $+commands[asdf] )); then
  export ASDF_GOLANG_MOD_VERSION_ENABLED=true
  export ASDF_DATA_DIR=~/.asdf
  export PATH=$ASDF_DATA_DIR/shims:$PATH
fi

# bun
if (( $+commands[bun] )); then
  export PATH=~/.bun/bin:$PATH
fi

# cargo
if (( $+commands[cargo] )); then
  export PATH=~/.cargo/bin:$PATH
fi

# Lazy load helper functions
fpath=("${ZDOTDIR}/functions" $fpath)
autoload -Uz $fpath[1]/*(.:t)

# Lazy load OS specific helper functions
if [[ -d "${ZDOTDIR}/functions/$_zshrc_ostype/" ]]; then
  fpath=("${ZDOTDIR}/functions/$_zshrc_ostype/" $fpath)
  autoload -Uz $fpath[1]/*(.:t)
fi

# Lazy load local helper function
if [[ -d "${ZDOTDIR}/functions/local/" ]]; then
  fpath=("${ZDOTDIR}/functions/local/" $fpath)
  autoload -Uz $fpath[1]/*(.:t)
fi

# Load local completions
if [[ -d "${ZDOTDIR}/completions/local" ]]; then
  fpath=("${ZDOTDIR}/completions/local" $fpath)
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

# Optimize completion cache about once per day
autoload -Uz compinit
_zshrc_bench_comp_start=$EPOCHREALTIME
setopt EXTENDEDGLOB
if [[ ${ZDOTDIR}/.zcompdump(#qN.mh-20) ]]; then
  compinit -C
else
  rm -f "${ZDOTDIR}/.zcompdump" "${ZDOTDIR}/.zwc"
  compinit
  zcompile "${ZDOTDIR}/.zcompdump"
  touch "${ZDOTDIR}/.zcompdump"
fi
unsetopt EXTENDEDGLOB
_zshrc_bench_comp_end=$EPOCHREALTIME

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
plugin url='https://github.com/babarot/enhancd.git'

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
  alias vim=nvim
fi

# Use eza as ls
if (( $+commands[eza] )); then
  alias ls="eza --classify auto"
  alias tree="eza --tree"
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
if [[ -f "${ZDOTDIR}/quick_paths" ]]; then
  _zshrc_quick_paths=("${(@f)$(<${ZDOTDIR}/quick_paths)}")
  for d in $_zshrc_quick_paths; do
    if [[ -d ${~d} ]]; then
      cdpath+=${~d}
    fi
  done
fi

# Lazy completions
lazy-completion gh "gh completion -s zsh" "gh --version"
lazy-completion kubectl "kubectl completion zsh" "kubectl version --client --short"

# Load direnv
(( ${+commands[direnv]} )) && eval "$(direnv hook zsh)"

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
  printf 'Completion init time: %6.1f ms\n' $((_zshrc_bench_comp_end - _zshrc_bench_comp_start))
  echo
  printf 'Time to prompt: %6.1f ms\n' $(( $time_to_prompt * 1000 ))
  printf 'Time to load:   %6.1f ms\n'  $(( $time_to_load * 1000 ))
}

# Memoize benchmark report
eval "function zshrc_benchmark { echo '$(_zshrc_bench_report)' }"

# Clean up local variables and function
unset -f -m "_zshrc_*"
unset -m "_zshrc_*"

# Memoize new variables introduced by this zshrc
eval "function zshrc_show_new_vars {
  echo '$(
    local vars=_zshrcX_var_names
    unset _zshrcX_var_names
    echo "Variable count before loading this zshrc: ${#vars[@]}"
    echo "Variable count after loading this zshrc: ${#parameters}"
    echo "Variables introduced by this zshrc:"
    for var in ${(ko)parameters}; do
      if [[ ! " ${vars[@]} " =~ " ${var} " ]]; then
        echo "$var"
      fi
    done
  )'
}"

# Memoize zprof output
if [[ -v ZSH_PROFILE ]]; then
  eval "function zshrc_profile { echo '$(zprof)' }"
fi
