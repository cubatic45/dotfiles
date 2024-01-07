#!/bin/bash

if ! command -v npm &> /dev/null
then
    echo "npm is not installed. Please install npm first."
    exit
fi

if ! command -v github-copilot-cli &> /dev/null
then
    echo "github-copilot-cli is not installed. Installing..."
    npm i @githubnext/github-copilot-cli -g
fi

# Check if the token file exists
if [ -f ~/.copilot-cli-access-token ]; then
    echo "Existing token: $(cat ~/.copilot-cli-access-token)"
    read -p "Do you want to reauthorize? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi
fi

# Retrieve the token
github-copilot-cli auth

# View the token
cat ~/.copilot-cli-access-token
