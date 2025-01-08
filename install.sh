set -e

[ -f "/usr/bin/sw_vers" ] && os="mac" || os="linux"

[ $os = "mac" ] && echoflag="" || echoflag="-e"
COLOR_RED=$(    eval echo $echoflag "'\033[31;1m'" )
COLOR_GREEN=$(  eval echo $echoflag "'\033[32;1m'" )
COLOR_YELLOW=$( eval echo $echoflag "'\033[33;1m'" )
COLOR_BLUE=$(   eval echo $echoflag "'\033[34;1m'" )
COLOR_MAGENTA=$(eval echo $echoflag "'\033[35;1m'" )
COLOR_CYAN=$(   eval echo $echoflag "'\033[36;1m'" )
COLOR_RESET=$(  eval echo $echoflag "'\033[0m'"    )
unset echoflag

if [ ! -n "$MYDOT" ]; then
    MYDOT=~/.dotfiles
fi

if [ -d "$MYDOT" ]; then
    echo "${COLOR_RED}You already have $MYDOT installed.${COLOR_RESET} You'll need to remove $MYDOT if you want to install"
    exit
fi

ts=$(date +%s)
bakdir=~/.dotfiles.bak.$ts

doIt() {
    filename=~/.$1
    if [ -f "$filename" ] || [ -h "$filename" ]; then
        [ ! -d "$bakdir" ] && mkdir -p "$bakdir"
        echo "${COLOR_RED}Found ${filename}.${COLOR_RESET} Backing up to ${bakdir}/.${1}.bak.";
        mv "$filename" "${bakdir}/.${1}.bak"
    fi
    cp -r "${MYDOT}/$1" "$filename"
}

install() {
    echo "${COLOR_GREEN}"
    read -p "Install .${1}? (y/n) " -n 1;
    echo "${COLOR_RESET}"
    if [ "$REPLY" = "Y" ] || [ "$REPLY" = "y" ]; then
        doIt "$1"
    fi
}

echo "${COLOR_GREEN}Cloning dotfiles...${COLOR_RESET}"
hash git >/dev/null 2>&1 && env git clone --depth=1 https://github.com/binarylu/.dotfiles.git $MYDOT || {
    echo "git not installed"
    exit
}

## config bash
if [ "$os" = "mac" ]; then
    install bash_profile
    mv ${MYDOT}/bashrc.mac ${MYDOT}/bashrc
else
    mv ${MYDOT}/bashrc.linux ${MYDOT}/bashrc
fi
install bashrc

## config zsh
CHECK_ZSH_INSTALLED=$(grep /zsh$ /etc/shells | wc -l)
if [ ! $CHECK_ZSH_INSTALLED -ge 1 ]; then
    echo "${COLOR_YELLOW}Zsh is not installed, pass!${COLOR_RESET}"
else
    install zshrc
fi
unset CHECK_ZSH_INSTALLED

## config git
install gitconfig
install gitignore_global

## config screen
install screenrc

## config tmux
install tmux.conf
echo "${COLOR_GREEN}"
read -p "Install tmux plugin? (y/n) " -n 1;
echo "${COLOR_RESET}"
if [ "$REPLY" = "Y" ] || [ "$REPLY" = "y" ]; then
    if [ -d ~/.tmux ] || [ -h ~/.tmux ]; then
        [ ! -d "$bakdir" ] && mkdir -p "$bakdir"
        echo "${COLOR_RED}Found ~/.tmux.${COLOR_RESET} Backing up to ${bakdir}/.tmux.bak.";
        mv ~/.tmux "${bakdir}/.tmux.bak"
    fi
    mkdir -p ~/.tmux
    git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "Press prefix + I in tmux to install plugins."
fi

## config vim
install vimrc
echo "${COLOR_GREEN}"
read -p "Install vim plugin? (y/n) " -n 1;
echo "${COLOR_RESET}"
if [ "$REPLY" = "Y" ] || [ "$REPLY" = "y" ]; then
    if [ -d ~/.vim ] || [ -h ~/.vim ]; then
        [ ! -d "$bakdir" ] && mkdir -p "$bakdir"
        echo "${COLOR_RED}Found ~/.vim.${COLOR_RESET} Backing up to ${bakdir}/.vim.bak.";
        mv ~/.vim "${bakdir}/.vim.bak"
    fi

    vim -es -u ~/.vimrc -i NONE -c "PlugInstall" -c "qa"
fi

if [ "$os" = "mac" ]; then
    echo "${COLOR_GREEN}"
    read -p "Your OS is Mac OS, need to config webserver? (y/n) " -n 1;
    echo "${COLOR_RESET}"
    if [ "$REPLY" = "Y" ] || [ "$REPLY" = "y" ]; then
        bash ${MYDOT}/apache_for_mac.sh
    fi
fi

rm -fr $MYDOT

TEST_CURRENT_SHELL=$(expr "$SHELL" : '.*/\(.*\)')
if [ "$TEST_CURRENT_SHELL" = "zsh" ]; then
    #TODO not going after env
    env zsh
    . ~/.zshrc
elif [ "$TEST_CURRENT_SHELL" = "bash" ]; then
    . ~/.bashrc
fi