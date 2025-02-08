# PACKAGE MANAGEMENT!
if [[ ! -f ~/.zpm/zpm.zsh ]]; then
  git clone --recursive https://github.com/zpm-zsh/zpm ~/.zpm
fi

source ~/.zpm/zpm.zsh

# everyone's favs
zpm load zsh-users/zsh-completions
zpm load zsh-users/zsh-autosuggestions

# load the autocomplete
autoload -U compinit && compinit

# fzf,,, EVERYWHERE!
zpm load Aloxaf/fzf-tab

# COMPLETION STYLES!!
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# aliases
alias ls='ls --color'
alias src='source ~/.zshrc'

# i am fucking tired of typing mkdir and cd separately
# https://unix.stackexchange.com/questions/125385/combined-mkdir-and-cd
md() {
	mkdir $1
	cd $1
}

# get some cool programs in :)
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(fzf --zsh)"

# add shit to path
path+=('/home/ivy/.cargo/bin/')

export PATH

source /home/ivy/.config/broot/launcher/bash/br

# catppuccin mocha colorscheme for fzf :3
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

# everyone's fav's... but respect the loading order
zpm load zsh-users/zsh-syntax-highlighting
