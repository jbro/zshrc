# According to the Zsh Plugin Standard:
# https://wiki.zshell.dev/community/zsh_plugin_standard/#zero-handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

zinit_annex_noalias_alias="${functions[:zinit-tmp-subst-alias]}"

zinit-annex-noalias-help() { : }

zinit-annex-noalias() {
  [[ ${+ICE[noalias]} = 0 ]] && return 0

  [[ "$1" = plugin ]] && \
    local hook="$6" || \
    local hook="$5" # type: snippet

  if [[ $hook = atinit ]]; then
    functions[:zinit-tmp-subst-alias]='() { : } "$@";'
    alias () { : }
  else
    unset -f alias
    functions[:zinit-tmp-subst-alias]="$zinit_annex_noalias_alias"
  fi
}

@zinit-register-annex "zinit-annex-noalias" hook:atinit-80 \
  zinit-annex-noalias \
  zinit-annex-noalias-help \
  "noalias''"

@zinit-register-annex "zinit-annex-noalias" hook:atload-80 \
  zinit-annex-noalias \
  zinit-annex-noalias-help \
