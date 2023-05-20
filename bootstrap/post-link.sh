#! /usr/bin/env bash

if ! node --version >/dev/null 2>&1; then
	echo "Installing node"
	source "${HOME}/.path.d/20_fnm.sh"
	fnm install 'lts/*'
	fnm default lts-latest
fi

if ! yarn --version >/dev/null 2>&1; then
	echo "Installing yarn"
	cd "${HOME}" || exit
	npm install --global yarn
fi

echo "Updating theme caches"
bat cache --build 1>/dev/null
cd "${HOME}/.config/silicon" || exit
"${HOME}/.cargo/bin/silicon" --build-cache 1>/dev/null
