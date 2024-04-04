#!/usr/bin/env bash

set -euo pipefail

# Ensure the Bitwarden CLI is installed
if ! command -v bw &> /dev/null; then
    printf '\033[0;31mBitwarden CLI is required but not found\033[0m\n' >&2
    printf '\033[0;31mPlease install it by running: brew install bitwarden-cli\033[0m\n' >&2
    exit 1
fi

bw login

# This script gets the Bitwarden item called "attachedSecrets" and downloads all
# attachments to the ".ssh" directory in the user's home directory
printf '\033[0;32mStarting Secrets sync\033[0m\n'
if [ -z "${BW_SESSION-}" ]; then
    export BW_SESSION=$(bw unlock --raw)
fi

bw sync

printf '\033[0;32mSyncing complete, getting item attachedSecrets\033[0m\n'
FILE=$(bw get item attachedSecrets)
FILE_ID=$(jq -r .id <<< "$FILE")
ATTACHMENTS=$(jq -c '.attachments[] | {id, fileName}' <<< "$FILE")

if [ ! -d "$HOME/.ssh" ]; then
    printf '\033[0;32mCreating %s directory\033[0m\n' "$HOME/.ssh"
    mkdir -p "$HOME/.ssh"
fi

# Loop over all attachments and download each one
for attachment in $(jq -c . <<< "$ATTACHMENTS"); do
    attachment_id=$(jq -r .id <<< "$attachment")
    attachment_name=$(jq -r .fileName <<< "$attachment")

    printf '\033[0;32mDownloading attachment %s (ID: %s)\033[0m\n' "$attachment_name" "$attachment_id"

    bw get attachment "$attachment_id" --itemid "$FILE_ID" --output "$HOME/.ssh/$attachment_name"
done

printf '\033[0;32mAll done\033[0m\n'

