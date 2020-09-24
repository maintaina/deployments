#!/bin/bash

source .env || exit

cp mariadb/domaintable.sql.dist mariadb/domaintable.sql

# configure the HORDE_DOMAIN in the database fixture
if [[ -v HORDE_DOMAIN && -n "$HORDE_DOMAIN" ]]; then
    sed -i "s/horde.dev.local/$HORDE_DOMAIN/" mariadb/domaintable.sql
fi

# set the HORDE_DOMAIN in Horde's and Imp's config files
if [[ -v HORDE_DOMAIN && -n "$HORDE_DOMAIN" ]]; then
    sed -i "s/conf\['problems'\]\['email'\].*/conf['problems']['email'] = '$HORDE_ADMIN_USER@$HORDE_DOMAIN';/g" original_config/apps/horde/conf.php
    sed -i "s/conf\['problems'\]\['maildomain'\].*/conf['problems']['maildomain'] = '$HORDE_DOMAIN';/g" original_config/apps/horde/conf.php
    sed -i "s/servers\['imap'\]\['maildomain'\].*/servers['imap']['maildomain'] = '$HORDE_DOMAIN';/g" original_config/apps/imp/backends.local.php
fi

# set the CONTAINER_PREFIX in Horde's and Imp's config files
if [[ -v CONTAINER_PREFIX && -n "$CONTAINER_PREFIX" ]]; then
    sed -i "s/conf\['mailer'\]\['params'\]\['host'\].*/conf['mailer']['params']['host'] = '${CONTAINER_PREFIX}_postfix';/g" original_config/apps/horde/conf.php
    sed -i "s/servers\['imap'\]\['hostspec'\].*/servers['imap']['hostspec'] = '${CONTAINER_PREFIX}_dovecot';/g" original_config/apps/imp/backends.local.php
    sed -i "s/servers\['imap'\]\['smtp'\]\['host'\].*/servers['imap']['smtp']['host'] = '${CONTAINER_PREFIX}_postfix';/g" original_config/apps/imp/backends.local.php
fi

docker-compose down
docker-compose pull
docker-compose build
docker-compose up -d

# cleanup
rm mariadb/domaintable.sql
