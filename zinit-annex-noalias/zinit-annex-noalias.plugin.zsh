# According to the Zsh Plugin Standard:
# https://wiki.zshell.dev/community/zsh_plugin_standard/#zero-handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

zinit-annex-noalias-help() { : }

zinit_annex_tmpdir="${ZINIT[HOME_DIR]}/tmp"
mkdir -p "${zinit_annex_tmpdir}"


zinit-annex-noalias() {
  [[ ${+ICE[noalias]} = 0 ]] && return 0

  [[ "$1" = plugin ]] && \
    local id="${2}--${3}" hook="$6" || \
    local id="$2" hook="$5" # type: snippet

  if [[ $hook = atinit ]]; then
    functions[alias]='() {:} "$@";'
  else
    functions[alias]=':zinit-tmp-subst-alias "$@";'
  fi

}

@zinit-register-annex "zinit-annex-noalias" hook:atinit-80 \
  zinit-annex-noalias \
  zinit-annex-noalias-help \
  "noalias''"

@zinit-register-annex "zinit-annex-noalias" hook:atload-80 \
  zinit-annex-noalias \
  zinit-annex-noalias-help \
