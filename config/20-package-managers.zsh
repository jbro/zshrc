# vim: ft=zsh
# add-package-manager <cmd-or-path> && { ... }
#   Paths are file-checked, commands use $+commands.

add-package-manager asdf && {
  export ASDF_GOLANG_MOD_VERSION_ENABLED=true
  export ASDF_DATA_DIR=~/.asdf
  export PATH=$ASDF_DATA_DIR/shims:$PATH
}

add-package-manager bun && { export PATH=~/.bun/bin:$PATH }

add-package-manager cargo && { export PATH=~/.cargo/bin:$PATH }
