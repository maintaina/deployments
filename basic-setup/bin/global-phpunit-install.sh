#!/bin/bash
source .env
MASTERCONTAINER="${PREFIX_CONTAINER}horde_web"

CMD="command -v wget"
PHPUNITVERSION="phpunit-9.phar"
PHPUNITURL="https://phar.phpunit.de/$PHPUNITVERSION"


if ! docker exec -i "$MASTERCONTAINER" bash -c "$CMD" &> /dev/null
then
    echo "wget could not be found, installing it now"
    CMD="zypper -n install wget"
    docker exec -i  "$MASTERCONTAINER" bash -c "$CMD"
fi

CMD="cd /usr/local/bin/ && wget -O phpunit $PHPUNITURL && chmod +x phpunit && phpunit --version"
docker exec -i "$MASTERCONTAINER" bash -c "$CMD"
