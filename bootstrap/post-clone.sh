#! /usr/bin/env bash

source "${HOME}/.homesick/helper.sh"

# if we do not set those paths here, then all installed binaries
# that were installed using mise, cannot be found. We want to be able
# to rerun this script multiple times without errors
source "${HOME}/.path.d/40_go.sh"
source "${HOME}/.path.d/50_mise.bash"
source "${HOME}/.path.d/99_default.sh"
eval "$(mise hook-env)"

echo "Installing dependency packages"
if is_mac; then
	desired=(ripgrep@13.0 fd@8.7 bat@0.23 bat-extras@2023.03
		fzf@0.39 shellcheck@0.9 shfmt@3.6 fnm@1.33 silicon@0.5
		universal-ctags python@3.11 mise pyenv pyenv-virtualenv)
	missing=()
	check_brewed "missing" "${desired[@]}"
	if [[ "${#missing[@]}" -gt 0 ]]; then
		echo "(brew) installing ${missing[*]}"
		brew install "${missing[@]}"
	fi
	if ! python3 -c 'import pip;' >/dev/null 2>&1; then
		# add pip3
		python3 -mensurepip
	fi
else
	desired=(libfontconfig1-dev libfontconfig1 libfreetype-dev libfreetype6
		libharfbuzz-dev libx11-xcb-dev
		libxcb-render0-dev libxcb-render0 libxcb-shape0-dev libxcb-shape0
		libxcb-xfixes0-dev libxcb-xfixes0
		asciidoctor universal-ctags
		python3 python3-pip
		build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev
		libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev)
	missing=()
	check_dpkged "missing" "${desired[@]}"
	if [[ "${#missing[@]}" -gt 0 ]]; then
		echo "(apt) installing ${missing[*]}"
		sudo apt-get -y update
		sudo apt-get -y install "${missing[@]}"
	fi

	if ! rg -V >/dev/null 2>&1; then
		echo "Installing ripgrep from github"
		cd "${HOME}" || exit
		mkdir -p "${HOME}/software/archives"
		cd "${HOME}/software/archives" || exit
		curl -OL https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
		sudo dpkg -i "${HOME}/software/archives/ripgrep_13.0.0_amd64.deb"
	fi

	if ! fd -V >/dev/null 2>&1; then
		echo "Installing fd from github"
		# provides faster find version, not available for Ubuntu 18.04
		cd "${HOME}" || exit
		mkdir -p "${HOME}/software/archives"
		cd "${HOME}/software/archives" || exit
		curl -OL https://github.com/sharkdp/fd/releases/download/v8.7.0/fd_8.7.0_amd64.deb
		sudo dpkg -i "${HOME}/software/archives/fd_8.7.0_amd64.deb"
	fi

	if ! shfmt --version >/dev/null 2>&1; then
		echo "Installing shell formatter shfmt via go"
		go install mvdan.cc/sh/v3/cmd/shfmt@latest
	fi

	if ! bat -V >/dev/null 2>&1; then
		echo "Installing bat from github"
		# provides syntax highlighting pager
		cd "${HOME}" || exit
		mkdir -p "${HOME}/software/archives"
		cd "${HOME}/software/archives" || exit
		curl -OL https://github.com/sharkdp/bat/releases/download/v0.23.0/bat_0.23.0_amd64.deb
		sudo dpkg -i "${HOME}/software/archives/bat_0.23.0_amd64.deb"
	fi

	if [[ ! -f "${HOME}/.bat/bin/batman" ]]; then
		echo "Installing bat-extras from github"
		cd "${HOME}" || exit
		git clone --depth 1 https://github.com/eth-p/bat-extras.git "${HOME}/.bat"
		cd "${HOME}/.bat" || exit
		./build.sh --no-manuals --no-verify
	fi

	if ! fzf --version >/dev/null 2>&1; then
		echo "Installing fzf from github"
		# needs to come before zsh, as we are sourceing completion & keybindings there
		cd "${HOME}" || exit
		git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"
		"${HOME}/.fzf/install" --no-key-bindings --no-completion --no-update-rc --no-bash --no-zsh --no-fish
	fi

	if ! shellcheck -V >/dev/null 2>&1; then
		echo "Installing shellcheck from github"
		mkdir -p "${HOME}/software"
		cd "${HOME}/software" || exit
		scversion="stable" # or "v0.4.7", or "latest"
		curl -sL "https://github.com/koalaman/shellcheck/releases/download/${scversion?}/shellcheck-${scversion?}.linux.x86_64.tar.xz" | tar -xJ
	fi
fi

if ! rustup -V >/dev/null 2>&1; then
	echo "Installing rust"
	# mise plugin install --yes rust
	mise install rust@latest
	mise use -g rust@latest
	# install shell completions
	mkdir -p "${HOME}/.rust/shell"
	rustup completions bash >"${HOME}/.rust/shell/completion_rustup.bash"
	rustup completions bash cargo >"${HOME}/.rust/shell/completion_cargo.bash"
	rustup completions zsh >"${HOME}/.rust/shell/_rustup"
	rustup completions zsh cargo >"${HOME}/.rust/shell/_cargo"
fi

if ! silicon -V >/dev/null 2>&1; then
	echo "Installing silicon"
	cargo install silicon
fi
