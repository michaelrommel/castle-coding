#! /bin/bash

echo "Installing node"
source "${HOME}/.path.d/20_fnm.sh"
fnm install 'lts/*'
fnm default lts-latest

echo "Installing yarn"
cd "${HOME}" || exit
npm install --global yarn
