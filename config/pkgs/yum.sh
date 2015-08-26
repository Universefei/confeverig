#!/usr/bin/env bash

pkgs='cloc subversion axel xsel zsh vim ctags git gcc-c++ tree python tig curl rubygems'

sudo yum install $pkgs

# install tmux
wget http://downloads.sourceforge.net/tmux/tmux-1.9a.tar.gz -O tmux.tar.gz && \
    tar -zxvf tmux.tar.gz   && \
    cd tmux-1.9a && ./configure && make && sudo make install && rm ../tmux-1.9a.tar.gz .
