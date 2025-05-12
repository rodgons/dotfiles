#!/usr/bin/env bash

set -euo pipefail

read -r -p "Please provide the nodejs version you want to install: " NODEJS_VERSION
read -r -p "Please provide the golang version you want to install: " GOLANG_VERSION
read -r -p "Please provide the dotnet-core version you want to install: " DOTNETCORE_VERSION

printf '\033[0;32mSetting no password sudo...\033[0m\n'
echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers >/dev/null

if ! command -v /opt/homebrew/bin/brew &> /dev/null; then
    printf '\033[0;32mInstalling Homebrew...\033[0m\n'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

if ! command -v brew &> /dev/null; then
    printf '\033[0;31mHomebrew is required but not found\033[0m\n' >&2
    exit 1
fi

printf '\033[0;32mInstalling asdf...\033[0m\n'
brew install asdf

# shellcheck disable=SC1090
. /opt/homebrew/opt/asdf/libexec/asdf.sh

printf '\033[0;32mInstalling asdf plugins...\033[0m\n'
asdf plugin add nodejs
asdf plugin add golang
asdf plugin add dotnet-core

printf '\033[0;32mInstalling asdf versions...\033[0m\n'

printf '\033[0;32minstalling nodejs %s...\033[0m\n' 14.15.5
asdf install nodejs 14.15.5

printf '\033[0;32minstalling nodejs %s...\033[0m\n' "$NODEJS_VERSION"
asdf install nodejs "$NODEJS_VERSION"

printf '\033[0;32minstalling golang %s...\033[0m\n' "$GOLANG_VERSION"
asdf install golang "$GOLANG_VERSION"

printf '\033[0;32minstalling dotnet-core %s...\033[0m\n' "$DOTNETCORE_VERSION"
asdf install dotnet-core "$DOTNETCORE_VERSION"

if ! command -v ansible-playbook &> /dev/null; then
    printf '\033[0;32mInstalling Ansible...\033[0m\n'
    brew install ansible
fi

if ! command -v ansible-playbook &> /dev/null; then
    printf '\033[0;31mansible-playbook is required but not found\033[0m\n' >&2
    exit 1
fi

SRC_DIR="${CHEZMOI_SOURCE_DIR:-$PWD}"

if [ ! -f "$SRC_DIR/dot_bootstrap/setup.yml" ]; then
    printf '\033[0;31mCannot find dot_bootstrap/setup.yml\033[0m\n' >&2
    exit 1
fi

if ! ansible-playbook -i "$SRC_DIR/dot_bootstrap/inventory" "$SRC_DIR/dot_bootstrap/setup.yml" --ask-become-pass; then
    printf '\033[0;31mansible-playbook failed\033[0m\n' >&2
    exit 1
fi

printf '\033[0;32mReseting sudo...\033[0m\n'
sudo sed -i.bak "/^$(whoami) /d" /etc/sudoers
