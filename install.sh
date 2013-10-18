#!/usr/bin/env bash

# install.sh:install my customed configuration

# 1. install packages
# 2. install Dropbox
# 3. replace ~/.vimrc and install vim plugins
# 4. replace ~/.tmux.conf
# 5. replace ~/.zshrc
# 6. install oh-my-zsh
# 7. user tailorded configuration
# 8. git clone my github repoes
# 9. change shell to zsh

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


# 1. install packages
packages='zsh tmux vim ctags git g++ tree python tig curl'
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


# 2. install Dropbox
# all commands below are from guidance of dropbox homepage opened under Linux OS
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


# 3. replace ~/.vimrc and install vim plugins
if [[ -f ~/.vimrc || -h ~/.vimrc ]]; then
	mv ~/.vimrc ~/.vimrc.orig
	red "original .vimrc backed up!"
fi

if (cp $TEMPLATE/vimrc ~/.vimrc); then
	red "vim updated to my customed config!"
fi
# install pathogen from https://github.com/tpope/vim-pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -Sso ~/.vim/autoload/pathogen.vim \
    https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
# backup origin ~/.vim folder and replace with myconfig/template/vim
cp ${TEMPLATE}/vim/bundle -rf ~/.vim/bundle
# if not in .vim folder ,plan B is to git clone plugin repos in GitHub
pushd ~/.vim/bundle
git clone git@github.com:slim-template/vim-slim.git
git clone git://github.com/msanders/snipmate.vim.git
popd


# 4. replace ~/.tmux.conf
if [[ -f ~/.tmux.conf || -h ~/.tmux.conf ]]; then
	mv ~/.tmux.conf ~/.tmux.conf.orig
	red "original .tmux.conf backed up!"
fi

cp $TEMPLATE/tmux.conf ~/.tmux.conf &&
	red "tmux updated to my customed config!"


# 5. replace ~/.zshrc
if [[ -f ~/.zshrc || -h ~/.zshrc ]]; then
	yellow ".zshrc conf file exsit!  +++++  backing up it to ~/.zshrc.pre"
	mv ~/.zshrc ~/.zshrc.pre
fi

cp $TEMPLATE/zshrc ~/.zshrc &&
	yellow ".zshrc was updated via /myconfig/template/zshrc!"



# 6. install oh-my-zsh ( a coustomed zsh configuration )
ls -a ~ | grep ".oh-my-zsh" &> /dev/null || {
		git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
}

yellow "Using the oh my zsh template file and adding it to ~/.zshrc"
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc.from.ohmyzsh

yellow "Copying your current PATH and adding it to the end of ~/.zshrc for you"
# why needed this sentence? DO NOT KNOW
echo 'export PATH=$PATH:$PATH' >> ~/.zshrc


# 7. user tailorded configuration 
[[ ! -d ~/.zsh_myconfig ]] && {
	mkdir ~/.zsh_myconfig
	echo "no .zsh_myconfig exist!have created one"
	} ||
	echo " .zsh_myconfig dir exist!"

for wtf in ${TEMPLATE}/*
do
	filename=$(basename ${wtf})
	if [[ -d ${wtf} ]];then
		[[ -d ~/.zsh_myconfig/${filename} ]] && {
			mv  ~/.zsh_myconfig/${filename} ~/.zsh_myconfig/${filename}.orig &> /dev/null &&
			echo "${filename} backup!" ||
			echo "DO NOT BACKUP!"
			}
		cp -rf ${wtf} ~/.zsh_myconfig/ &&
		echo "${wtf} moved!"
	fi	
done
unset filename
# prompt for tailored configuration
echo "you can make symblic link from ~/.zsh_myconfig/*/available to enabled to
customize your config!!"
# TODO:need to implement interactive dialog to provide customization
cp ${TEMPLATE}/zshrc_option.bash  ~/.zsh_myconfig/zshrc_option.bash 
#echo 'source ~/.zsh_myconfig/zshrc_option.bash' >> ~/.zshrc


# 8. git clone my remote git repoes
# Universefei/feinote.git
[ -e ~/feinote ] || { 
				git clone git@github.com:Universefei/feinote.git ~/feinote &&
								echo 'git clone Universefei/feinote completed'
} && echo '~/feinote exsit, do NOT clone frome github'


# 9. change shell to zsh
red "oh-my-zsh configuration completed!!!"
# because let out this command,spend me 3 days to find problems,why the line below can not ignored?
# I guess /usr/bin/env zsh execute a command but not source ~/.zshrc so must source it explicitly
# the errors occured before is rusult from that ~/.zshrc is zsh syntax but not bash syntax
/usr/bin/env zsh
source ~/.zshrc
red "changing your default shell to zsh!!!!!!!"
sudo chsh -s `which zsh`
# chsh -s $(which zsh) #this line has the same impact

