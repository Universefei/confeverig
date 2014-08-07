#!/usr/bin/env bash

# install.sh:install my customed configuration

###############################################################################
#                                                                             #
#        confeverig 1.00 (c) by Fei Lunzhou 2013                                #
#        https://github.com/Universefei/confeverig                              #
#                                                                             #
#        Created: 2013/09/21                                                  #
#        Last Updated: 2013/10/23                                             #
#                                                                             #
#        confeverig is released under the GPL license.                          #
#        See LICENSE file for details.                                        #
#                                                                             #
#        1. install packages                                                  #
#        2. install Dropbox                                                   #
#        3. about vim editer                                                  #
#        4. replace ~/.tmux.conf                                              #
#        5. replace ~/.zshrc                                                  #
#        6. install oh-my-zsh                                                 #
#        7. user tailorded configuration                                      #
#        8. git clone my github repoes                                        #
#        9. change shell to zsh                                               #
#                                                                             #
###############################################################################


# set global variable
MYCONF="$HOME/confeverig"
LIB="${MYCONF}/lib"
TEMPLATE="${MYCONF}/template"


# load library
for conf_file in ${LIB}/*
do
	echo "sourcing libs"
  source $conf_file
done

# ==============================================================================
# 1. Install Packages
# ==============================================================================

packages='zsh tmux vim ctags git g++ tree python tig curl rubygems'

which git &> /dev/null
if [[ $? != 0 ]]; then
	yellow "you havn't install git
	please install git before execute this script"
	#exit #needn't exit 'cause will install later
fi
# detect environment and install packages
cat /etc/issue | grep -E "Ubuntu|Debian" &> /dev/null
if [[ $? == 0 ]]; then
	sudo apt-get install ${packages}
fi

cat /etc/issue | grep -E "Fedora|CentOS" &> /dev/null
if [[ $? == 0 ]]; then
	sudo yum install ${packages}
fi

# ==============================================================================
# 2. Install Dropbox
# ==============================================================================

# all commands below are from guidance of dropbox homepage.
# references:https://www.dropbox.com/install?os=lnx
while true
do
	read -p "DO YOU WANT TO INSTALL Dropbox? [Yes]or[No]?" RESP
	case $RESP in
	Y|y|yes|Yes|YES)
		(cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -) &&
		echo 'Dropbox download COMPLETED!'
		yellow 'run ~/.dropbox-dist/dropboxd'
		break
		;;
	N|n|no|No|NO)
		break
		;;
	*)
		echo ' INPUT ERROR! PLEASE INPUT AGAIN!'
		continue
		;;
	esac
done


# ==============================================================================
# 3. configuration of VIM editor
# ==============================================================================

# Install Vundle for VIM plugins management
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

if [[ -f ~/.vimrc || -h ~/.vimrc ]]; then
	mv ~/.vimrc ~/.vimrc.orig
	red "original .vimrc backed up!"
fi

if (cp $TEMPLATE/_vimrc ~/.vimrc); then
	red "vim updated to my customed config!"
fi

# ==============================================================================
# 4. Replace ~/.tmux.conf
# ==============================================================================

if [[ -f ~/.tmux.conf || -h ~/.tmux.conf ]]; then
	mv ~/.tmux.conf ~/.tmux.conf.orig
	red "original .tmux.conf backed up!"
fi

cp $TEMPLATE/_tmux.conf ~/.tmux.conf &&
	red "tmux updated to my customed config!"

# ==============================================================================
# 5. Replace ~/.zshrc
# ==============================================================================

if [[ -f ~/.zshrc || -h ~/.zshrc ]]; then
	yellow ".zshrc conf file exsit!  +++++  backing up it to ~/.zshrc.pre"
	mv ~/.zshrc ~/.zshrc.pre
fi

cp $TEMPLATE/_zshrc ~/.zshrc &&
	yellow ".zshrc was updated via /confeverig/template/zshrc!"

# ==============================================================================
# 6. Install oh-my-zsh
# ==============================================================================

ls -a ~ | grep ".oh-my-zsh" &> /dev/null || {
		git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
}

yellow "Using the oh my zsh template file and adding it to ~/.zshrc"
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc.from.ohmyzsh

yellow "Copying your current PATH and adding it to the end of ~/.zshrc for you"
# why needed this sentence? DO NOT KNOW
echo 'export PATH=$PATH:$PATH' >> ~/.zshrc


# ==============================================================================
# 7. User tailorded configuration
# ==============================================================================

[[ ! -d ~/.zsh_confeverig ]] && {
	mkdir ~/.zsh_confeverig
	echo "no .zsh_confeverig exist!have created one"
	} ||
	echo " .zsh_confeverig dir exist!"

for wtf in ${TEMPLATE}/*
do
	filename=$(basename ${wtf})
	if [[ -d ${wtf} ]];then
		[[ -d ~/.zsh_confeverig/${filename} ]] && {
			mv  ~/.zsh_confeverig/${filename} ~/.zsh_confeverig/${filename}.orig &> /dev/null &&
			echo "${filename} backup!" ||
			echo "DO NOT BACKUP!"
			}
		cp -rf ${wtf} ~/.zsh_confeverig/ &&
		echo "${wtf} moved!"
	fi	
done
unset filename
# prompt for tailored configuration
echo "you can make symblic link from ~/.zsh_confeverig/*/available to enabled to
customize your config!!"
# TODO:need to implement interactive dialog to provide customization
cp ${TEMPLATE}/zshrc_option.bash  ~/.zsh_confeverig/zshrc_option.bash 
#echo 'source ~/.zsh_confeverig/zshrc_option.bash' >> ~/.zshrc


# ==============================================================================
# 8. Git clone my remote git repos
# ==============================================================================


# ==============================================================================
# 9. Draw Show
# ==============================================================================

green ' ________       .__  ___                             __                      '
green '|    ____|      |__\|   |                           |  |                     '
green '|   |     _____  __ |   |    __    _  _ ____  ______|  | ___  _____  __    _.'
green '|   |___./ __  \|  ||   |   |  |  | |/ "    |/      |   "   |/     \|  |  | |'
green '|   ____| (__) ||  ||   |   |  |  | |   __  | ___  /|   ___ |   __  |  |  | |'
green '|   |   |   ___||  ||   |___|  |__| |  |  | |  /  /_|  |  | |  (__) |  |__| |'
green '|   |   \  \___ |  ||       |       |  |  | | /     |  |  | |       |       |'
green '|___|    \_____/|__|\___,___|\____,_|__|  \_|/_____/|__|  |_|\_____/ \____,_|'


# ==============================================================================
# 10. Change shell to zsh
# ==============================================================================

red "oh-my-zsh configuration completed!!!"
# because let out this command,spend me 3 days to find problems,why the line below can not ignored?
# I guess /usr/bin/env zsh execute a command but not source ~/.zshrc so must source it explicitly
# the errors occured before is rusult from that ~/.zshrc is zsh syntax but not bash syntax
/usr/bin/env zsh
source ~/.zshrc
red "changing your default shell to zsh!!!!!!!"
sudo chsh -s `which zsh`
# chsh -s $(which zsh) #this line has the same impact


