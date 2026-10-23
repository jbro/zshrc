# vim: ft=zsh
# Package managers and completion plugins add their directories before this
# file. Other plugins and lazy completion stubs can use compdef afterwards.

# Rebuild the completion index every 20 hours
autoload -Uz compinit
_zshrc_bench_comp_start=$EPOCHREALTIME
setopt EXTENDEDGLOB
if [[ ${ZDOTDIR}/.zcompdump(#qN.mh-20) ]]; then
  compinit -C
else
  rm -f "${ZDOTDIR}/.zcompdump" "${ZDOTDIR}/.zcompdump.zwc"
  compinit
  zcompile "${ZDOTDIR}/.zcompdump"
  touch "${ZDOTDIR}/.zcompdump"
fi
unsetopt EXTENDEDGLOB
_zshrc_bench_comp_end=$EPOCHREALTIME

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
