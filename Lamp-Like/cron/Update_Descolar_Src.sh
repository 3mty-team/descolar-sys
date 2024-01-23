#!/bin/bash

# Update the source code git repository in the container
docker exec -i Lamp-Like bash -c "cd /app/descolar-back && git fetch && git pull origin main && composer install --no-interaction"