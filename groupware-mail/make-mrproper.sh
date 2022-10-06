#!/bin/bash

source ./.env || exit

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
    sed -i "s/conf\['mailer'\]\['params'\]\['host'\].*/conf['mailer']['params']['host'] = '${CONTAINER_PREFIX}horde_postfix';/g" original_config/apps/horde/conf.php
    sed -i "s/servers\['imap'\]\['hostspec'\].*/servers['imap']['hostspec'] = '${CONTAINER_PREFIX}horde_dovecot';/g" original_config/apps/imp/backends.local.php
    sed -i "s/servers\['imap'\]\['smtp'\]\['host'\].*/servers['imap']['smtp']['host'] = '${CONTAINER_PREFIX}horde_postfix';/g" original_config/apps/imp/backends.local.php
fi

echo "Stopping and removing containers"
docker stop ${CONTAINER_PREFIX}horde_web ${CONTAINER_PREFIX}horde_db 2>/dev/null
docker rm ${CONTAINER_PREFIX}horde_web 2>/dev/null
## Should do the same trick and also remove network
docker-compose down
echo "Updating Horde Base Image"
docker-compose pull
echo "Starting composer deployment"
# start the containers
docker-compose up -d

# cleanup
rm mariadb/domaintable.sql
echo "cleaned up sql-script"
