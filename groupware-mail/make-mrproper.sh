#!/bin/bash

source .env ||echo "The .env file is missing"

if [ ! -z "$HORDE_DOMAIN" ]; then
    sed "s/horde.dev.local/$HORDE_DOMAIN/" mariadb/domaintable.sql.dist > mariadb/domaintable.sql
fi

docker-compose down
docker-compose pull
docker-compose build
docker-compose up -d

rm mariadb/domaintable.sql
