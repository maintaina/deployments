#!/bin/bash

## If we have a .credentials file, source it
source ./.credentials

# start the containers
docker-compose up -d

## If we have a GITHUB_COMPOSER_TOKEN, we need to pass the auth credential  ## needs scope repo
docker exec -it -w /srv/www/horde horde_web composer config repositories.pear pear https://pear.php.net

if [[ -v GITHUB_COMPOSER_TOKEN ]]
then
    echo "Configuring authentication to Github API for composer"
    docker exec -it -w /srv/www/horde horde_web composer config -g github-oauth.github.com $GITHUB_COMPOSER_TOKEN
fi



# wait until database container is ready
echo "-"
echo "Waiting for the database to become accessible. You may see error messages for a while."
echo "-"
while ! docker exec horde_db mysql -uroot -phorde; do
    sleep 3
done

## Make sure the host signature of github is known to avoid annoying interactive prompts
#docker exec -it -w /srv/www/horde horde_web  "mkdir -p  /root/.ssh/ ; touch /root/.ssh/known_hosts ; ssh-keyscan github.com >> /root/.ssh/known_hosts"

# install Horde IMP Application
docker exec -w /srv/www/horde horde_web composer config repositories.pear pear https://pear.php.net
docker exec -w /srv/www/horde horde_web composer require horde/imp
docker exec -w /srv/www/horde horde_web composer require horde/socket_client

# copy basic config
docker cp ./conf.php horde_web:/srv/www/horde/web/horde/config/conf.php
# copy config for IMP
docker cp imp-conf.php horde_web:/srv/www/horde/web/imp/config/conf.php
# copy backends config for IMP
docker cp imp-backends.local.php horde_web:/srv/www/horde/web/imp/config/backends.local.php
#docker exec -it horde_dovecot bash

# set correct user for configs
docker exec -it horde_web chown -R wwwrun:www /srv/www/horde/web

# run the database migration scripts
docker exec -it horde_web /srv/www/horde/web/horde/bin/horde-db-migrate
# needs to be run twice because the first run does not create everything
docker exec -it horde_web /srv/www/horde/web/horde/bin/horde-db-migrate

# create user from cli
docker cp ./createUser.php horde_web:/srv/www/horde/web/horde/bin/createUser.php
docker exec -it horde_web /usr/bin/php /srv/www/horde/web/horde/bin/createUser.php
