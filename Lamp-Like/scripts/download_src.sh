#!/bin/bash

APP_DIR="/app/"

env_file="/git.env"
if [ -f "$env_file" ]; then
    export $(grep -v '^#' "$env_file" | xargs)
else
    echo "Erreur : Le fichier $env_file n'existe pas."
    send_discord_message "Échec du chargement du $1.env."
    exit 1
fi

git_url="https://$USER:$PASSWORD@git.jetbrains.space/3mty/descolar/descolar-back.git"

# Check if the destination folder exists, otherwise create it
if [ ! -d "$APP_DIR" ]; then
    mkdir -p "$APP_DIR"
fi

# Go to the destination folder
cd "$APP_DIR" || exit 1

echo  "Downloading the source from $git_url..."
# Clone the Git repository
git clone "$git_url"

# Check if the cloning was successful
if [ $? -eq 0 ]; then
    echo "The download from the source $git_url has been successfully done in $APP_DIR."
else
    echo "Error occurred during the download of the source from $git_url."
fi

# composer install
cd "$APP_DIR/descolar-back" || exit 1
composer install --no-interaction