#!/bin/bash

# ask for the user name
read -p 'Enter the username: ' USER_NAME

# ask for the real name
read -p 'Enter the name of the person who this account is for: ' COMMENT

# ask for password
read -p 'Enter the password to use for the account: ' PASSWORD

# create the user
useradd -c "${COMMENT}" -m ${USER_NAME}

# set the password for user
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# force password change on first login
passwd -e ${USER_NAME}