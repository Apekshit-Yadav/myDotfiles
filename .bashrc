#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias pi='yay -S '
alias piq='yay -S --noconfirm '
alias pcc='sudo pacman -Rcns $(pacman -Qtdq)'
alias xx='exit'
alias prem='sudo pacman -Rcns '
alias hyr='hyprctl reload'
alias ed='gnome-text-editor '
alias sd='systemctl poweroff'
alias lout='hyprctl dispatch exit'
alias upd='sudo pacman -Syu'
# In bashrc autosuggestion
bind 'TAB: menu-complete'
bind 'set show-all-if-ambiguous on'
PS1='[\u@\h \W]\$ '

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
eval "$(starship init bash)"

export PATH=$PATH:/home/papa/.spicetify
