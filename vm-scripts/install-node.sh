#!/usr/bin/env bash

# Check if Node has been installed
node -v > /dev/null 2>&1
NODE_IS_INSTALLED=$?

if [ $NODE_IS_INSTALLED -eq 0 ]
then
    echo "Node already installed"
    exit 0
fi

# Install node
apt-get update > /dev/null 2>&1
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -  > /dev/null 2>&1
apt-get install -y nodejs > /dev/null 2>&1

# Install any global php modules

if [ ! $# -eq 0 ]
then
    NPM_PACKAGES=$1
    echo "Installing global npm packages ${NPM_PACKAGES[@]}"
    npm install ${NPM_PACKAGES[@]} -g > /dev/null 2>&1
fi
