#!/usr/bin/env bash



pkgs='
cloc subversion axel xsel zsh tmux vim ctags git g++ tree python tig curl
valgrind cgdb python-setuptools
'
sudo apt-get -y install $pkgs

