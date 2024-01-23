#!/bin/bash

SCRIPT_DIR="/opt/cron"
ENV_DIR="/opt/dcompose/database/env"
BACKUP_DIR="/opt/backup"

# Charger les variables d'environnement depuis le fichier .env
load_env_file() {
  local env_file="$ENV_DIR/$1.env"
  if [ -f "$env_file" ]; then
      export $(grep -v '^#' "$env_file" | xargs)
  else
      echo "Erreur : Le fichier $env_file n'existe pas."
      send_discord_message "Échec du chargement du $1.env."
      exit 1
  fi
}

DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1180983116244983970/6LtInfnuBePQDNBnhWZOYyo3rqxURTX09CbplhS3KqebYVEeW5UB7lNthbtuqZkpusWC"
DB_HOST="127.0.0.1"
MYSQL_PORT=3306
DATE=$(date +"%Y-%m-%d")
ARCHIVE_NAME="${DATE}.tar.gz"

# Si on relance le script le même jour
rm -r "$BACKUP_DIR/$DATE"*

send_discord_message() {
    local message="$1"
    curl -X POST -H "Content-Type: application/json" -d "{\"content\":\"$message\"}" "$DISCORD_WEBHOOK_URL"
}

mkdir -p "$BACKUP_DIR"
for INSTANCE in "descolar-rec-db"; # descolar-prd-db mod-rec-db mod-prd-db;
do
    load_env_file "$INSTANCE"

    # Créer un fichier de configuration unique pour chaque instance dans le conteneur
    docker exec $INSTANCE bash -c "echo -e '[client]\nuser=descolar_backup_operator\npassword="4Cz%Y*@m6z4R8Hax"\nhost=$DB_HOST\nport=$MYSQL_PORT' > /etc/mysql/conf.d/$INSTANCE.cnf"

    if [ $? -ne 0 ]; then
        echo "Erreur lors de la création du fichier de configuration pour l'instance $INSTANCE."
        send_discord_message "Échec de la sauvegarde quotidienne de l'instance $INSTANCE."
        exit 1
    fi

    # Utiliser mysqldump avec le fichier de configuration dans le conteneur
    docker exec -i $INSTANCE mysqldump --defaults-extra-file="/etc/mysql/conf.d/$INSTANCE.cnf" --column-statistics=0 "$MYSQL_DATABASE" > "$BACKUP_DIR/${DATE}_$INSTANCE.sql"

    if [ $? -ne 0 ]; then
        echo "Erreur lors de la sauvegarde de l'instance $INSTANCE."
        send_discord_message "Échec de la sauvegarde quotidienne de l'instance $INSTANCE."
        exit 1
    fi
done

cd "$BACKUP_DIR" && find . -name "${DATE}*.sql" -type f -exec tar -czvf "$BACKUP_DIR/$ARCHIVE_NAME" -C "$BACKUP_DIR" {} +

if [ $? -ne 0 ]; then
    echo "Erreur lors de la création de l'archive."
    send_discord_message "Échec de la création de l'archive quotidienne."
    exit 1
fi

rm "$BACKUP_DIR/$DATE"*.sql

cd "$SCRIPT_DIR" || exit 1

sh ./upload_backup.sh "$BACKUP_DIR/$ARCHIVE_NAME"


send_discord_message "Sauvegarde quotidienne réussie : $ARCHIVE_NAME"
