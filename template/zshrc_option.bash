#!/usr/bin/env bash
# user customed config file

# zshrc_option.bash:this file implement functions below:
#	1.set ENV variables 
# 2.source user customed files when user login

echo 'sourcing zshrc_option.bash'
# login-shell source file should echo anything??
#echo "THESE ARE USER OPTIONAL CONFIGURATION********************************************************"

# setting ENV variables
MYZSH="$HOME/.zsh_myconfig"

# source user tailored files
for selected in ${MYZSH}/aliases/enabled/*
do
	source ${selected}
done

	
