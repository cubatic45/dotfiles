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

# Retrieve the token
github-copilot-cli auth

# View the token
cat ~/.copilot-cli-access-token
