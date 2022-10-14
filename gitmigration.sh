#!/bin/bash
#
#############################################################
# This step accepts below input from the user and creates a #
# new GItHUb repository for application migration from      #
# Mainframe.                                                #
# User Input:                                               #
#      1. New GitHub repository name (Reponame)             #
#      2. Github User Name (Github User)                    #
#      3. Github Personal Access Token (Github Token)       #
#############################################################
#
echo "Enter details to create new Git repository"
read -p "Reponame: " reponame
read -sp "Github User: " user
read -sp "Github Token: " token
#
echo $reponame
#
temp=$(curl -X POST -u $user:$token https://api.github.com/user/repos -d \
	'{"name": "'$reponame'","description":"Creating new repository '$reponame'","auto_init":"true","public":"true"}' \
       | grep -m 1 clone | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*")
#
echo $temp
#
#############################################################
# Below step clones the newly created GitHub repo to local  #
# USS path based on user input.                             #
# User Input:                                               #
#      1. USS path to clone the newly created empty repo    #
#############################################################
#
echo "Enter USS path to clone the newly created repo"
read -p "USS Path: " usspath
echo $usspath
exit

