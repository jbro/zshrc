# vim: ft=zsh
# alias-if <cmd> <alias>=<value>
#   Sets alias only when <cmd> is installed.

alias-if nvim vim=nvim
alias-if eza ls="eza --classify auto"
alias-if eza tree="eza --tree"
alias-if trash rm=trash
alias-if bat bat="bat --theme=gruvbox-dark"
alias-if gron norg="gron --ungron"
alias-if gron ungron="gron --ungron"
