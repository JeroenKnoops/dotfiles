#!/usr/bin/env bash

echo "Updating system"
sudo apt -y update
sudo apt -y upgrade
echo "----- done"

echo "installing dependencies"
sudo apt -y install git
sudo apt -y install curl
sudo apt -u install wmctrl x11-utils cmake git-lfs build-essential libsdl2-dev clang clang-format clangd libssl-dev
echo "----- done"

echo "install fonts"
sudo apt -y install fonts-hack
sudo apt -y install fonts-firacode
echo "----- done"

echo "install an evil language"
sudo apt -y install python3-pip
echo "----- done"

echo "install another evil language"
sudo apt -y install npm 
mkdir $HOME/.npm-global
npm config set prefix '~/.npm-global'
echo "----- done"

echo "install a beautiful language"
curl https://sh.rustup.rs -sSf | sh -s -- -y
echo "----- done"

echo "installing a serious editor"
bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/fc6873809934917b470bff1b072171879899a36b/utils/installer/install-neovim-from-release)
echo "----- done"

echo "installing an even more serious editor"
LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/fc6873809934917b470bff1b072171879899a36b/utils/installer/install.sh)
echo "----- done"

