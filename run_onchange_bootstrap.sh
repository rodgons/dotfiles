#!/usr/bin/env bash

set -euo pipefail

if ! command -v brew &> /dev/null; then
    printf '\033[0;32mInstalling Homebrew...\033[0m\n'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! command -v brew &> /dev/null; then
    printf '\033[0;31mHomebrew is required but not found\033[0m\n' >&2
    exit 1
fi

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


