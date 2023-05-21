#! /bin/bash

if [[ -d "${HOME}/.cargo/bin" && ! ":${PATH}:" == *:${HOME}/.cargo/bin:* ]]; then
	# path has not yet been added
	export PATH="${HOME}/.cargo/bin:${PATH}"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && [[ -d "${HOME}/.cargo/shell" ]] && source "${HOME}/.cargo/shell/completion.bash" 2> /dev/null

