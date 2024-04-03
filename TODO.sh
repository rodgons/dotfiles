#!/usr/bin/env bash

set -euo pipefail

# This script gets the Bitwarden item called "attachedSecrets" and downloads all
# attachments to the ".ssh" directory in the user's home directory
if [ -z "${BW_SESSION-}" ]; then
    export BW_SESSION=$(bw unlock --raw)
fi


echo "Start Syncing..."

bw sync

FILE=$(bw get item attachedSecrets)
echo "Got item attachedSecrets"

FILE_ID=$(jq -r .id <<< "$FILE")
ATTACHMENTS=$(jq -c '.attachments[] | {id, fileName}' <<< "$FILE")

echo $ATTACHMENTS

echo "Item attachedSecrets has $(jq length <<< "$ATTACHMENTS") attachments"


# if [ ! -d "$HOME/.ssh" ]; then
#     echo "Creating $HOME/.ssh directory"
#     mkdir -p "$HOME/.ssh"
# fi

# Loop over all attachments and download each one
# for attachment in $(jq -c . <<< "$ATTACHMENTS"); do
#     attachment_id=$(jq -r .id <<< "$attachment")
#     attachment_name=$(jq -r .fileName <<< "$attachment")

#     echo "Downloading attachment ${attachment_name} (ID: ${attachment_id})"
#     bw get attachment "$attachment_id" --itemid "$FILE_ID" --output "$HOME/.ssh/$attachment_name"
# done

echo "All done"

