# PACKAGE MANAGEMENT!
if [[ ! -f ~/.zpm/zpm.zsh ]]; then
  git clone --recursive https://github.com/zpm-zsh/zpm ~/.zpm
fi

source ~/.zpm/zpm.zsh

# everyone's favs
zpm load zsh-users/zsh-syntax-highlighting
zpm load zsh-users/zsh-completions
zpm load zsh-users/zsh-autosuggestions

# fzf,,, EVERYWHERE!
zpm load Aloxaf/fzf-tab

# load the autocomplete
autoload -U compinit && compinit

# COMPLETION STYLES!!
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# aliases
alias ls='ls --color'
alias src='source ~/.zshrc'

# get some cool programs in :)
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(fzf --zsh)"

source /home/ivy/.config/broot/launcher/bash/br
