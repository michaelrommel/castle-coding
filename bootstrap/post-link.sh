#! /usr/bin/env bash

if ! node --version >/dev/null 2>&1; then
	echo "Installing node"
	# paths for rtx and shims
	source "${HOME}/.path.d/50_rtx.bash"
	source "${HOME}/.path.d/99_default.sh"
	rtx plugin install node
	rtx install node@latest
	rtx use -g node@latest
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
# paths for rtx and shims
source "${HOME}/.path.d/50_rtx.bash"
source "${HOME}/.path.d/99_default.sh"
eval "$(rtx hook-env)"
# now it will take silicon from rtx path under linux
# or from /opt/homebrew/ on macOS
silicon --build-cache 1>/dev/null
