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
       requires='fzf' && {
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
      --color=bg+:#3c3836,bg:#1d2021,spinner:#8ec07c,hl:#83a598 \
      --color=fg:#bdae93,header:#83a598,info:#fabd2f,pointer:#8ec07c \
      --color=marker:#8ec07c,fg+:#ebdbb2,prompt:#fabd2f,hl+:#83a598"
}

# Auto completions (Put plugins with completions we want to use below this)
plugin url='https://github.com/clarketm/zsh-completions.git'
