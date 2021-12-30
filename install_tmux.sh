#!/bin/bash
set -e
pushd ~
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
popd
# Expects to be in the dotfiles repo
ln -sv $PWD/tmux.conf.local ~/.tmux.conf.local

