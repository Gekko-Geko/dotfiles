# Load exports
source $HOME/.config/zsh/zsh_exports

# Load aliases
source $HOME/.config/zsh/zsh_alias

# Load prompt
source $HOME/.config/zsh/zsh_prompt

# Load function
source $HOME/.config/zsh/zsh_functions

# Key Bindings
typeset -g -A key
# Disable ctrl-s, ctrl-q
stty -ixon

bindkey -v
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[." insert-last-word
bindkey "^[_" insert-last-word
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey -s '^o' 'lfcd\n'

zstyle :compinstall filename '/home/geko/.zshrc'

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# ASCII art
pokemon-colorscripts -r

# Auto cd
setopt autocd

# No duplicated command into history list
setopt HIST_IGNORE_ALL_DUPS

setopt menucomplete

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"

[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
