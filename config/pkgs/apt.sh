#!/usr/bin/env bash


sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
sudo cp sources.list /etc/apt/sources.list
sudo apt-get update

pkgs='
cloc subversion axel xsel zsh tmux vim ctags git g++ tree python tig curl
valgrind cgdb python-setuptools
'
sudo apt-get -y install $pkgs

