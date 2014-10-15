#!/usr/bin/env bash

# install.sh:install my customed configuration

###############################################################################
#                                                                             #
#        confeverig 1.00 (c) by Fei Lunzhou 2013                              #
#        https://github.com/Universefei/confeverig                            #
#                                                                             #
#        Created: 2013/09/21                                                  #
#        Last Updated: 2013/10/23                                             #
#                                                                             #
#        confeverig is released under the GPL license.                        #
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
# 1. Install Packages via package management tools
# ==============================================================================

# 1> Set packages needed to be installed on each OS.
homebrewPKGlist='subversion axel xsel zsh tmux vim ctags git gcc-c++ tree python tig curl rubygems'
aptgetPKGlist='subversion axel xsel zsh tmux vim ctags git g++ tree python tig curl gem'
yumPKGlist='subversion axel xsel zsh tmux vim ctags git gcc-c++ tree python tig curl rubygems'

# 2> Detect environment. 
OS='unkonwn'
UNAMESTR=`uname`

if [[ "$UNAMESTR" == 'Darwin' ]];then
    OS='darwin'
elif [[ "$UNAMESTR" == 'FreeBSD' ]];then
    OS='freeBSD'
fi
cat /etc/issue | grep -E "Ubuntu|Debian" &> /dev/null
if [[ $? == 0 ]]; then
    OS='Linux-Debian'
fi
cat /etc/issue | grep -E "Fedora|CentOS" &> /dev/null
if [[ $? == 0 ]]; then
    OS='Linux-Redhat'
fi

# 3> Install packages.
if [[ $OS == 'darwin' ]];then
    brew install ${homebrewPKGlist}
elif [[ $OS == 'Linux-Debian' ]];then
	sudo apt-get install ${aptgetPKGlist}
elif [[ $OS == 'Linux-Redhat' ]];then
	sudo yum install ${yumPKGlist}
fi

# 4> Check if installed git.
which git &> /dev/null
if [[ $? != 0 ]]; then
	yellow "you havn't install git
	please install git before execute this script"
	#exit #needn't exit 'cause will install later
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

# 1> Install Vundle for VIM plugins management.
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# 2> Handle .vimrc
if [[ -f ~/.vimrc || -h ~/.vimrc ]]; then
	mv ~/.vimrc ~/.vimrc.orig
	red "original .vimrc backed up!"
fi
if (cp $TEMPLATE/_vimrc ~/.vimrc); then
	red "vim updated to my customed config!"
fi

# Copy plugins snipmate.vim with personal configuration.
# SEE:https://github.com/scrooloose/snipmate-snippets
if (cp -rf $TEMPLATE/vim/bundle/snipmate.vim ~/.vim/bundle/); then
	red "Copy snipmate-----------------------------------------------------done"
fi

# ==============================================================================
# 4.Tmux 
# ==============================================================================

# 1> Replace ~/.tmux.conf
if [[ -f ~/.tmux.conf || -h ~/.tmux.conf ]]; then
	mv ~/.tmux.conf ~/.tmux.conf.orig
	red "original .tmux.conf backed up!"
fi

cp $TEMPLATE/_tmux.conf ~/.tmux.conf &&
	red "tmux updated to my customed config!"
    
# ==============================================================================
# 5.Zsh and oh-my-zsh 
# ==============================================================================

# check if installed zsh using package management tools.
#which zsh &> /dev/null
#if [[ $? != 0 ]];then
#    red "YOU HAVEN'T INSTALL ZSH CORRECTLY"
#elif [[ $? == 0 ]];then

    # 1> Replace ~/.zshrc
    if [[ -f ~/.zshrc || -h ~/.zshrc ]]; then
        yellow ".zshrc conf file exsit!  +++++  backing up it to ~/.zshrc.pre"
        mv ~/.zshrc ~/.zshrc.pre
    fi
    cp $TEMPLATE/_zshrc ~/.zshrc &&
        yellow ".zshrc was updated via /confeverig/template/zshrc!"

    # 2> Install oh-my-zsh
    ls -a ~ | grep ".oh-my-zsh" &> /dev/null || {
            git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    }
    yellow "Using the oh my zsh template file and adding it to ~/.zshrc"
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc.from.ohmyzsh
    yellow "Copying your current PATH and adding it to the end of ~/.zshrc for you"
    # why needed this sentence? DO NOT KNOW
    echo 'export PATH=$PATH:$PATH' >> ~/.zshrc

    # 3> Change default shell to zsh
    red "changing your default shell to zsh!!!!!!!"
    sudo chsh -s `which zsh` # chsh -s $(which zsh) #this line has the same impact
#fi


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

green '   _____                _______                            ___         '
green '  /     \               |      |                           |__\        '
green '  |  ____| ____   _ ____|  ____| ____  __   __  ____ __ __ ___  ______ '
green '  |  |    /    \ / "    |  |___./ __ \|  | /  ./ __ \| "  \|  |/      |'
green '  |  |   |      |   _   |      | (__) |  |/  /| (__) |  __/|  |   __  |'
green '  |  |__ |  ()  |  | |  |  ____|   ___|  T  / |   ___|  |  |  |  (__) |'
green '  |     "|      |  | |  |  |   \  \___|    /  \  \___|  |  |  |       |'
green '  \_____/ \____/|__| \__|__|    \____/|___/    \____/|__|  |__|____   |'
green '                                                                   |  |'
green '  _________________________________________________________________|  |'
green '  |___________________________________________________________________|'
                             

# ==============================================================================
# 10. Refresh configuration
# ==============================================================================

red "oh-my-zsh configuration completed!!!"
# because let out this command,spend me 3 days to find problems,why the line below can not ignored?
# I guess /usr/bin/env zsh execute a command but not source ~/.zshrc so must source it explicitly
# the errors occured before is rusult from that ~/.zshrc is zsh syntax but not bash syntax
/usr/bin/env zsh
source ~/.zshrc

