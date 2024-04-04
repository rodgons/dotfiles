#!/usr/bin/env bash

set -euo pipefail

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

printf '\033[0;32minstalling latest nodejs...\033[0m\n'
asdf install nodejs $(asdf nodejs resolve lts --latest-available)

printf '\033[0;32minstalling latest golang...\033[0m\n'
asdf install golang $(asdf list all golang | tail -n 1)

printf '\033[0;32minstalling latest dotnet-core...\033[0m\n'
asdf install dotnet-core $(asdf list all dotnet-core | grep "^8" | tail -n 1)

printf '\033[0;32mSetting asdf global versions...\033[0m\n'
# there is a bug that for some reason the first time this command is ran
# the lts version is not the full path
asdf nodejs resolve lts --latest-available
asdf global nodejs $(asdf nodejs resolve lts --latest-available)
asdf global golang $(asdf list all golang | tail -n 1)
asdf global dotnet-core $(asdf list all dotnet-core | grep "^8" | tail -n 1)

if ! command -v colorls &> /dev/null; then
    printf '\033[0;32mInstalling colorls...\033[0m\n'
    sudo gem install colorls
fi

if ! command -v colorls &> /dev/null; then
    printf '\033[0;31mcolorls is required but not found\033[0m\n' >&2
    exit 1
fi

if ! command -v ansible-playbook &> /dev/null; then
    printf '\033[0;32mInstalling Ansible...\033[0m\n'
    brew install ansible bitwarden-cli
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


