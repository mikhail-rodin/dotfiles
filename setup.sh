#!/bin/bash
mkdir $HOME/dotfile-repo && git init --bare $HOME/dotfile-repo && echo "created a bare git repo in a 'dotfile-repo' dir for backing up dotfiles"
echo "alias config='/usr/bin/git --git-dir=$HOME/dotfile-repo --work-tree=$HOME'" >> $HOME/.bashrc && echo "now there's a 'config' command to manage a dotfile repo; use the same way as 'git'"
