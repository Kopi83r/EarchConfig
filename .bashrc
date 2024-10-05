#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias histg='history | grep'
PS1='[\u@\h \W]\$ '
alias pvelogin='ssh -p 566 -i ~/.ssh/homeNet root@192.168.0.200'
alias cloudgamelogin='ssh  -i ~/.ssh/homeNet root@192.168.0.150'

#lk  adding lines
shopt -s histappend

PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
