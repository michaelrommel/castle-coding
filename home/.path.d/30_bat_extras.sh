#! /bin/bash

ARCH=$(uname -m)
OS=$(uname -o)

if [[ "${OS}" == "Darwin" ]]; then
	if [[ "${ARCH}" == "arm64" ]]; then
		# homebrew is installed in /opt/homebrew
		WHERE=${HOME}/.bat/src
	else
		# homebrew is installed under /usr/local
		WHERE=${HOME}/.bat/src
	fi
else
	WHERE=${HOME}/.bat/src
fi

# Setup bat-extras
# ----------------
if [[ ! "$PATH" == *${WHERE}* ]]; then
	export PATH="${PATH:+${PATH}:}${WHERE}"
fi
