#! /bin/bash

echo "Installing node"
source "${HOME}/.fnm.sh"
fnm install 'lts/*'
fnm default lts-latest

echo "Installing yarn"
cd "${HOME}" || exit
npm install --global yarn
