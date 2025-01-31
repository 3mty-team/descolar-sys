#!/bin/bash

# Update the source code git repository in the container
echo "--------------------------------------------------"
echo "----------------------step 1----------------------"
echo "--------------------------------------------------"
docker exec -i Lamp-Like bash -c "cd /app/descolar-back && git reset --hard"
echo "--------------------------------------------------"
echo "----------------------step 2----------------------"
echo "--------------------------------------------------"
docker exec -i Lamp-Like bash -c "cd /app/descolar-back && git fetch && git pull origin main"
echo "--------------------------------------------------"
echo "----------------------step 3----------------------"
echo "--------------------------------------------------"
docker exec -i Lamp-Like bash -c "cd /app/descolar-back && rm composer.lock"
echo "composer.lock deleted"
echo "--------------------------------------------------"
echo "----------------------step 4----------------------"
echo "--------------------------------------------------"
docker exec -i Lamp-Like bash -c "cd /app/descolar-back && composer install --no-interaction"
echo "--------------------------------------------------"
echo "----------------------Finish----------------------"
echo "--------------------------------------------------"
