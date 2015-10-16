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

ts=`date +%s`
bakdir=~/.dotfiles.bak.$ts

doIt() {
    filename=~/.$1
    if [ -f $filename ] || [ -h $filename ]; then
        [ ! -d $bakdir ] && mkdir -p $bakdir
        echo "${COLOR_RED}Found ${filename}.${COLOR_RESET} Backing up to ${bakdir}/.${1}.bak.";
        mv $filename ${bakdir}/.${1}.bak
    fi
    cp -r ${MYDOT}/$1 $filename
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

## config screen
install screenrc

## config vim
install vimrc
echo "${COLOR_GREEN}"
read -p "Install vim plugin? (y/n) " -n 1;
echo "${COLOR_RESET}"
if [ $REPLY = "Y" ] || [ $REPLY = "y" ]; then
    if [ -d ~/.vim ] || [ -h ~/.vim ]; then
        [ ! -d $bakdir ] && mkdir -p $bakdir
        echo "${COLOR_RED}Found ~/.vim.${COLOR_RESET} Backing up to ${bakdir}/.vim.bak.";
        mv ~/.vim ${bakdir}/.vim.bak
    fi
    mkdir -p ~/.vim/autoload
    mkdir -p ~/.vim/bundle
    # pathogen
    git clone --depth=1 https://github.com/tpope/vim-pathogen.git ~/.vim/vim-pathogen
    cp ~/.vim/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim
    rm -fr ~/.vim/vim-pathogen
    # Plugin auto-pairs
    git clone --depth=1 git://github.com/jiangmiao/auto-pairs.git ~/.vim/bundle/auto-pairs
    # Plugin NERD Tree
    git clone --depth=1 https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
    # Plugin vim-rails
    git clone --depth=1 git://github.com/tpope/vim-rails.git ~/.vim/bundle/vim-rails
    # solarized
    git clone --depth=1 https://github.com/altercation/vim-colors-solarized.git ~/.vim/bundle/vim-colors-solarized
    # Vundle
    git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
fi

if [ "$os" = "mac" ]; then
    echo "${COLOR_GREEN}"
    read -p "Your OS is Mac OS, need to config webserver? (y/n) " -n 1;
    echo "${COLOR_RESET}"
    if [ $REPLY = "Y" ] || [ $REPLY = "y" ]; then
        bash ${MYDOT}/apache_for_yosemite.sh
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
