#!/bin/bash

## If we have a .credentials file, source it
source ./.credentials

## if we have a $GITHUB_REGISTRY_USERNAME and GITHUB_REGISTRY_TOKEN ## needs package:read
if [[ -v GITHUB_REGISTRY_USERNAME ]]
then
    echo "Logging in to github docker registry as user $GITHUB_REGISTRY_USERNAME";
    echo "docker login docker.pkg.github.com --username=\"$GITHUB_REGISTRY_USERNAME\" --password=\"SECRET_TOKEN_OMITTED\""
    docker login docker.pkg.github.com --username="$GITHUB_REGISTRY_USERNAME" --password="$GITHUB_REGISTRY_TOKEN"
fi

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

# set correct user for configs
docker exec -it horde_web chown -R wwwrun:www /srv/www/horde/web

# run the database migration scripts
docker exec -it horde_web /srv/www/horde/web/horde/bin/horde-db-migrate
# needs to be run twice because the first run does not create everything
docker exec -it horde_web /srv/www/horde/web/horde/bin/horde-db-migrate

# create user from cli
docker exec -it horde_web /usr/bin/php /srv/www/horde/web/horde/bin/createUser.php
