# vim: ft=zsh
# plugin url=<repo> [branch=<branch>] [initfile=<file>] [subdir=<path>] [requires=<cmd>]
#   requires — skip if <cmd> missing, returns 1 for && { ... } gating.

# Very nice zsh theme
plugin url='https://github.com/romkatv/powerlevel10k.git' \
       initfile='powerlevel10k.zsh-theme'

# Fish like suggestion based completion
plugin url='https://github.com/zsh-users/zsh-autosuggestions.git' && {
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_HISTORY_IGNORE='(cd|ls|vim) *'
}

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

# fzf integration
plugin url='https://github.com/ohmyzsh/ohmyzsh.git' \
       subdir='plugins/fzf' \
       requires='fzf'
