#!/bin/sh

sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt -y upgrade

PKGS="neovim stow tree fzf silversearcher-ag"

PYTHON_BUILD_DEPS="make build-essential libssl-dev zlib1g-dev\
 libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm\
 libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev\
 libffi-dev liblzma-dev"

sudo apt install -y $PKGS $PYTHON_BUILD_DEPS

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.9.0
