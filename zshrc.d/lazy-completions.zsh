# vim: ft=zsh
# lazy-completion <cmd> <generate-cmd> <version-cmd>
#   Generates and caches completions on first tab-complete, version-checks every 20h.

lazy-completion gh "gh completion -s zsh" "gh --version"
lazy-completion kubectl "kubectl completion zsh" "kubectl version --client --short"
lazy-completion task "task --completion zsh" "task --version"
lazy-completion docker "docker completion zsh" "docker --version"
lazy-completion flux "flux completion zsh" "flux --version"
