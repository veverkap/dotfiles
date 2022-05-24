#!/bin/bash

exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x

PACKAGES_NEEDED="\
    bat \
    fuse \
    dialog \
    apt-utils \
    exa \
    libfuse2"

if ! dpkg -s ${PACKAGES_NEEDED} > /dev/null 2>&1; then
    if [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ | wc -l)" = "0" ]; then
        sudo apt-get update
    fi
    sudo echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
    sudo apt-get -y -q install ${PACKAGES_NEEDED}
fi
sudo modprobe fuse
sudo groupadd fuse
sudo usermod -a -G fuse "$(whoami)"
ln -s $(pwd)/tmux.conf $HOME/.tmux.conf
ln -s $(pwd)/vimrc $HOME/.vimrc
ln -s $(pwd)/vim $HOME/.vim
ln -s $(pwd)/emacs $HOME/.emacs
ln -s $(pwd)/screenrc $HOME/.screenrc
rm -f $HOME/.zshrc
ln -s $(pwd)/zshrc $HOME/.zshrc
ln -s $(pwd)/bash_profile $HOME/.bash_profile

sudo chsh -s "$(which zsh)" "$(whoami)"