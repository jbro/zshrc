# vim: ft=zsh
# add-package-manager <cmd-or-path> && { ... }
#   Paths are file-checked, commands use $+commands.

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

add-package-manager asdf && {
  export ASDF_GOLANG_MOD_VERSION_ENABLED=true
  export ASDF_DATA_DIR=~/.asdf
  export PATH=$ASDF_DATA_DIR/shims:$PATH
}

add-package-manager bun && { export PATH=~/.bun/bin:$PATH }

add-package-manager cargo && { export PATH=~/.cargo/bin:$PATH }
