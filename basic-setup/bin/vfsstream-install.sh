#!/bin/bash
source .env
MASTERCONTAINER="${PREFIX_CONTAINER}horde_web"


CMD="composer require --dev mikey179/vfsstream"
docker exec -i "$MASTERCONTAINER" bash -c "$CMD" 
