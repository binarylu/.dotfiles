## -------------------- colourful print --------------------
## ANSI Foreground color codes:
## 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white 39=default
## ANSI Background color codes:
## 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white 49=default
COLOR_RED=$(    echo -e "\e[31;1m" )
COLOR_GREEN=$(  echo -e "\e[32;1m" )
COLOR_YELLOW=$( echo -e "\e[33;1m" )
COLOR_BLUE=$(   echo -e "\e[34;1m" )
COLOR_MAGENTA=$(echo -e "\e[35;1m" )
COLOR_CYAN=$(   echo -e "\e[36;1m" )
COLOR_RESET=$(  echo -e "\e[0m"    )

ip=`/sbin/ifconfig | grep -A3 '^en0' | grep 'inet ' | awk '{print $2}'`
#export PS1="${COLOR_RED}\u${COLOR_RESET}:${COLOR_BLUE}\w${COLOR_RESET}\\$ "
export PS1="[\t]\u@${ip}:\w\\$ "

export CLICOLOR="xterm-color"
export LSCOLORS=exfxcxdxcxegedabagacad
alias ..='cd ..'
alias l='ls'
alias ll='ls -l -G -A -T'
alias la='ls -al -G -A -T'
alias grep='grep --color=auto'
