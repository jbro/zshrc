# vim: ft=zsh
add-package-manager /opt/homebrew/bin/brew && {
  # Generated with /opt/homebrew/bin/brew shellenv
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
  export HOMEBREW_REPOSITORY="/opt/homebrew"
  fpath[1,0]="/opt/homebrew/share/zsh/site-functions"
  path=("/opt/homebrew/bin" "/opt/homebrew/sbin" $path)
  [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}"
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
  source $HOMEBREW_REPOSITORY/Library/Homebrew/command-not-found/handler.sh
}
