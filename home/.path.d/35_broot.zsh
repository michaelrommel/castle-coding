#! /usr/bin/env zsh

RET=$(broot --version 2>/dev/null)
if [[ $? -ne 0 ]]; then
	exit 0
fi

# This function starts broot and executes the command
# it produces, if any.
# It's needed because some shell commands, like `cd`,
# have no useful effect if executed in a subshell.
function br {
	local cmd cmd_file code
	cmd_file=$(mktemp)
	if broot --outcmd "$cmd_file" "$@"; then
		cmd=$(<"$cmd_file")
		command rm -f "$cmd_file"
		eval "$cmd"
	else
		code=$?
		command rm -f "$cmd_file"
		return "$code"
	fi
}

if [[ ! -f "${HOME}/.config/broot/launcher/installed-v4" ]]
	broot --set-install-state installed
fi
