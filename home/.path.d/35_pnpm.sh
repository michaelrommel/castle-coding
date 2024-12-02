#! /usr/bin/env bash

export PNPM_HOME="${HOME}/.local/share/pnpm"
if [[ -d "${PNPM_HOME}" && ! ":${PATH}:" == *":${PNPM_HOME}:"* ]]; then
	# path has not yet been added
	export PATH="${PNPM_HOME}:${PATH}"
fi
