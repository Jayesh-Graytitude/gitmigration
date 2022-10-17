#!/bin/bash
#
#############################################################
# This step accepts and validates inputs for required       #
# USS directories and files.                                #
# User Input:                                               #
#      1. USS path to clone the newly created empty repo    #
#      2. Path to migrate.sh utility                        #
#      3. Absolute path for migration.txt file              #
#############################################################
#
echo "** Enter USS path to clone the newly created application Git repo"
read -p "USS Path for Git repository: " ussgitpath
echo $ussgitpath
#
if [ -d $ussgitpath ]; then
    echo "** USS path for clonning new Git repository is present...continuing"
else
    echo "** Error: $ussgitpath not found. Please start again with a valid path to clone"
  exit 1
fi
#
echo "** Enter USS path for migrate.sh utility"
read -p "USS Path for migration utility: " ussmigrutl
echo $ussmigrutl
#
if [ -f $ussmigrutl ]; then
    echo "** Migration utility is present...continuing"
else
    echo "** Error: $ussmigrutl not found. Please start again with a valid path for migration utility"
  exit 1
fi
#
echo "** Enter absolute path for migrate mapping file"
read -p "USS Path for mapping file: " ussmapfil
echo $ussmapfil
#
if [ -f $ussmapfil ]; then
    echo "** Mapping file is present...continuing"
else
    echo "**Error: $ussmapfil not found. Please start again with a valid path for mapping file for migration"
  exit 1
fi
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
echo "** Enter details to create new Git repository"
read -p "Reponame: " reponame
read -sp "Github User: " user
read -sp "Github Token: " token
#
FullRepoUrl="https://github.com/${user}/${reponame}"
tempreponame=(${FullRepoUrl//.git/ })
GitResponce=$(curl -s -o /dev/null -I -w "%{http_code}" $tempreponame)
#
if [ $GitResponce == '200' ]; then
    echo "** Git repository ${$tempreponame} already exists....Choose a new name or delete manually and run the script again"
	exit 1
else
    echo "** Git repo name is available to create as a new one"
	NewRepoUrl=$(curl -X POST -u $user:$token https://api.github.com/user/repos -d \
			'{"name": "'$reponame'","description":"Creating new repository '$reponame'","auto_init":"true","public":"true"}' \
			| grep -m 1 clone | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*")
	echo "** New Git repository ${NewRepoUrl} created successfully"
fi
#
#############################################################
# Below step clones the newly created GitHub repo to local  #
# USS path based on user input.                             #
# User Input:                                               #
#      1. USS path to clone the newly created empty repo    #
#############################################################
#
cd $ussgitpath
pwd
git clone $NewRepoUrl
#
#############################################################
# This step triggers migration process for the application. #
#############################################################
#
cd "${ussgitpath}/temptest"
sh migrate.sh
echo "** Migration completed....please verify"
exit

