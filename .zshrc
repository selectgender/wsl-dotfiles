if [[ ! -f ~/.zpm/zpm.zsh ]]; then
  git clone --recursive https://github.com/zpm-zsh/zpm ~/.zpm
fi
source ~/.zpm/zpm.zsh

zpm load zsh-users/zsh-autosuggestions
zpm load Tarrasch/zsh-bd

path+=('/home/ivy/.cargo/bin/')
path+=('/home/ivy/dotfiles/scripts/')
export PATH
export EDITOR="nvim"

alias zrc="$EDITOR ~/dotfiles/.zshrc"
alias src="source ~/dotfiles/.zshrc"

alias s="sessionizer"

# if i dont put single quotes it executes for some reason
alias d='cd $(fd -t d | fzf)'

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

# need this to be last for some reason
zpm load zsh-users/zsh-syntax-highlighting
