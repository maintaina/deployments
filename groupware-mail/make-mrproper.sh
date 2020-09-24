#!/bin/bash

source .env ||exit

cp mariadb/domaintable.sql.dist mariadb/domaintable.sql
if [ ! -z "$HORDE_DOMAIN" ]; then
    sed -i "s/horde.dev.local/$HORDE_DOMAIN/" mariadb/domaintable.sql
fi

if [[ -v HORDE_DOMAIN ]]; then
    sed -i "s/conf\['problems'\]\['email'\].*/conf['problems']['email'] = '$HORDE_ADMIN_USER@$HORDE_DOMAIN';/g" original_config/apps/horde/conf.php
    sed -i "s/conf\['problems'\]\['maildomain'\].*/conf['problems']['maildomain'] = '$HORDE_DOMAIN';/g" original_config/apps/horde/conf.php
    sed -i "s/'maildomain' => 'horde\.dev\.local',/'maildomain' => '$HORDE_DOMAIN',/g" original_config/apps/imp/backends.local.php
fi

if [[ -v CONTAINER_PREFIX ]]; then
    sed -i "s/conf\['mailer'\]\['params'\]\['host'\].*/conf['mailer']['params']['host'] = '${CONTAINER_PREFIX}_postfix';/g" original_config/apps/horde/conf.php
    sed -i "s/'hostspec' => 'horde_dovecot',/'hostspec' => '${CONTAINER_PREFIX}_dovecot',/g" original_config/apps/imp/backends.local.php
    sed -i "s/'host' => 'horde_postfix',/'host' => '${CONTAINER_PREFIX}_postfix',/g" original_config/apps/imp/backends.local.php
fi

docker-compose down
docker-compose pull
docker-compose build
docker-compose up -d

rm mariadb/domaintable.sql
