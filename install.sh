#!/bin/sh

apt update
apt -y upgrade

apt install -y neovim stow tree fzf silversearcher-ag build-essential\

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
