#!/bin/sh

apt update
apt -y upgrade

PKGS="neovim stow tree fzf silversearcher-ag"

PYTHON_BUILD_DEPS="make build-essential libssl-dev zlib1g-dev\
 libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm\
 libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev\
 libffi-dev liblzma-dev"

apt install -y $PKGS $PYTHON_BUILD_DEPS

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
