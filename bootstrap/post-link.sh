#! /usr/bin/env bash

if ! node --version >/dev/null 2>&1; then
	echo "Installing node"
	# source "${HOME}/.path.d/20_fnm.sh"
	# fnm install 'lts/*'
	# fnm default lts-latest
	rtx install node@latest
fi

if ! yarn --version >/dev/null 2>&1; then
	echo "Installing yarn"
	cd "${HOME}" || exit
	npm install --global yarn
fi

echo "Updating theme caches"
bat cache --build 1>/dev/null
cd "${HOME}/.config/silicon" || exit

# paths are not refreshed yet
source "${HOME}/.path.d/10_rust.bash"
# now it will take silicon from HOME/.cargo under linux
# or from /opt/homebrew/ on macOS
silicon --build-cache 1>/dev/null
