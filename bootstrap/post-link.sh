#! /usr/bin/env bash

# paths for mise and shims
source "${HOME}/.path.d/50_mise.bash"
source "${HOME}/.path.d/99_default.sh"

if ! node --version >/dev/null 2>&1; then
	echo "Installing node"
	mise install node@latest
	mise use -g node@latest
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
eval "$(mise hook-env)"
# now it will take silicon from mise path under linux
# or from /opt/homebrew/ on macOS
silicon --build-cache 1>/dev/null
