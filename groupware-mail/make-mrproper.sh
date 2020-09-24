#!/bin/bash

source .env ||exit

cp mariadb/domaintable.sql.dist mariadb/domaintable.sql
if [ ! -z "$HORDE_DOMAIN" ]; then
    sed -i "s/horde.dev.local/$HORDE_DOMAIN/" mariadb/domaintable.sql
fi

docker-compose down
docker-compose pull
docker-compose build
docker-compose up -d

rm mariadb/domaintable.sql
