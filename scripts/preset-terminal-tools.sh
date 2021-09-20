#!/bin/bash
#=================================================
# File name: preset-terminal-tools.sh
# System Required: Linux
# Version: 1.0
# Lisence: MIT
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================

mkdir -p files/root
pushd files/root

## Install oh-my-zsh
# Clone oh-my-zsh repository
git clone https://github.com/robbyrussell/oh-my-zsh ./.oh-my-zsh

# Install extra plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ./.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ./.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ./.oh-my-zsh/custom/plugins/zsh-completions

# Get .zshrc dotfile
cp ../../../data/zsh/.zshrc .

popd
ls

mv package/base-files/files/bin/ys.zsh-theme files/root/.oh-my-zsh/themes/ys.zsh-theme
find . -type f -name 'ys.zsh-theme' -exec echo -e $(readlink -f {}) \;
echo -e "=== list of files directories ==="
ls -R files
echo -e "=== list of package/base-files/files directories ==="
ls -R package/base-files/files
echo -e "=== end of listing files ==="
