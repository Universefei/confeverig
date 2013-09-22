#!/usr/bin/env bash

# install.sh:install my customed configuration

# set global variable
MYCONF="$HOME/myconfig"
LIB="${MYCONF}/lib"
TEMPLATE="${MYCONF}/template"

# load library
for conf_file in ${LIB}/*
do
	echo "sourcing libs"
	source $conf_file
done

# install packages
which git &> /dev/null
if [[ $? != 0 ]]
then 
	yellow "you havn't install git
	please install git before execute this script"
	#exit #needn't exit 'cause will install later 
fi

# detect environment and install packages
cat /etc/issue | grep -E "Ubuntu|Debian" &> /dev/null
if [[ $? == 0 ]]
then
	sudo apt-get install zsh tmux vim ctags git g++ tree
fi

cat /etc/issue | grep -E "Fedora|CentOS" &> /dev/null
if [[ $? == 0 ]]
then
	sudo yum install zsh tmux vim ctags git g++ tree
fi

# backup original configs and set new conf files
if [[ -f ~/.vimrc || -h ~/.vimrc ]];
then
	mv ~/.vimrc ~/.vimrc.orig
	red "original .vimrc backed up!"
fi

if (cp $TEMPLATE/vimrc ~/.vimrc);
then
	red "vim updated to my customed config!"
fi

if [[ -f ~/.tmux.conf || -h ~/.tmux.conf ]];
then
	mv ~/.tmux.conf ~/.tmux.conf.orig
	red "original .tmux.conf backed up!"
fi

cp $TEMPLATE/tmux.conf ~/.tmux.conf &&
	red "tmux updated to my customed config!"

# install oh-my-zsh ( a coustomed zsh configuration )
ls -a ~ | grep ".oh-my-zsh" &> /dev/null || {
		git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
}

if [[ -f ~/.zshrc || -h ~/.zshrc ]]
then
	yellow ".zshrc conf file exsit!  +++++  backing up it to ~/.zshrc.pre"
	mv ~/.zshrc ~/.zshrc.pre
fi

yellow "Using the oh my zsh template file and adding it to ~/.zshrc"
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

yellow "Copying your current PATH and adding it to the end of ~/.zshrc for you"
echo "export PATH=\$PATH:$PATH" >> ~/.zshrc

red "changing your default shell to zsh!!!!!!!"
chsh -s `which zsh`
# chsh -s $(which zsh) #this line has the same impact

/usr/bin/env zsh
source ~/.zshrc
red "oh-my-zsh configuration completed!!!"
