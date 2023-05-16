#! /bin/bash

echo "Installing apt packages"
sudo apt-get -y update
sudo apt-get -y install curl git \
	libfontconfig1-dev libfontconfig1 libfreetype-dev libfreetype6 \
	libharfbuzz-dev libx11-xcb-dev \
	libxcb-render0-dev libxcb-render0 libxcb-shape0-dev libxcb-shape0 \
	libxcb-xfixes0-dev libxcb-xfixes0 \
	asciidoctor python3 python3-pip universal-ctags || exit

# [[ -x "/usr/bin/uname" ]] && UNAME="/usr/bin/uname"
# [[ -x "/bin/uname" ]] && UNAME="/bin/uname"
# OSRELEASE=$("${UNAME}" -r)

echo "Installing ripgrep from github"
cd "${HOME}" || exit
mkdir -p "${HOME}/software/archives"
cd "${HOME}/software/archives" || exit
curl -OL https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
sudo dpkg -i "${HOME}/software/archives/ripgrep_13.0.0_amd64.deb"

echo "Installing fd from github"
# provides faster find version, not available for Ubuntu 18.04
cd "${HOME}" || exit
mkdir -p "${HOME}/software/archives"
cd "${HOME}/software/archives" || exit
curl -OL https://github.com/sharkdp/fd/releases/download/v8.7.0/fd_8.7.0_amd64.deb
sudo dpkg -i "${HOME}/software/archives/fd_8.7.0_amd64.deb"

echo "Installing bat from github"
# provides syntax highlighting pager
cd "${HOME}" || exit
mkdir -p "${HOME}/software/archives"
cd "${HOME}/software/archives" || exit
curl -OL https://github.com/sharkdp/bat/releases/download/v0.23.0/bat_0.23.0_amd64.deb
sudo dpkg -i "${HOME}/software/archives/bat_0.23.0_amd64.deb"

echo "Installing bat-extras from github"
cd "${HOME}" || exit
git clone --depth 1 https://github.com/eth-p/bat-extras.git "${HOME}/.bat"
cd "${HOME}/.bat" || exit
./build.sh --no-manuals --no-verify

echo "Installing fzf from github"
# needs to come before zsh, as we are sourceing completion & keybindings there
cd "${HOME}" || exit
git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"
"${HOME}/.fzf/install" --no-key-bindings --no-completion --no-update-rc --no-bash --no-zsh --no-fish

echo "Installing shellcheck from github"
mkdir -p "${HOME}/software"
cd "${HOME}/software" || exit
scversion="stable" # or "v0.4.7", or "latest"
curl -sL "https://github.com/koalaman/shellcheck/releases/download/${scversion?}/shellcheck-${scversion?}.linux.x86_64.tar.xz" | tar -xJ
# sudo cp "shellcheck-${scversion}/shellcheck" /usr/bin/

if ! fnm -V >/dev/null 2>&1; then
	echo "Installing the fast Node Manager (fnm)"
	cd "${HOME}" || exit
	curl -fsSL https://github.com/Schniz/fnm/raw/master/.ci/install.sh | bash -s -- --skip-shell
fi

if ! rustup -V >/dev/null 2>&1; then
	echo "Installing rust"
	curl https://sh.rustup.rs -sSf | sh -s -- -y
	export PATH="${HOME}/.cargo/bin:${PATH}"
	rustup default stable
fi

echo "Installing silicon"
cargo install silicon
