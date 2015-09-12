set -e

[ -f "/usr/bin/sw_vers" ] && os="mac" || os="linux"

if [ $os = "mac" ]; then
    COLOR_RED=$(    echo "\033[31;1m" )
    COLOR_GREEN=$(  echo "\033[32;1m" )
    COLOR_YELLOW=$( echo "\033[33;1m" )
    COLOR_BLUE=$(   echo "\033[34;1m" )
    COLOR_MAGENTA=$(echo "\033[35;1m" )
    COLOR_CYAN=$(   echo "\033[36;1m" )
    COLOR_RESET=$(  echo "\033[0m"    )
else
    COLOR_RED=$(    echo -e "\033[31;1m" )
    COLOR_GREEN=$(  echo -e "\033[32;1m" )
    COLOR_YELLOW=$( echo -e "\033[33;1m" )
    COLOR_BLUE=$(   echo -e "\033[34;1m" )
    COLOR_MAGENTA=$(echo -e "\033[35;1m" )
    COLOR_CYAN=$(   echo -e "\033[36;1m" )
    COLOR_RESET=$(  echo -e "\033[0m"    )
fi

if [ ! -n "$MYDOT" ]; then
    MYDOT=~/.dotfiles
fi

if [ -d "$MYDOT" ]; then
    echo "${COLOR_RED}You already have $MYDOT installed.${COLOR_RESET} You'll need to remove $MYDOT if you want to install"
    exit
fi

doIt() {
    filename=~/.$1
    if [ -f $filename ] || [ -h $filename ]; then
        echo "${COLOR_RED}Found ${filename}.${COLOR_RESET} Backing up to $MYDOT/.${1}.bak.";
        mv $filename $MYDOT/.${1}.bak
    fi
    cp $MYDOT/$1 $filename
}

install() {
    echo "${COLOR_GREEN}"
    read -p "Install .${1}? (y/n) " -n 1;
    echo "${COLOR_RESET}"
    if [ $REPLY = "Y" ] || [ $REPLY = "y" ]; then
        doIt $1
    fi
}

echo "${COLOR_GREEN}Cloning dotfiles...${COLOR_RESET}"
hash git >/dev/null 2>&1 && env git clone --depth=1 https://github.com/binarylu/.dotfiles.git $MYDOT || {
    echo "git not installed"
    exit
}

install bashrc

[ "$os" = "mac" ] && install bash_profile

install zshrc

install vimrc

install gitconfig

TEST_CURRENT_SHELL=$(expr "$SHELL" : '.*/\(.*\)')
if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
    . ~/.zshrc
elif [ "$TEST_CURRENT_SHELL" != "bash" ]; then
    . ~/.bashrc
fi

#echo ""
#read -p "${COLOR_GREEN}Install .bashrc? (y/n) ${COLOR_RESET}" -n 1;
#if [ $REPLY = "Y" ] || [ $REPLY = "y" ]; then
#    doIt bashrc
#fi
#
## MacOS
#if [ $os = "mac" ]; then
#    doIt bash_profile
#fi
#
#echo ""
#read -p "${COLOR_GREEN}Install .zshrc? (y/n) ${COLOR_RESET}" -n 1;
#if [ $REPLY = "Y" ] || [ $REPLY = "y" ]; then
#    doIt zshrc
#fi
#
#echo ""
#read -p "${COLOR_GREEN}Install .vimrc? (y/n) ${COLOR_RESET}" -n 1;
#if [ $REPLY = "Y" ] || [ $REPLY = "y" ]; then
#    doIt vimrc
#fi
#
#echo ""
#read -p "${COLOR_GREEN}Install .gitconfig? (y/n) ${COLOR_RESET}" -n 1;
#if [ $REPLY = "Y" ] || [ $REPLY = "y" ]; then
#    doIt gitconfig
#fi
