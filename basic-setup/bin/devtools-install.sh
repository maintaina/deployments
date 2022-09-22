#!/bin/bash
source .env
MASTERCONTAINER="${PREFIX_CONTAINER}horde_web"
stuff="vim wget"
CMD="zypper -n install $stuff"
docker exec -i "$MASTERCONTAINER" bash -c "$CMD" 
echo "installing $stuff"
