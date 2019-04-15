#!/bin/bash

# example-termtitle

# Function to set the title of the terminal for the configured environment
# See:  https://askubuntu.com/questions/22413/how-to-change-gnome-terminal-title
setTerminalTitle () {
    local title
    title=$1
    echo -ne "\033]0;${1}\007"
}

# The function can also added to the $HOME/.bashrc file and then add an alias:
# alias termtitle=setTerminalTitle
# 
# Then run this script on the command line with:
#   example-termtitle title
#   example-termtitle "title title with spaces"

# Entry point into script

if [ ! -z "$1" ]; then
    # If an argument was provided, use it to set the terminal title
    setTerminalTitle "$1"
fi
